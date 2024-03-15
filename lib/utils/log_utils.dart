import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayo_package/kayo_package.dart';

///  tfblue_flutter_module
///
///
///  Created by kayoxu on 2019-08-02 13:56.
///  Copyright © 2019 kayoxu. All rights reserved.

enum LogLevel {
  i,
  d,
  v,
  w,
  e,
}

class LogUtils {
  LogUtils._();

  static void info(
      {dynamic msg,
      String? tag,
      LogLevel logLevel = LogLevel.e,
      bool userNative = true}) {
    tag = 'Flutter🌶  ${tag ?? ''}  ';

    msg = msg ?? '';

    if (kDebugMode) {
      print('$tag $msg');
    }
  }
}
