import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';
import 'package:omt/page/home/device_add/view_models/device_add_viewmodel.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

import '../bean/home/home_page/device_entity.dart';

class DeviceUtils {
  /// MAC 地址前缀映射设备类型
  Map<String, String> macDeviceTypeMap = {
    "24:32:AE": "NVR",
    "00:04:4B": "AI设备",
    "D4:E8:53": "摄像头",
    "C0:51:7E": "摄像头",
  };

  /// 扫描设备并获取设备信息，支持中断
  static Future<List<DeviceEntity>> scanAndFetchDevicesInfo(
      {required bool Function() shouldStop}) async {
    List<DeviceEntity> infoList = [];

    // 1. 获取本机 IP（确定局域网段）
    String? subnet = await getSubnet();
    if (subnet == null) {
      print("无法获取子网");
      return infoList;
    }

    // // 2. 获取并发任务，分批处理
    List<Future<void>> pingTasks = [];
    const batchSize = 50; // 每批次同时处理的数量
    for (int i = 1; i < 255; i++) {
      String ip = "$subnet.$i";
      pingTasks.add(pingDevice(ip, shouldStop));

      // 每批次执行 `batchSize` 个任务
      if (pingTasks.length == batchSize || i == 254) {
        await Future.wait(pingTasks);
        pingTasks.clear(); // 清空当前任务队列
      }

      if (shouldStop()) {
        print("扫描被中断");
        return infoList; // 中断时退出循环
      }
    }

    // 3. 获取所有IP的mac地址（支持中断）
    Map<String, String>? ipMac = await getMacAddresses(shouldStop: shouldStop);
    if (ipMac == null) {
      print("无法获取 MAC 地址");
      return infoList;
    }

    // 4. 循环所有 ipMac（支持中断）
    List<Future<void>> getInfoTasks = [];
    for (var entry in ipMac.entries) {
      getInfoTasks.add(Future<void>(() async {
        if (shouldStop()) {
          print("扫描被中断");
          return; // 中断时退出循环
        }

        String ip = entry.key;
        String mac = entry.value;
        String deviceTypeText = getDeviceTypeForMacAddress(mac);

        if (ip == "$subnet.1") {
          //路由器
          infoList.add(DeviceEntity(
              ip: ip,
              mac: mac,
              deviceTypeText: "路由器",
              deviceType: getDeviceType("路由器"),
              deviceCode: ""));
        } else {
          if (deviceTypeText.isNotEmpty) {
            DeviceEntity deviceEntity = DeviceEntity(
                ip: ip,
                mac: mac,
                deviceTypeText: deviceTypeText,
                deviceType: getDeviceType(deviceTypeText),
                deviceCode: "");
            if (deviceTypeText == "AI设备") {
              String deviceCode = mac.replaceAll(":", "");
              deviceCode = deviceCode.toLowerCase();
              deviceEntity.deviceCode = deviceCode;
              infoList.add(deviceEntity);
            } else {
              // 通过海康系统登录验证
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
        }

        if (shouldStop()) {
          print("扫描被中断");
          return; // 中断时退出循环
        }
      }));
    }

    await Future.wait(getInfoTasks);
    return infoList;
  }

  /// 发送 ping 请求，强制设备进入 ARP 表，支持中断
  static Future<void> pingDevice(String ip, bool Function() shouldStop) async {
    // 检查是否需要停止
    if (shouldStop()) {
      print("停止 ping 扫描");
      return; // 如果满足中断条件，立即返回
    }
    try {
      final result = await Process.run('ping', ['-c', '1', '-W', '1', ip]);
      if (result.exitCode == 0) {
        print('Ping 成功: $ip');
      } else {
        print('Ping 失败: $ip');
      }
    } catch (e) {
      print('Ping 错误: $e');
    }
  }

  /// 获取 MAC 地址列表（适用于 macOS/Linux/Windows），支持中断
  static Future<Map<String, String>?> getMacAddresses(
      {required bool Function() shouldStop}) async {
    Map<String, String> ipMacMap = {};

    ProcessResult result;
    if (Platform.isMacOS || Platform.isLinux) {
      result = await Process.run('arp', ['-a']);
    } else if (Platform.isWindows) {
      result = await Process.run('arp', ['-a']);
    } else {
      throw Exception("不支持的平台");
    }

    List<String> lines = result.stdout.toString().split("\n");
    for (var line in lines) {
      if (shouldStop()) {
        print("停止获取 MAC 地址");
        return ipMacMap; // 如果满足中断条件，返回当前的结果并停止
      }

      List<String> parts = line.split(RegExp(r'\s+'));
      if (parts.length >= 3) {
        String ip = parts[1].replaceAll("(", "").replaceAll(")", "");
        String mac = parts[3].toUpperCase();
        String normalizedMac = normalizeMacAddress(mac);
        if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}')
            .hasMatch(normalizedMac)) {
          ipMacMap[ip] = normalizedMac;
        }
      }
    }

    return ipMacMap;
  }

  /// 格式化 MAC 地址，确保每组都有两个字符
  static String normalizeMacAddress(String mac) {
    return mac.split(':').map((part) {
      return part.length == 1 ? '0$part' : part;
    }).join(':');
  }

  /// 根据 MAC 地址返回设备类型
  static String getDeviceTypeForMacAddress(String macAddress) {
    String macPrefix = macAddress.toUpperCase().substring(0, 8);
    return DeviceUtils().macDeviceTypeMap[macPrefix] ?? "";
  }

  /// 获取本机 IP 的子网前缀（如 192.168.1）
  static Future<String?> getSubnet() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith("192.168.")) {
          List<String> parts = addr.address.split(".");
          return "${parts[0]}.${parts[1]}.${parts[2]}";
        }
      }
    }
    return null;
  }

  // device_type：设备类型
  // 5:电源箱；6：路由器；8：NVR；9：交换机；10：AI设备（工控机）；11：摄像头；
// 设备类型映射
  static const Map<String, int> _deviceTypeMap = {
    "电源箱": 5,
    "路由器": 6,
    "NVR": 8,
    "交换机": 9,
    "AI设备": 10,
    "摄像头": 11,
  };

  // 设备类型名称映射
  static const Map<DeviceType, String> _deviceTypeNameMap = {
    DeviceType.ai: "AI设备",
    DeviceType.power: "电源",
    DeviceType.nvr: "NVR",
    DeviceType.powerBox: "电源箱",
    DeviceType.battery: "电池",
    DeviceType.exchange: "交换机",
    DeviceType.camera: "摄像头",
  };

  // 设备图片映射
  static const Map<String, String> _deviceImageMap = {
    "NVR": "home/ic_device_nvr",
    "AI设备": "home/ic_device_ai",
    "摄像头": "home/ic_device_camera",
    "路由器": "home/ic_device_router",
  };

  /// 获取设备类型（根据设备名称）
  static int getDeviceType(String deviceTypeText) {
    return _deviceTypeMap[deviceTypeText] ?? 0;
  }

  /// 获取设备图片路径
  static String getDeviceImage(String deviceTypeText) {
    return _deviceImageMap[deviceTypeText] ?? "";
  }

  /// 获取设备类型名称
  static String getDeviceTypeName(DeviceType type) {
    return _deviceTypeNameMap[type] ?? "未知设备";
  }
}
