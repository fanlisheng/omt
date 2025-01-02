import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/video/video_frame/video_frame_data.dart';
import 'dart:core';


VideoFrameData $VideoFrameDataFromJson(Map<String, dynamic> json) {
  final VideoFrameData videoFrameData = VideoFrameData();
  return videoFrameData;
}

Map<String, dynamic> $VideoFrameDataToJson(VideoFrameData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension VideoFrameDataExtension on VideoFrameData {
}