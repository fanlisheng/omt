import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/one_picture_data.g.dart';

///
///  omt
///  one_picture_data.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

@JsonSerializable()
class OnePictureData  {



  OnePictureData();

  factory OnePictureData.fromJson(Map<String, dynamic> json) => $OnePictureDataFromJson(json);

  Map<String, dynamic> toJson() => $OnePictureDataToJson(this);
}

