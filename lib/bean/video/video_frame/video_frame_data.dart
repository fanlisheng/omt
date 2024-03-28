import 'dart:convert';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/video_frame_data.g.dart';

///
///  omt
///  video_frame_data.dart
///  视频画框
///
///  Created by kayoxu on 2024-03-08 at 11:47:54
///  Copyright © 2024 .. All rights reserved.
///

@JsonSerializable()
class VideoFrameData {
  VideoFrameData();

  factory VideoFrameData.fromJson(Map<String, dynamic> json) =>
      $VideoFrameDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoFrameDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
