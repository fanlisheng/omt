import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/home_page_data.dart';
import 'dart:core';

import 'package:omt/generated/json/base/json_convert_content.dart';


HomePageData $HomePageDataFromJson(Map<String, dynamic> json) {
  final HomePageData homePageData = HomePageData();
  return homePageData;
}

Map<String, dynamic> $HomePageDataToJson(HomePageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension HomePageDataExtension on HomePageData {
}