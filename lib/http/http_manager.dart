import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:omt/utils/json_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

///
///  tfblue_app
///  http_manager.dart
///
///  Created by kayoxu on 2021/8/6 at 9:11 上午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class HttpManager extends BaseHttpManager {
  HttpManager._();

  static HttpManager get share => HttpManager._share();

  static HttpManager? _instance;

  factory HttpManager._share() {
    if (_instance == null) {
      _instance = HttpManager._();
    }
    return _instance!;
  }

  @override
  Future<Map<String, dynamic>> getBaseHeader() async {
    // var userLoginInfo = await SharedUtils.getUserInfo();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var appVersion = packageInfo.version;
    var osVersion = '';
    var os = '';
    var brand = '';
    var UDID = '';
    var appName = PinyinHelper.getPinyin(packageInfo.appName, separator: '');

    if (PlatformUtils.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      osVersion = androidInfo.version.release ?? '';
      os = 'Android';
      brand =
          '${(await deviceInfoPlugin.androidInfo).brand} ${(await deviceInfoPlugin.androidInfo).model}';
      UDID = androidInfo.id ?? '';
    } else if (PlatformUtils.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      osVersion = iosInfo.systemVersion ?? '';
      os = 'IOS';
      brand = getIphoneModel(iosInfo.utsname.machine ?? '');

      UDID = iosInfo.identifierForVendor ?? '';
    }
    if (BaseSysUtils.empty(UDID)) {
      UDID = await SharedUtils.getUDID();
    }

    Map<String, dynamic> map = {};
    // if (!BaseSysUtils.empty(userLoginInfo?.token)) {
    //   map.addAll({
    //     'Authorization': 'Bearer ${userLoginInfo?.token ?? ''}',
    //   });
    // }
    map.addAll({
      'Type': 'mobile',
      'Platform': 'zt',
      'App': appName,
      'App-Version': appVersion,
      'OS': os,
      'OS-Version': osVersion,
      'Brand': brand,
      'UDID': UDID,
      // 'Access-Control-Allow-Origin': '*',
      // 'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE',
      // 'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept',
      });
    return map;
  }

  @override
  Future<T?> getBean<T>(data) {
    return JsonUtils.getBean<T>(data);
  }

  @override
  Map<String, dynamic>? getMap(dynamic string) {
    return JsonUtils.getMap(string);
  }

  @override
  String toJson(data) {
    return JsonUtils.toJson(data);
  }

  @override
  Future<String?> getSharedString(String sharedUrl) async {
    return SharedUtils.getString(sharedUrl);
  }

  @override
  releaseShowLog() {
    return true;
  }

  @override
  logInfo({String? tag, String? msg}) {
    // tag = 'Flutter🌶  ${tag ?? ''}  ';
    // print('$tag $msg');
    LogUtils.info(msg: msg, tag: tag);
  }

  @override
  Future<void> setSharedData(String sharedUrl, json) async {
    return SharedUtils.set(sharedUrl, json);
  }

  @override
  String textLoading() {
    return '加载中, 请稍等...';
  }

  @override
  String textLoginExpired() {
    return '登录已失效，请重新登录';
  }

  @override
  String textNetworkError() {
    return '网络开小差了';
  }

  @override
  String textRequestError() {
    return '请求失败';
  }

  getIphoneModel(String platform) {
    switch (platform) {
      //MARK: iPod
      case "iPod1,1":
        return "iPod Touch 1";
      case "iPod2,1":
        return "iPod Touch 2";
      case "iPod3,1":
        return "iPod Touch 3";
      case "iPod4,1":
        return "iPod Touch 4";
      case "iPod5,1":
        return "iPod Touch (5 Gen)";
      case "iPod7,1":
        return "iPod Touch 6";
      //MARK: iPhone
      case "iPhone5,1":
        return "iPhone 5";
      case "iPhone5,2":
        return "iPhone 5 (GSM+CDMA)";
      case "iPhone5,3":
        return "iPhone 5c (GSM)";
      case "iPhone5,4":
        return "iPhone 5c (GSM+CDMA)";
      case "iPhone6,1":
        return "iPhone 5s (GSM)";
      case "iPhone6,2":
        return "iPhone 5s (GSM+CDMA)";
      case "iPhone7,2":
        return "iPhone 6";
      case "iPhone7,1":
        return "iPhone 6 Plus";
      case "iPhone8,1":
        return "iPhone 6s";
      case "iPhone8,2":
        return "iPhone 6s Plus";
      case "iPhone8,4":
        return "iPhone SE";
      case "iPhone9,1":
        return "iPhone 7";
      case "iPhone9,2":
        return "iPhone 7 Plus";
      case "iPhone9,3":
        return "iPhone 7";
      case "iPhone9,4":
        return "iPhone 7 Plus";
      case "iPhone10,1":
      case "iPhone10,4":
        return "iPhone 8";
      case "iPhone10,2":
      case "iPhone10,5":
        return "iPhone 8 Plus";
      case "iPhone10,3":
      case "iPhone10,6":
        return "iPhone X";
      case "iPhone11,8":
        return "iPhone XR";
      case "iPhone11,2":
        return "iPhone XS";
      case "iPhone11,6":
        return "iPhone XS Max";
      case "iPhone11,4":
        return "iPhone XS Max (China)";
      case "iPhone12,1":
        return "iPhone 11";
      case "iPhone12,3":
        return "iPhone 11 Pro";
      case "iPhone12,5":
        return "iPhone 11 Pro Max";
      case "iPhone13,1":
        return "iPhone 12 mini";
      case "iPhone13,2":
        return "iPhone 12";
      case "iPhone13,3":
        return "iPhone 12 Pro";
      case "iPhone13,4":
        return "iPhone 12 Pro Max";
      case "iPhone14,4":
        return "iPhone 13 mini";
      case "iPhone14,5":
        return "iPhone 13";
      case "iPhone14,2":
        return "iPhone 13 Pro";
      case "iPhone14,3":
        return "iPhone 13 Pro Max";
      //MARK: iPad
      case "iPad1,1":
        return "iPad";
      case "iPad1,2":
        return "iPad 3G";
      case "iPad2,1":
      case "iPad2,2":
      case "iPad2,3":
      case "iPad2,4":
        return "iPad 2";
      case "iPad2,5":
      case "iPad2,6":
      case "iPad2,7":
        return "iPad Mini";
      case "iPad3,1":
      case "iPad3,2":
      case "iPad3,3":
        return "iPad 3";
      case "iPad3,4":
      case "iPad3,5":
      case "iPad3,6":
        return "iPad 4";
      case "iPad4,1":
      case "iPad4,2":
      case "iPad4,3":
        return "iPad Air";
      case "iPad4,4":
      case "iPad4,5":
      case "iPad4,6":
        return "iPad Mini 2";
      case "iPad4,7":
      case "iPad4,8":
      case "iPad4,9":
        return "iPad Mini 3";
      case "iPad5,1":
      case "iPad5,2":
        return "iPad Mini 4";
      case "iPad5,3":
      case "iPad5,4":
        return "iPad Air 2";
      case "iPad6,3":
      case "iPad6,4":
        return "iPad Pro 9.7";
      case "iPad6,7":
      case "iPad6,8":
        return "iPad Pro 12.9";
      //MARK: AppleTV
      case "AppleTV2,1":
        return "Apple TV 2";
      case "AppleTV3,1":
      case "AppleTV3,2":
        return "Apple TV 3";
      case "AppleTV5,3":
        return "Apple TV 4";
      case "i386":
      case "x86_64":
        return "Simulator";
      default:
        return platform;
    }
  }

  getGETUrl(String url, Map<String, dynamic> map) {
    var m = Map<String, dynamic>.from(map);
    var keys = m.keys;
    int i = 0;
    for (String k in keys) {
      var m2 = m[k];
      if (m2 is List) {
        var d = '';
        var index = 0;
        for (var mm in m2) {
          if (index == 0) {
            d = '$k[]=$mm';
          } else {
            d = '$d&$k[]=$mm';
          }
          index++;
        }

        if (i == 0) {
          url = '$url?$d';
        } else {
          url = '$url&$d';
        }
      } else {
        if (i == 0) {
          url = '$url?$k=${m[k]}';
        } else {
          url = '$url&$k=${m[k]}';
        }
      }
      i++;
    }
    return url;
  }
}
