import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/video/video_operations_center/video_operations_center_data.dart';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';

VideoOperationsCenterData $VideoOperationsCenterDataFromJson(
    Map<String, dynamic> json) {
  final VideoOperationsCenterData videoOperationsCenterData =
      VideoOperationsCenterData();
  return videoOperationsCenterData;
}

Map<String, dynamic> $VideoOperationsCenterDataToJson(
    VideoOperationsCenterData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension VideoOperationsCenterDataExtension on VideoOperationsCenterData {}
