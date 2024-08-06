import 'dart:convert';
import 'dart:core';

import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/video_configuration_data.g.dart';

///
///  omt
///  video_configuration_data.dart
///  视频配置
///
///  Created by kayoxu on 2024-03-08 at 11:44:33
///  Copyright © 2024 .. All rights reserved.
///
@JsonSerializable()
class VideoConfigurationData {
  VideoConfigurationData();

  factory VideoConfigurationData.fromJson(Map<String, dynamic> json) =>
      $VideoConfigurationDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoConfigurationDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
