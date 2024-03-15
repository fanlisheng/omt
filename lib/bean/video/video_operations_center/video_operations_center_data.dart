import 'dart:convert';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/video_operations_center_data.g.dart';

///
///  omt
///  video_operations_center_data.dart
///  视频操作中心
///
///  Created by kayoxu on 2024-03-08 at 11:53:00
///  Copyright © 2024 .. All rights reserved.
///

@JsonSerializable()
class VideoOperationsCenterData {
  VideoOperationsCenterData();

  factory VideoOperationsCenterData.fromJson(Map<String, dynamic> json) =>
      $VideoOperationsCenterDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoOperationsCenterDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
