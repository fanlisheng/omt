import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/shared_utils.dart';

///
///  tfblue_app
///  api.dart
///
///  Created by kayoxu on 2021/8/6 at 10:07 上午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class API extends BaseAPI {
  bool appInactive = false;

  static API get share => API._share();

  static API? _instance;

  String? _host;
  String? _hostWeb;

  String? _hostFile;

  String? _hostSocket;

  API._();

  factory API._share() {
    _instance ??= API._();
    return _instance!;
  }

  @override
  bool get isEnv => true;

  @override
  init() async {
    _host = null;
    _hostWeb = null;
    _hostFile = null;
    _hostSocket = null;

    await SharedUtils.setHost(isEnv == false
        ? 'http://183.224.113.211:8003/'
        // ? 'http://192.168.101.184:8001/'
        // : 'http://221.237.108.38:8043/'
        // : 'http://192.168.101.131:8080/'
        : 'http://106.75.154.221:8082/');

    await SharedUtils.setHostWeb(isEnv == false
        ? 'http://183.224.113.211:9001/'
        // ? 'http://192.168.101.184:8004/'
        // : 'http://221.237.108.38:8045/'
        : 'http://192.168.101.184:8004/');

    await SharedUtils.setHostFile(isEnv == false
        ? 'http://183.224.113.211:8098/minio/'
        : 'http://183.224.113.211:8098/minio/');

    await SharedUtils.setHostSocket(isEnv == false
        ? 'ws://183.224.113.211:9001/api/ws'
        : 'ws://183.224.113.211:9001/api/ws');

    _host = await SharedUtils.getHost();
    _hostWeb = await SharedUtils.getHostWeb();
    _hostFile = await SharedUtils.getHostFile();
    _hostSocket = await SharedUtils.getHostSocket();
  }

  String getApkUrl(String url) {
    if (isLocalServer()) {
      if (url.contains('183.224.113.211')) {
        url = url.replaceAll('183.224.113.211', '10.10.1.93');
      }
    }
    if (PlatformUtils.isIOS) {
      url =
          'https://apps.apple.com/us/app/%E6%98%AD%E9%80%9A%E5%BA%94%E6%80%A5/id6443747416';
    }
    return url;
  }

  // String get hostWeb => 'http://192.168.103.88:8001/';

  Future<String> get hostVideoConfiguration async {
    var cip = await SharedUtils.getControlIP();

    if (BaseSysUtils.empty(cip)) {
      return '';
    } else {
      return 'http://$cip:8000';
    }
  }

  Future<String> get hostCameraConfiguration async {
    return 'http://10.10.1.93:8001';
  }

  @override
  String get host => _host ?? '';

  String get hostWeb => _hostWeb ?? '';

  @override
  String get hostFile => _hostFile ?? '';

  @override
  String get hostSocket => _hostSocket ?? '';

  bool isLocalServer() {
    return host.startsWith('http://10.') ||
        host.startsWith('http://172.16') ||
        host.startsWith('http://172.17') ||
        host.startsWith('http://172.18') ||
        host.startsWith('http://172.19') ||
        host.startsWith('http://172.20') ||
        host.startsWith('http://172.21') ||
        host.startsWith('http://172.22') ||
        host.startsWith('http://172.23') ||
        host.startsWith('http://172.24') ||
        host.startsWith('http://172.25') ||
        host.startsWith('http://172.26') ||
        host.startsWith('http://172.27') ||
        host.startsWith('http://172.28') ||
        host.startsWith('http://172.29') ||
        host.startsWith('http://172.30') ||
        host.startsWith('http://172.31') ||
        host.startsWith('http://192.168.');
  }
}
