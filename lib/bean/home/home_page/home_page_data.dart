import 'dart:convert';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/home_page_data.g.dart';

///
///  omt
///  home_page_data.dart
///  首页
///
///  Created by kayoxu on 2024-03-05 at 15:06:35
///  Copyright © 2024 .. All rights reserved.
///

 
@JsonSerializable()
class HomePageData {
  HomePageData();

  factory HomePageData.fromJson(Map<String, dynamic> json) =>
      $HomePageDataFromJson(json);

  Map<String, dynamic> toJson() => $HomePageDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}