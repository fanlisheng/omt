import 'package:flutter/services.dart';

class MacAddressHelper {
  static const platform = MethodChannel('com.example.mac_address');

  // 获取 MAC 地址的方法
  static Future<String?> getMacAddress(String ip) async {
    try {
      // 调用平台方法并传递 IP 地址
      final String result = await platform.invokeMethod('getMacAddress', {'ip': ip});
      return result;
    } on PlatformException catch (e) {
      print("Failed to get MAC address: ${e.message}");
      return null;
    }
  }

  static String getMacAddressWithString(String input) {
    RegExp regex = RegExp(r'([0-9a-fA-F]{2}[:\-]){5}([0-9a-fA-F]{2})');
    RegExpMatch? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    } else {
      throw 'MAC address not found';
    }
  }

}

void fetchMacAddress(String ip) async {
  String? macAddress = await MacAddressHelper.getMacAddress(ip);
  if (macAddress != null) {
    print("MAC 地址: $macAddress");
  } else {
    print("未能获取 MAC 地址");
  }
}
