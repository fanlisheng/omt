import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:omt/bean/home/home_page/local_device_entity.dart';
import 'package:xml/xml.dart' as xml;

Future<Map<String, String>> hkIsapiInit(String ipAddress) async {
  final headers = {
    "Accept": "text/html, application/xhtml+xml, */*",
    "Accept-Language": "zh-CN",
    "User-Agent": "",
    "Accept-Encoding": "gzip, deflate",
    "Host": ipAddress,
    "Connection": "Keep-Alive",
  };

  final response = await http.get(
    Uri.parse('http://$ipAddress:80/ISAPI/Security/userCheck'),
    headers: headers,
  );

  final authenticate = response.headers['www-authenticate'];
  if (authenticate == null) {
    throw Exception('Authentication header not found.');
  }

  final realm =
      RegExp(r'realm="(.*?)"').firstMatch(authenticate)?.group(1) ?? '';
  final qop = RegExp(r'qop="(.*?)"').firstMatch(authenticate)?.group(1) ?? '';
  final nonce =
      RegExp(r'nonce="(.*?)"').firstMatch(authenticate)?.group(1) ?? '';

  print('Realm: $realm, Qop: $qop, Nonce: $nonce');
  return {'realm': realm, 'qop': qop, 'nonce': nonce};
}

Map<String, String> configMd5Headers({
  required String ipAddress,
  required String username,
  required String realm,
  required String password,
  required String qop,
  required String nonce,
  required String uri,
  required String method,
}) {
  const nc = "00000001";
  final cnonce = md5.convert(utf8.encode(password)).toString();
  final a1 = '$username:$realm:$password';
  final a2 = '$method:$uri';

  final md5A1 = md5.convert(utf8.encode(a1)).toString();
  final md5A2 = md5.convert(utf8.encode(a2)).toString();
  final all = '$md5A1:$nonce:$nc:$cnonce:$qop:$md5A2';
  final md5All = md5.convert(utf8.encode(all)).toString();

  final authorization =
      'Digest username="$username",realm="$realm",nonce="$nonce",uri="$uri",'
      'cnonce="$cnonce",nc=$nc,response="$md5All",qop="$qop"';

  return {
    "Accept": "text/html, application/xhtml+xml, application/json, */*",
    "Accept-Language": "zh-CN",
    "User-Agent": "",
    "Accept-Encoding": "gzip, deflate",
    "Host": ipAddress,
    "Connection": "Keep-Alive",
    "Authorization": authorization,
  };
}

Future<LocalDeviceEntity?> hikvisionDeviceInfo({
  required String ipAddress,
  // required String username,
  // required String password,
}) async {
  final authData = await hkIsapiInit(ipAddress);

  final headers = configMd5Headers(
    ipAddress: ipAddress,
    username: "admin",
    realm: authData['realm']!,
    password: "flm2020hb",
    qop: authData['qop']!,
    nonce: authData['nonce']!,
    uri: '/ISAPI/System/deviceInfo',
    method: 'GET',
  );

  final response = await http.get(
    Uri.parse('http://$ipAddress:80/ISAPI/System/deviceInfo'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    print("Device Info: ${response.body}");
    final document = xml.XmlDocument.parse(response.body);
    final deviceName = document
            .findAllElements('deviceName')
            .map((e) => e.text)
            .firstOrNull ??
        '';
    final deviceType = document
            .findAllElements('deviceType')
            .map((e) => e.text)
            .firstOrNull ??
        '';
    final macAddress = document
            .findAllElements('macAddress')
            .map((e) => e.text)
            .firstOrNull ??
        '';

    return LocalDeviceEntity(
        deviceName: deviceName,
        deviceType: deviceType,
        macAddress: macAddress,
        ipAddress: ipAddress);
  } else {
    print("Failed to fetch device info. Status code: ${response.statusCode}");
    return null;
  }
}
