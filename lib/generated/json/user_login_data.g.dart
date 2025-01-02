import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'dart:core';


UserInfoData $UserInfoDataFromJson(Map<String, dynamic> json) {
  final UserInfoData userInfoData = UserInfoData();
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoData.phone = phone;
  }
  final List<
      UserPermission>? userPermissions = (json['userPermissions'] as List<
      dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<UserPermission>(e) as UserPermission)
      .toList();
  if (userPermissions != null) {
    userInfoData.userPermissions = userPermissions;
  }
  return userInfoData;
}

Map<String, dynamic> $UserInfoDataToJson(UserInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['phone'] = entity.phone;
  data['userPermissions'] =
      entity.userPermissions?.map((v) => v.toJson()).toList();
  return data;
}

extension UserInfoDataExtension on UserInfoData {
  UserInfoData copyWith({
    String? phone,
    List<UserPermission>? userPermissions,
  }) {
    return UserInfoData()
      ..phone = phone ?? this.phone
      ..userPermissions = userPermissions ?? this.userPermissions;
  }
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