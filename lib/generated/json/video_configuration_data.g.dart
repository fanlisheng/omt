import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/video/video_configuration/video_configuration_data.dart';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';


VideoConfigurationData $VideoConfigurationDataFromJson(
    Map<String, dynamic> json) {
  final VideoConfigurationData videoConfigurationData = VideoConfigurationData();
  return videoConfigurationData;
}

Map<String, dynamic> $VideoConfigurationDataToJson(
    VideoConfigurationData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension VideoConfigurationDataExtension on VideoConfigurationData {
}