import 'dart:io';
import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:omt/page/home/device_add/view_models/device_add_viewmodel.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:omt/http/service/video/video_configuration_service.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';

import '../bean/home/home_page/device_entity.dart';
import 'arp_utils.dart'; // 引入新的 ArpUtils 类

class DeviceUtils {
  /// MAC 地址前缀映射设备类型
  Map<String, String> macDeviceTypeMap = {
    // "24:32:AE": "NVR",
    // "24:28:FD": "NVR",
    "00:04:4B": "AI设备",
    // "D4:E8:53": "摄像头",
    // "C0:51:7E": "摄像头",
  };

  /// 扫描设备并获取设备信息，支持中断
  static Future<List<DeviceEntity>> scanAndFetchDevicesInfo({
    bool Function()? shouldStop,
    String? deviceType,
  }) async {
    List<DeviceEntity> infoList = [];

    // 1. 获取本机 IP（确定局域网段）
    String? subnet = await getSubnet();
    if (subnet == null) {
      print("无法获取子网");
      return infoList;
    }

    // 2. 获取并发任务，分批处理
    List<Future<void>> pingTasks = [];
    const batchSize = 70;
    for (int i = 1; i < 255; i++) {
      String ip = "$subnet.$i";
      pingTasks.add(pingDevice(ip, shouldStop ?? (() => false)));

      if (pingTasks.length == batchSize || i == 254) {
        await Future.wait(pingTasks);
        pingTasks.clear();
      }

      if (shouldStop?.call() ?? false) {
        print("扫描被中断");
        // 扫描被中断时取消加载动画
        try {
          LoadingUtils.dismiss();
        } catch (e) {
          print("取消加载动画失败: $e");
        }
        return infoList;
      }
    }

    // 3. 获取所有 IP 的 MAC 地址
    Map<String, String>? ipMac =
        await getMacAddresses(shouldStop: shouldStop ?? (() => false));
    if (ipMac == null) {
      print("无法获取 MAC 地址");
      return infoList;
    }

    // 4. 循环所有 ipMac
    List<Future<void>> getInfoTasks = [];
    for (var entry in ipMac.entries) {
      getInfoTasks.add(Future<void>(() async {
        if (shouldStop?.call() ?? false) {
          print("扫描被中断");
          // 扫描被中断时取消加载动画
          try {
            LoadingUtils.dismiss();
          } catch (e) {
            print("取消加载动画失败: $e");
          }
          return;
        }

        String ip = entry.key;
        String mac = entry.value;
        String deviceTypeText = getDeviceTypeForMacAddress(mac);

        DeviceEntity? deviceEntity;

        if (ip == "$subnet.1") {
          deviceEntity = DeviceEntity(
            ip: ip,
            mac: mac,
            deviceTypeText: "路由器",
            deviceType: getDeviceTypeInt("路由器"),
            deviceCode: "",
          );
        } else {
          if (deviceTypeText == "AI设备") {
            deviceEntity = DeviceEntity(
              ip: ip,
              mac: mac,
              deviceTypeText: deviceTypeText,
              deviceType: getDeviceTypeInt(deviceTypeText),
              deviceCode: getDeviceCodeByMacAddress(macAddress: mac),
            );
          } else {
            //摄像头
            try {
              DeviceEntity? a = await hikvisionDeviceInfo(ipAddress: ip);
              if (ip == "192.168.101.155") {
                LogUtils.info(msg: "192.168.101.155 ---------${a.toString()}");
              }
              if (a != null) {
                deviceEntity = a;
              }
            } catch (e) {
              print("海康系统登录验证失败");
            }
          }
        }

        if ((deviceEntity == null) ||
            (deviceType != null && deviceEntity.deviceTypeText != deviceType)) {
          return;
        }
        infoList.add(deviceEntity);
      }));
    }

    await Future.wait(getInfoTasks);
    return infoList;
  }

  /// 发送 ping 请求，强制设备进入 ARP 表
  static Future<void> pingDevice(String ip, bool Function() shouldStop) async {
    if (shouldStop()) {
      print("停止 ping 扫描");
      return;
    }
    try {
      final isWindows = Platform.isWindows;
      final List<String> arguments = isWindows
          ? ['-n', '1', '-w', '1000', ip]
          : ['-c', '1', '-W', '1', ip];
      final result = await Process.run('ping', arguments);
      // print(result.exitCode == 0 ? 'Ping 成功: $ip' : 'Ping 失败: $ip');
    } catch (e) {
      print('Ping 错误: $e');
    }
  }

  /// 获取 MAC 地址列表
  static Future<Map<String, String>?> getMacAddresses({
    required bool Function() shouldStop,
  }) async {
    final ipMacMap = await ArpUtils.parseArpTable(shouldStop: shouldStop);
    return ipMacMap.isNotEmpty ? ipMacMap : null;
  }

  /// 获取当前设备 MAC 地址
  static Future<String?> getCurrentDeviceMacAddress() async {
    try {
      ProcessResult result;
      if (Platform.isMacOS) {
        result = await Process.run('ifconfig', ['en0']);
        final match = RegExp(r'ether\s([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
            .firstMatch(result.stdout.toString());
        if (match != null)
          return match.group(0)!.replaceAll('ether ', '').trim();
      } else if (Platform.isLinux) {
        result = await Process.run('ip', ['link', 'show']);
        final match = RegExp(r'link/ether\s([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
            .firstMatch(result.stdout.toString());
        if (match != null) {
          return match.group(0)!.replaceAll('link/ether ', '').trim();
        }
      } else if (Platform.isWindows) {
        result = await Process.run('getmac', []);
        final match = RegExp(r'([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}')
            .firstMatch(result.stdout.toString());
        if (match != null) return match.group(0)!.replaceAll('-', ':');
      } else {
        throw Exception("不支持的平台");
      }
    } catch (e) {
      print("获取 MAC 地址失败: $e");
    }
    return null;
  }

  /// 获取本机 IP 的子网前缀
  static Future<String?> getSubnet() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith("192.168.")) {
          final parts = addr.address.split(".");
          return "${parts[0]}.${parts[1]}.${parts[2]}";
        }
      }
    }
    return null;
  }

  /// 根据 IP 获取 MAC 地址
  static Future<String?> getMacAddressByIp({
    required String ip,
    bool Function()? shouldStop,
  }) async {
    await pingDevice(ip, shouldStop ?? () => false);
    final arpTable =
        await ArpUtils.parseArpTable(shouldStop: shouldStop ?? () => false);
    return arpTable[ip];
  }

  /// 根据 MAC 地址获取 IP 地址
  static Future<String?> getIpAddressByMac({
    required String macAddress,
    bool Function()? shouldStop,
  }) async {
    final normalizedInputMac = normalizeMacAddress(macAddress).toUpperCase();
    final arpTable =
        await ArpUtils.parseArpTable(shouldStop: shouldStop ?? () => false);
    return arpTable.entries
            .firstWhere(
              (entry) => entry.value == normalizedInputMac,
              orElse: () => const MapEntry("", ""),
            )
            .key
            .isNotEmpty
        ? arpTable.entries
            .firstWhere((entry) => entry.value == normalizedInputMac)
            .key
        : null;
  }

  /// 获取网络 MAC 地址
  static Future<void> getNetworkMac({ValueChanged<String?>? onData}) async {
    final subnet = await getSubnet();
    String? mac;
    if (subnet != null && subnet.isNotEmpty) {
      mac = await getMacAddressByIp(ip: '$subnet.1', shouldStop: () => false);
    }
    onData?.call(mac);
  }

  /// 根据 MAC 获取 DeviceCode
  static String getDeviceCodeByMacAddress({required String macAddress}) {
    return macAddress.replaceAll(":", "").toLowerCase();
  }

  /// 根据 DeviceCode 获取 MAC 地址
  static String getMacAddressByDeviceCode({required String deviceCode}) {
    if (deviceCode.length != 12) {
      throw const FormatException("Mac地址不正确");
    }
    String macAddress = '';
    for (int i = 0; i < deviceCode.length; i += 2) {
      macAddress += deviceCode.substring(i, i + 2);
      if (i < deviceCode.length - 2) macAddress += ':';
    }
    return macAddress.toUpperCase();
  }

  /// 从 RTSP 地址中提取 IP 地址
  static String? getIpFromRtsp(String rtspUrl) {
    try {
      final uri = Uri.parse(rtspUrl);
      return uri.host;
    } catch (e) {
      LogUtils.info(msg: "解析RTSP地址失败: $e");
      return null;
    }
  }

  /// 标准化MAC地址格式（统一为大写，用冒号分隔，确保每段为2位）
  static String normalizeMacAddress(String mac) {
    if (mac.isEmpty ||
        !RegExp(r'^([0-9A-Fa-f]{1,2}[:-]){5}[0-9A-Fa-f]{1,2}$').hasMatch(mac)) {
      return mac;
    }
    return mac.replaceAll('-', ':').toUpperCase().split(':').map((part) {
      return part.padLeft(2, '0');
    }).join(':');
  }

  // 设备类型映射
  static const Map<String, int> _deviceTypeMap = {
    "电源箱": 5,
    "路由器": 6,
    "NVR": 8,
    "交换机": 9,
    "AI设备": 10,
    "摄像头": 11,
  };

  static const Map<DeviceType, String> _deviceTypeNameMap = {
    DeviceType.ai: "AI设备",
    DeviceType.power: "电源",
    DeviceType.nvr: "NVR",
    DeviceType.powerBox: "电源箱",
    DeviceType.battery: "电池",
    DeviceType.mainsPower: "市电",
    DeviceType.exchange: "交换机",
    DeviceType.camera: "摄像头",
    DeviceType.router: "路由器",
  };

  static const Map<String, String> _deviceImageMap = {
    "8": "home/ic_device_nvr2",
    "10": "home/ic_device_aisb",
    "11": "home/ic_device_sxt",
    "6": "home/ic_device_lyq",
    "9": "home/ic_device_jhj",
    "12": "home/ic_device_sd",
    "13": "home/ic_device_dc",
    "5": "home/ic_device_dyx",
    "7": "home/ic_device_yxwl",
    "4": "home/ic_device_dc",
  };

  static const Map<int, DeviceType> intToDeviceTypeMap = {
    5: DeviceType.powerBox,
    6: DeviceType.router,
    8: DeviceType.nvr,
    9: DeviceType.exchange,
    10: DeviceType.ai,
    11: DeviceType.camera,
    12: DeviceType.mainsPower,  // 电池
    13: DeviceType.battery,  // 电池
  };

  static int getDeviceTypeInt(String deviceTypeText) {
    return _deviceTypeMap[deviceTypeText] ?? 0;
  }

  /// 根据设备类型int获取中文名称
  /// 通过 intToDeviceTypeMap 获取 DeviceType，再调用 getDeviceTypeName(DeviceType) 获取名称
  static String getDeviceTypeNameByInt(int deviceType) {
    final deviceTypeEnum = intToDeviceTypeMap[deviceType];
    if (deviceTypeEnum == null) {
      return '未知设备';
    }
    return getDeviceTypeName(deviceTypeEnum);
  }

  /// 获取所有可统计的设备类型int列表
  static List<int> get countableDeviceTypes => intToDeviceTypeMap.keys.toList();

  static String getDeviceTypeForMacAddress(String macAddress) {
    String macPrefix = macAddress.toUpperCase().substring(0, 8);
    return DeviceUtils().macDeviceTypeMap[macPrefix] ?? "";
  }

  static String getDeviceTypeString(int deviceType) {
    final entry = _deviceTypeMap.entries.firstWhere(
      (element) => element.value == deviceType,
      orElse: () => const MapEntry('', -1),
    );
    return entry.key.isNotEmpty ? entry.key : "-";
  }

  static String getDeviceImage(int deviceType) {
    return _deviceImageMap["$deviceType"] ?? "";
  }

  static String getDeviceTypeName(DeviceType type) {
    return _deviceTypeNameMap[type] ?? "未知设备";
  }

  static DeviceType? getDeviceTypeFromInt(int value) {
    return intToDeviceTypeMap[value];
  }

  /// 验证是否为有效 IP 地址
  static bool _isValidIp(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    for (var part in parts) {
      if (part.isEmpty ||
          int.tryParse(part) == null ||
          int.parse(part) > 255 ||
          int.parse(part) < 0) {
        return false;
      }
    }
    return true;
  }

  /// 获取AI设备上的摄像头UDID列表
  static Future<Map<String, String>> getAiDeviceCameraUdids(String aiDeviceIp) async {
    final completer = Completer<Map<String, String>>();
    final Map<String, String> ipToUdidMap = {};
    
    try {
      
      final String deviceInfoUuidUrl = API.share.buildDeviceWebcamUrl(aiDeviceIp, VideoConfigurationService.webcamDeviceCodeInfo);
      
      HttpManager.share.doHttpPost<List<dynamic>?>(
        deviceInfoUuidUrl,
        {},
        method: 'get',
        autoHideDialog: false,
        autoShowDialog: false,
        onSuccess: (List<dynamic>? cameras) async {
          if (cameras != null) {
            for (var camera in cameras) {
              if (camera is Map<String, dynamic>) {
                String? ip = camera["ip"] as String?;
                String? udid = camera["udid"] as String?;
                if (ip != null && udid != null) {
                  ipToUdidMap[ip] = udid;
                }
              }
            }
          }
          completer.complete(ipToUdidMap);
        },
        onError: (String error) {
          LogUtils.info(msg: "获取AI设备${aiDeviceIp}摄像头列表失败: $error");
          completer.complete(ipToUdidMap);
        },
      );
      
      // 设置超时时间，避免无限等待
      Future.delayed(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          LogUtils.info(msg: "获取AI设备${aiDeviceIp}摄像头UDID超时");
          completer.complete(ipToUdidMap);
        }
      });
      
    } catch (e) {
      LogUtils.info(msg: "获取AI设备摄像头UDID异常: $e");
      completer.complete(ipToUdidMap);
    }
    
    return completer.future;
  }

  /// 为扫描到的设备添加UDID信息
  static Future<List<DeviceEntity>> enrichDevicesWithUdids(
    List<DeviceEntity> devices, {
    bool Function()? shouldStop,
  }) async {
    if (devices.isEmpty || (shouldStop?.call() ?? false)) {
      return devices;
    }
    
    // 找出所有AI设备
    final aiDevices = devices.where((device) => 
      device.deviceTypeText == "AI设备" && device.ip != null).toList();
    
    if (aiDevices.isEmpty) {
      LogUtils.info(msg: "未发现AI设备，跳过UDID获取");
      return devices;
    }
    
    LogUtils.info(msg: "发现${aiDevices.length}个AI设备，开始获取摄像头UDID");
    
    // 并发处理所有AI设备
    final List<Future<Map<String, String>>> udidTasks = [];
    
    for (var aiDevice in aiDevices) {
      if (shouldStop?.call() ?? false) {
        break;
      }
      
      if (aiDevice.ip != null) {
        udidTasks.add(getAiDeviceCameraUdids(aiDevice.ip!));
      }
    }
    
    if (udidTasks.isEmpty) {
      return devices;
    }
    
    try {
      // 等待所有AI设备的UDID获取完成
      final List<Map<String, String>> udidMaps = await Future.wait(
          udidTasks, eagerError: false);
      
      if (shouldStop?.call() ?? false) {
        return devices;
      }
      
      // 合并所有UDID映射
      final Map<String, String> allIpToUdidMap = {};
      for (var udidMap in udidMaps) {
        allIpToUdidMap.addAll(udidMap);
      }
      
      if (allIpToUdidMap.isEmpty) {
        LogUtils.info(msg: "未获取到任何摄像头UDID");
        return devices;
      }
      
      // 直接通过IP地址查找对应设备并设置UDID
      int matchedCount = 0;
      for (var ipAddress in allIpToUdidMap.keys) {
        if (shouldStop?.call() ?? false) {
          break;
        }
        
        // 在设备列表中查找匹配的IP地址
        for (var device in devices) {
          if (device.ip != null && device.ip == ipAddress) {
            device.deviceCode = allIpToUdidMap[ipAddress];
            matchedCount++;
            break; // 找到匹配的设备后跳出内层循环
          }
        }
      }
      
      LogUtils.info(msg: "成功为${matchedCount}个设备匹配UDID");
      
    } catch (e) {
      LogUtils.info(msg: "获取摄像头UDID过程中出错: $e");
    }
    
    return devices;
  }
}
