import 'dart:io';

import 'device_utils.dart';

class ArpUtils {
  /// 解析 ARP 表，返回 IP 到 MAC 的映射
  static Future<Map<String, String>> parseArpTable({
    required bool Function() shouldStop,
  }) async {
    final result = await _runArpCommand();
    final lines = result.stdout.split("\n");
    final isWindows = Platform.isWindows;
    final Map<String, String> ipMacMap = {};

    for (var line in lines) {
      if (shouldStop()) {
        print("停止解析 ARP 表");
        return ipMacMap;
      }
      line = line.trim();
      if (line.isEmpty) continue;

      if (isWindows) {
        if (line.contains("Interface") || line.contains("Internet Address")) {
          continue;
        }
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3 &&
            RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(parts[0])) {
          final ip = parts[0];
          final mac = DeviceUtils.normalizeMacAddress(parts[1]).toUpperCase();
          if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}').hasMatch(mac)) {
            ipMacMap[ip] = mac;
          }
        }
      } else {
        if (!line.contains(RegExp(r'\d+\.\d+\.\d+\.\d+'))) continue;
        line = line.replaceAll("at", "");
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 3) {
          final ip = parts[1].replaceAll("(", "").replaceAll(")", "");
          final mac = DeviceUtils.normalizeMacAddress(parts[2]).toUpperCase();
          if (RegExp(r'([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}').hasMatch(mac)) {
            ipMacMap[ip] = mac;
          }
        }
      }
    }
    return ipMacMap;
  }

  /// 执行 arp -a 命令
  static Future<ProcessResult> _runArpCommand() async {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      return await Process.run('arp', ['-a']);
    } else {
      throw Exception("不支持的平台");
    }
  }
}