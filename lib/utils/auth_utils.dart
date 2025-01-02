import 'dart:collection';

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

  ///摄像头配置
  static const int menuCameraConfiguration = 102;

  ///小工具
  static const int menuTools = 103;

  ///一张图
  static const int menuOnePicture = 104;

  ///数据标注
  static const int menuLabelMe = 9999;
}

class AuthUtils {
  final HashMap<int, UserPermission> _authList = HashMap();
  UserInfoData? userLoginData;

  static AuthUtils get share => AuthUtils._share();

  static AuthUtils? _instance;

  AuthUtils._();

  factory AuthUtils._share() {
    _instance ??= AuthUtils._();
    return _instance!;
  }

  ///初始化
  init({UserInfoData? userLoginData}) async {
    _authList.clear();
    userLoginData = userLoginData ?? await SharedUtils.getUserInfo();

    for (UserPermission p in userLoginData?.userPermissions ?? []) {
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
