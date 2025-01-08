import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/location_data_entity.dart';
import 'package:omt/main.dart';
import 'package:omt/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///  tfblue_flutter_module
///  common.utils
///
///  Created by kayoxu on 2019-06-10 17:31.
///  Copyright © 2019 kayoxu. All rights reserved.

getData(dynamic data, {String value = '无'}) {
  if (BaseSysUtils.empty(data)) {
    return value;
  }
  return '${data ?? value}';
}

class SysUtils {
  static bool autoDownAPK = false;

  static bool isDebug() {
    return BaseSysUtils.isDebug;
  }

  static bool isIPAddress(String str) {
    final ipRegExp = RegExp(
        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return ipRegExp.hasMatch(str);
  }

  // static bool get isInDebugMode {
  //   bool inDebugMode = false;
  //   assert(inDebugMode = true); //如果debug模式下会触发赋值
  //   return inDebugMode;
  // }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      CoolKeyboard.sendPerformAction(TextInputAction.done);
    } catch (e) {
      print(e);
    }
  }

  static cnNo(int? no) {
    if (null == no) return '0';

    switch (no) {
      case 0:
        return '0';
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 7:
        return '七';
      case 8:
        return '八';
      case 9:
        return '九';
      default:
        return no.toString();
    }
  }

  static getFixedData(num? data, {int fixed = 2}) {
    data = data ?? 0;
    var s = '万';
    if (data > 100000) {
      data = data / 10000;
      return '${fixedStringNum(data.toStringAsFixed(fixed))}$s';
    } else {
      String string = fixedStringNum(data.toStringAsFixed(fixed));
      return string;
    }
  }

  static String fixedStringNum(String data) {
    var string = data.toString();
    if (string.endsWith('.0')) {
      string = string.replaceAll('.0', '');
    } else if (string.endsWith('.00')) {
      string = string.replaceAll('.00', '');
    } else if (string.endsWith('.000')) {
      string = string.replaceAll('.000', '');
    } else if (string.endsWith('.0000')) {
      string = string.replaceAll('.0000', '');
    }
    if (string.contains('.')) {
      for (var i = 0; i < 4; i++) {
        if (string.endsWith('0')) {
          string = string.substring(0, string.length - 1);
        }
      }
    }

    return string;
  }

  static getDistance(LocationData? data, LocationData? data2) {
    double radLat1 = rad(data?.lat ?? 0);
    double radLat2 = rad(data2?.lat ?? 0);
    double a = radLat1 - radLat2;
    double b = rad(data?.lng ?? 0) - rad(data2?.lng ?? 0);
    double s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    var d = s * 6378138.0;
    return d;
  }

  static double rad(double d) {
    return d * pi / 180.0;
  }

  static num getMaxY(num temp) {
    if (temp < 5) {
      temp = 5;
    } else if (temp < 10) {
      temp = 10;
    } else if (temp < 50) {
      temp = 50;
    } else if (temp < 100) {
      temp = 100;
    } else if (temp < 150) {
      temp = 150;
    } else if (temp < 200) {
      temp = 200;
    } else if (temp < 250) {
      temp = 250;
    } else if (temp < 300) {
      temp = 300;
    } else if (temp < 350) {
      temp = 350;
    } else if (temp < 400) {
      temp = 400;
    } else if (temp < 450) {
      temp = 450;
    } else if (temp < 500) {
      temp = 500;
    } else if (temp < 600) {
      temp = 600;
    } else if (temp < 700) {
      temp = 700;
    } else if (temp < 800) {
      temp = 800;
    } else if (temp < 900) {
      temp = 900;
    } else if (temp < 1000) {
      temp = 1000;
    } else if (temp < 1500) {
      temp = 1500;
    } else if (temp < 2000) {
      temp = 2000;
    } else if (temp < 2500) {
      temp = 2500;
    } else if (temp < 3000) {
      temp = 3000;
    } else if (temp < 3500) {
      temp = 3500;
    } else if (temp < 4000) {
      temp = 4000;
    } else if (temp < 4500) {
      temp = 4500;
    } else if (temp < 5000) {
      temp = 5000;
    } else if (temp < 6000) {
      temp = 6000;
    } else if (temp < 7000) {
      temp = 7000;
    } else if (temp < 8000) {
      temp = 8000;
    } else if (temp < 9000) {
      temp = 9000;
    } else if (temp < 10000) {
      temp = 10000;
    } else if (temp < 15000) {
      temp = 15000;
    } else if (temp < 20000) {
      temp = 2000;
    } else if (temp < 25000) {
      temp = 25000;
    } else if (temp < 30000) {
      temp = 30000;
    } else if (temp < 35000) {
      temp = 35000;
    } else if (temp < 40000) {
      temp = 40000;
    } else if (temp < 45000) {
      temp = 45000;
    } else if (temp < 50000) {
      temp = 50000;
    } else if (temp < 60000) {
      temp = 60000;
    } else if (temp < 70000) {
      temp = 70000;
    } else if (temp < 80000) {
      temp = 80000;
    } else if (temp < 90000) {
      temp = 90000;
    } else if (temp < 100000) {
      temp = 100000;
    } else if (temp < 150000) {
      temp = 150000;
    } else if (temp < 200000) {
      temp = 200000;
    } else if (temp < 250000) {
      temp = 250000;
    } else if (temp < 300000) {
      temp = 300000;
    } else if (temp < 350000) {
      temp = 350000;
    } else if (temp < 400000) {
      temp = 400000;
    } else if (temp < 450000) {
      temp = 450000;
    } else if (temp < 500000) {
      temp = 500000;
    } else if (temp < 600000) {
      temp = 600000;
    } else if (temp < 700000) {
      temp = 700000;
    } else if (temp < 800000) {
      temp = 800000;
    } else if (temp < 900000) {
      temp = 900000;
    } else if (temp < 1000000) {
      temp = 1000000;
    } else if (temp < 1500000) {
      temp = 1500000;
    } else if (temp < 2000000) {
      temp = 2000000;
    } else if (temp < 2500000) {
      temp = 2500000;
    } else if (temp < 3000000) {
      temp = 3000000;
    } else if (temp < 3500000) {
      temp = 3500000;
    } else if (temp < 4000000) {
      temp = 4000000;
    } else if (temp < 4500000) {
      temp = 4500000;
    } else if (temp < 5000000) {
      temp = 5000000;
    } else if (temp < 6000000) {
      temp = 6000000;
    } else if (temp < 7000000) {
      temp = 7000000;
    } else if (temp < 8000000) {
      temp = 8000000;
    } else if (temp < 9000000) {
      temp = 9000000;
    } else if (temp < 10000000) {
      temp = 10000000;
    } else if (temp < 15000000) {
      temp = 15000000;
    } else if (temp < 20000000) {
      temp = 20000000;
    } else if (temp < 25000000) {
      temp = 25000000;
    } else if (temp < 30000000) {
      temp = 30000000;
    } else if (temp < 35000000) {
      temp = 35000000;
    } else if (temp < 40000000) {
      temp = 40000000;
    } else if (temp < 45000000) {
      temp = 45000000;
    } else if (temp < 50000000) {
      temp = 50000000;
    } else if (temp < 60000000) {
      temp = 60000000;
    } else if (temp < 70000000) {
      temp = 70000000;
    } else if (temp < 80000000) {
      temp = 80000000;
    } else if (temp < 90000000) {
      temp = 90000000;
    }
    return temp;
  }

  static String fixNum(int? data) {
    String dat = '0';
    if (data == null) {
      dat = '0';
    } else if (data > 100000000) {
      var d = data / 100000000;
      var stringAsFixed = d.toStringAsFixed(2);
      dat = '$stringAsFixed亿'.replaceAll('.00亿', '亿');
      if (dat.contains('.')) {
        dat = dat.replaceAll('0亿', '亿');
      }
    } else if (data > 10000000) {
      var d = data / 100000000;
      var stringAsFixed = d.toStringAsFixed(3);
      dat = '$stringAsFixed亿'.replaceAll('.00亿', '亿').replaceAll('.000亿', '亿');
      if (dat.contains('.')) {
        dat = dat.replaceAll('00亿', '亿').replaceAll('0亿', '亿');
      }
    } else if (data > 10000) {
      var d = data / 10000;
      var stringAsFixed = d.toStringAsFixed(2);
      dat = '$stringAsFixed万'.replaceAll('.00万', '万');
      if (dat.contains('.')) {
        dat = dat.replaceAll('0万', '万');
      }
    }
    return dat;
  }

  // static String getFullName(List<AreaDataAreas>? selectAreaList,
  //     {String defaultData = ""}) {
  //   var list = selectAreaList?.map((e) => e.fullname).toList();
  //   list?.removeWhere((element) => BaseSysUtils.empty(element));
  //   if (BaseSysUtils.empty(list)) {
  //     return defaultData;
  //   }
  //   if (list!.length == 1) {
  //     return list[0] ?? defaultData;
  //   } else {
  //     return list.toStringWith(splitUnit: '-');
  //   }
  // }

  /// 打开链接
  static Future<void> launchWebURL(String url, {String msg = '打开失败'}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      LoadingUtils.showToast(data: '打开失败');
    }
  }

  static useMvvm() {
    return true;
  }

  ///2.0不上ocr部分
  static use2_0TestOld() {
    return false;
  }

  static num getMax(List<num> list) {
    return BaseSysUtils.empty(list) ? 0 : list.fold(list[0], max);
  }

  static num getMin(List<num> list) {
    return BaseSysUtils.empty(list) ? 0 : list.fold(list[0], min);
  }

  static String? getFileName(String? path) {
    return path;
  }

  static Widget appBarAction(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final theme = fu.FluentTheme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: fu.ToggleSwitch(
            // style: fu.ToggleSwitchThemeData.standard(theme.copyWith(activeColor: ColorUtils.colorAccent)),
            content: const Text('深色模式'),
            checked: fu.FluentTheme.of(context).brightness.isDark,
            onChanged: (v) {
              if (v) {
                appTheme.mode = ThemeMode.dark;
              } else {
                appTheme.mode = ThemeMode.light;
              }
            },
          ),
        ),
      ),
      if (!kIsWeb) const WindowButtons(),
    ]);
  }

  static List<Widget> appBarActions(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final theme = fu.FluentTheme.of(context);
    return [
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: fu.ToggleSwitch(
            content: const Text('深色模式'),
            checked: fu.FluentTheme.of(context).brightness.isDark,
            onChanged: (v) {
              if (v) {
                appTheme.mode = ThemeMode.dark;
              } else {
                appTheme.mode = ThemeMode.light;
              }
            },
          ),
        ),
      ),
      if (!kIsWeb) const WindowButtons(),
    ];
  }

  static List<Color> generateColors49() {
    List<String> colorList = [
      "#ffcc99",
      "#ff6666",
      "#fe9a65",
      "#ffff00",
      "#ccff00",
      "#73c0de",
      "#c2c2f0",
      "#ff3333",
      "#c2f0c2",
      "#ff8000",
      "#ffc0cb",
      "#ffb3b3",
      "#00ff66",
      "#91cc75",
      "#00ccff",
      "#ff69b4",
      "#f7a35c",
      "#6495ed",
      "#ff99cc",
      "#ff6666",
      "#ffc125",
      "#c0ff3e",
      "#87cefa",
      "#ba55d3",
      "#8b9fc9",
      "#ffb3e6",
      "#fac858",
      "#ff8c29",
      "#00ff00",
      "#ffb3b3",
      "#00ff33",
      "#ff9900",
      "#3ba272",
      "#f15c80",
      "#997950",
      "#00ffff",
      "#ea7ccc",
      "#ff69b4",
      "#ffff99",
      "#ff6600",
      "#ff9c00",
      "#9a60b4",
      "#66ff00",
      "#5470c6",
      "#00ff99",
      "#ff9999",
      "#66ccff",
      "#ffcc00",
      "#ffeead"
    ];

    List<Color> colors = [];
    for (var c in colorList) {
      colors.add(c.toColor());
    }

    return colors;
  }

  static bool useNavi() {
    return false;
  }

  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static String testLivePlay() {
    // return 'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4';
    // return 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8';
    // return 'rtsp://192.168.101.189:8554/mystream';
    // return 'http://192.168.101.189:8888/mystream';
    // return 'http://localhost:8888/mystream';
    // return 'rtsp://192.168.101.189:8554/mystream';
    return 'rtsp://admin:flm2020hb@192.168.101.236:554/Streaming/Channels/101';
    // return 'http://192.168.101.189:3000/a.mkv';
  }

}
