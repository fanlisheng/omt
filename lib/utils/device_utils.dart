import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:network_info_plus/network_info_plus.dart';
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
    const batchSize = 70; // 每批次同时处理的数量
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

        if (ip == "192.168.101.82") {
          print("------------");
        }
        String deviceTypeText = getDeviceTypeForMacAddress(mac);

        if (ip == "$subnet.1") {
          //路由器
          infoList.add(DeviceEntity(
              ip: ip,
              mac: mac,
              deviceTypeText: "路由器",
              deviceType: getDeviceTypeInt("路由器"),
              deviceCode: ""));
        } else {
          if (deviceTypeText.isNotEmpty) {
            DeviceEntity deviceEntity = DeviceEntity(
                ip: ip,
                mac: mac,
                deviceTypeText: deviceTypeText,
                deviceType: getDeviceTypeInt(deviceTypeText),
                deviceCode: "");
            if (deviceTypeText == "AI设备" || deviceTypeText == "NVR") {
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
      final isWindows = Platform.isWindows;
      final List<String> arguments;

      if (isWindows) {
        // Windows CMD 参数
        arguments = ['-n', '1', '-w', '1000', ip];
      } else {
        // Linux/macOS 参数
        arguments = ['-c', '1', '-W', '1', ip];
      }
      final result = await Process.run('ping', arguments);
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
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      result = await Process.run('arp', ['-a']);
    } else {
      throw Exception("不支持的平台");
    }

    final lines = result.stdout.split("\n");
    final isWindows = Platform.isWindows;
    for (var line in lines) {
      if (shouldStop != null && shouldStop()) {
        print("停止获取 MAC 地址");
        return ipMacMap;
      }
      line = line.trim();
      if (line.isEmpty) continue;

      if (isWindows) {
        if (line.contains("Interface") || line.contains("Internet Address"))
          continue;
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3 &&
            RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(parts[0])) {
          final ip = parts[0];
          final mac = parts[1].toUpperCase();
          final normalizedMac = normalizeMacAddress(mac);
          if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}')
              .hasMatch(normalizedMac)) {
            ipMacMap[ip] = normalizedMac;
          }
        }
      } else {
        if (!line.contains(RegExp(r'\d+\.\d+\.\d+\.\d+'))) continue;
        line = line.replaceAll("at", "");
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3) {
          final ip = parts[1].replaceAll("(", "").replaceAll(")", "");
          final mac = parts[2].toUpperCase();
          final normalizedMac = normalizeMacAddress(mac);
          if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}')
              .hasMatch(normalizedMac)) {
            ipMacMap[ip] = normalizedMac;
          }
        }
      }
    }

    return ipMacMap;
  }

  /// 格式化 MAC 地址，确保每组都有两个字符
  static String normalizeMacAddress(String mac) {
    // 处理空输入或无效输入
    if (mac.isEmpty ||
        !RegExp(r'^([0-9A-Fa-f]{1,2}[:-]){5}[0-9A-Fa-f]{1,2}$').hasMatch(mac)) {
      return mac; // 返回原始输入或抛出异常，取决于需求
    }

    // 统一分隔符为冒号，并移除多余字符
    final normalized = mac.replaceAll('-', ':').toUpperCase();

    // 分割并补齐前导零
    return normalized.split(':').map((part) {
      return part.padLeft(2, '0'); // 补前导零至两位
    }).join(':');
  }

  /// 根据 MAC 地址返回设备类型
  static String getDeviceTypeForMacAddress(String macAddress) {
    String macPrefix = macAddress.toUpperCase().substring(0, 8);
    return DeviceUtils().macDeviceTypeMap[macPrefix] ?? "";
  }

  static Future<String?> getCurrentDeviceMacAddress() async {
    ProcessResult result;

    try {
      if (Platform.isMacOS) {
        // macOS: 使用 networksetup 或 ifconfig 获取当前设备的 MAC
        result = await Process.run('ifconfig', ['en0']); // en0 通常是 Wi-Fi 接口
        String output = result.stdout.toString();
        RegExp macRegExp = RegExp(r'ether\s([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}');
        Match? match = macRegExp.firstMatch(output);
        if (match != null) {
          return match.group(0)!.replaceAll('ether ', '').trim();
        }
      } else if (Platform.isLinux) {
        // Linux: 使用 ip 或 ifconfig 获取 MAC
        result = await Process.run('ip', ['link', 'show']);
        String output = result.stdout.toString();
        RegExp macRegExp =
            RegExp(r'link/ether\s([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}');
        Match? match = macRegExp.firstMatch(output);
        if (match != null) {
          return match.group(0)!.replaceAll('link/ether ', '').trim();
        }
      } else if (Platform.isWindows) {
        // Windows: 使用 getmac 或 ipconfig 获取 MAC
        result = await Process.run('getmac', []);
        String output = result.stdout.toString();
        RegExp macRegExp = RegExp(r'([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}');
        Match? match = macRegExp.firstMatch(output);
        if (match != null) {
          return match.group(0)!.replaceAll('-', ':');
        }
      } else {
        throw Exception("不支持的平台");
      }
    } catch (e) {
      print("获取 MAC 地址失败: $e");
    }
    return null;
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
    "NVR": "home/ic_device_nvr2",
    "AI设备": "home/ic_device_aisb",
    "摄像头": "home/ic_device_sxt",
    "路由器": "home/ic_device_lyq",
  };

  static const Map<int, DeviceType> intToDeviceTypeMap = {
    5: DeviceType.powerBox,
    6: DeviceType.router, // 如果没有 router，需补充到 DeviceType 枚举
    8: DeviceType.nvr,
    9: DeviceType.exchange,
    10: DeviceType.ai,
    11: DeviceType.camera,
  };

  /// 获取设备类型（根据设备名称）
  static int getDeviceTypeInt(String deviceTypeText) {
    return _deviceTypeMap[deviceTypeText] ?? 0;
  }

  static String getDeviceTypeString(int deviceType) {
    final entry = _deviceTypeMap.entries.firstWhere(
      (element) => element.value == deviceType,
      orElse: () => const MapEntry('', -1), // 如果没有找到对应的 value，返回空的 MapEntry
    );
    return entry.key.isNotEmpty ? entry.key : "-"; // 如果找到 key，则返回，否则返回 null
  }

  /// 获取设备图片路径
  static String getDeviceImage(int deviceType) {
    return _deviceImageMap[getDeviceTypeString(deviceType)] ?? "";
  }

  /// 获取设备类型名称
  static String getDeviceTypeName(DeviceType type) {
    return _deviceTypeNameMap[type] ?? "未知设备";
  }

  static DeviceType? getDeviceTypeFromInt(int value) {
    return intToDeviceTypeMap[value];
  }

  static Future<String?> getMacAddressByIp(
      {required String ip, required bool Function() shouldStop}) async {
    ProcessResult result;
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      result = await Process.run('arp', ['-a']);
    } else {
      throw Exception("不支持的平台");
    }

    final lines = result.stdout.split("\n");
    final isWindows = Platform.isWindows;

    for (var line in lines) {
      if (shouldStop()) {
        print("停止获取 MAC 地址");
        return null;
      }
      line = line.trim();
      if (line.isEmpty) continue;

      if (isWindows) {
        if (line.contains("Interface") || line.contains("Internet Address"))
          continue;
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3 &&
            RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(parts[0])) {
          final currentIp = parts[0];
          if (currentIp == ip) {
            final mac = parts[1].toUpperCase();
            final normalizedMac = normalizeMacAddress(mac);
            if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}')
                .hasMatch(normalizedMac)) {
              return normalizedMac;
            }
          }
        }
      } else {
        if (!line.contains(RegExp(r'\d+\.\d+\.\d+\.\d+'))) continue;
        line = line.replaceAll("at", "");
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3) {
          final currentIp = parts[1].replaceAll("(", "").replaceAll(")", "");
          if (currentIp == ip) {
            final mac = parts[2].toUpperCase();
            final normalizedMac = normalizeMacAddress(mac);
            if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}')
                .hasMatch(normalizedMac)) {
              return normalizedMac;
            }
          }
        }
      }
    }

    return null; // 如果没有找到匹配的 IP，返回 null
  }

  static getNetworkMac({ValueChanged<String?>? onData}) async {
    var subnet = await getSubnet();
    String? mac = '';
    if (null != subnet && subnet.isNotEmpty) {
      subnet = '$subnet.1';
      mac = await getMacAddressByIp(ip: subnet, shouldStop: () => false);
    }
    onData?.call(mac);
  }
}
