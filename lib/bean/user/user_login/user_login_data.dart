import 'dart:convert';
import 'dart:core';

import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/user_login_data.g.dart';

///
///  omt
///  user_login_data.dart
///  登录
///
///  Created by kayoxu on 2024-03-05 at 15:04:21
///  Copyright © 2024 .. All rights reserved.
///
@JsonSerializable()
class UserInfoData {
  String? phone;
  List<UserPermission>? userPermissions;

  UserInfoData();

  factory UserInfoData.fromJson(Map<String, dynamic> json) =>
      $UserInfoDataFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class UserPermission {
  int? id;
  String? terminal = '';
  String? name = '';

  UserPermission();

  factory UserPermission.fromJson(Map<String, dynamic> json) =>
      $UserPermissionFromJson(json);

  Map<String, dynamic> toJson() => $UserPermissionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
