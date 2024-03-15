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