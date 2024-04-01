import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/utils/shared_utils.dart';

///
///  flutter_ticket
///  auth_utils.dart
///
///  Created by kayoxu on 2024/4/1 at 15:52 AM
///  Copyright © 2024 kayoxu. All rights reserved.
///

class AuthEnum {
  ///视频配置
  static const int menuVideoConfiguration = 101;

  ///
  static const int menuEmergencyList = 102;
}

class AuthUtils {
  final HashMap<int, UserPermission> _authList = HashMap();
  List<UserPermission> userPermissions = [];

  static AuthUtils get share => AuthUtils._share();

  static AuthUtils? _instance;

  AuthUtils._();

  factory AuthUtils._share() {
    _instance ??= AuthUtils._();
    return _instance!;
  }

  ///初始化
  init() async {
    _authList.clear();
    userPermissions = await SharedUtils.getUserPermissions();

    for (UserPermission p in userPermissions) {
      if (null != p.id) {
        _authList[p.id!] = p;
      }
    }
  }

  ///判断是否有权限
  bool hasAuth({required int? authId}) {
    return _authList.containsKey(authId ?? -1);
  }

  ///通过ID获取权限数据
  UserPermission? permission({required int? authId}) {
    return _authList.getOrNull(authId);
  }

  bool authTest() {
    return true;
  }

}
