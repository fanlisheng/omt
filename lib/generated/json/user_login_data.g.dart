import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';


UserLoginData $UserLoginDataFromJson(Map<String, dynamic> json) {
  final UserLoginData userLoginData = UserLoginData();
  return userLoginData;
}

Map<String, dynamic> $UserLoginDataToJson(UserLoginData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension UserLoginDataExtension on UserLoginData {
}

UserPermission $UserPermissionFromJson(Map<String, dynamic> json) {
  final UserPermission userPermission = UserPermission();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userPermission.id = id;
  }
  final String? terminal = jsonConvert.convert<String>(json['terminal']);
  if (terminal != null) {
    userPermission.terminal = terminal;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userPermission.name = name;
  }
  return userPermission;
}

Map<String, dynamic> $UserPermissionToJson(UserPermission entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['terminal'] = entity.terminal;
  data['name'] = entity.name;
  return data;
}

extension UserPermissionExtension on UserPermission {
  UserPermission copyWith({
    int? id,
    String? terminal,
    String? name,
  }) {
    return UserPermission()
      ..id = id ?? this.id
      ..terminal = terminal ?? this.terminal
      ..name = name ?? this.name;
  }
}