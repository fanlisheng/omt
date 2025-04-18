import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:omt/page/home/device_add/view_models/device_add_viewmodel.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

import '../bean/home/home_page/device_entity.dart';
import 'arp_utils.dart'; // 引入新的 ArpUtils 类

class DeviceUtils {
  /// MAC 地址前缀映射设备类型
  Map<String, String> macDeviceTypeMap = {
    "24:32:AE": "NVR",
    "00:04:4B": "AI设备",
    "D4:E8:53": "摄像头",
    "C0:51:7E": "摄像头",
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
          return;
        }

        String ip = entry.key;
        String mac = entry.value;
        String deviceTypeText = getDeviceTypeForMacAddress(mac);

        if (deviceType != null && deviceTypeText != deviceType) {
          return;
        }

        if (ip == "$subnet.1") {
          if (deviceType == null || deviceType == "6") {
            infoList.add(DeviceEntity(
              ip: ip,
              mac: mac,
              deviceTypeText: "路由arez器",
              deviceType: getDeviceTypeInt("路由器"),
              deviceCode: "",
            ));
          }
        } else if (deviceTypeText.isNotEmpty) {
          DeviceEntity deviceEntity = DeviceEntity(
            ip: ip,
            mac: mac,
            deviceTypeText: deviceTypeText,
            deviceType: getDeviceTypeInt(deviceTypeText),
            deviceCode: "",
          );
          if (deviceTypeText == "AI设备" || deviceTypeText == "NVR") {
            String deviceCode = getDeviceCodeByMacAddress(macAddress: mac);
            deviceEntity.deviceCode = deviceCode;
            infoList.add(deviceEntity);
          } else {
            try {
              DeviceEntity? a = await hikvisionDeviceInfo(ipAddress: ip);
              if (a != null) {
                deviceEntity.deviceCode = a.deviceCode;
                infoList.add(deviceEntity);
              }
            } catch (e) {
              print("海康系统登录验证失败");
            }
          }
        }
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
      print(result.exitCode == 0 ? 'Ping 成功: $ip' : 'Ping 失败: $ip');
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
      // RTSP 地址的典型格式: rtsp://[username]:[password]@[ip_address]:[port]/[path]
      // 使用正则表达式提取 IP 地址部分
      final ipRegExp = RegExp(r'(\d+\.\d+\.\d+\.\d+)');
      final match = ipRegExp.firstMatch(rtspUrl);

      if (match != null) {
        final ip = match.group(0);
        // 验证提取的 IP 是否有效
        if (ip != null && _isValidIp(ip)) {
          return ip;
        }
      }

      // 如果正则匹配失败，尝试手动解析
      final uri = Uri.tryParse(rtspUrl);
      if (uri != null && uri.host.isNotEmpty && _isValidIp(uri.host)) {
        return uri.host;
      }

      return null; // 如果无法提取有效 IP，返回 null
    } catch (e) {
      print("提取 RTSP IP 失败: $e");
      return null;
    }
  }

  /// 格式化 MAC 地址
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
  };

  static int getDeviceTypeInt(String deviceTypeText) {
    return _deviceTypeMap[deviceTypeText] ?? 0;
  }

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
}
