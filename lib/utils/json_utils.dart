import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:omt/generated/json/base/json_convert_content.dart';

class JsonUtils {
  static getMap(var data) {
    if (data is String) {
      return json.decode(data);
    } else if (data is Map<String, dynamic>) {
      return data;
    } else if (data is List) {
      return data;
    } else {
      return {};
    }
  }

  static String toJson(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      // print(e);
      return '{}';
    }
  }

  ///需要完善
  static Future<T?> getBean<T>(dynamic data) async {
    if (null == data) return null;
    dynamic map;
    try {
      map = JsonUtils.getMap(data);
    } catch (e) {
      // print(e);
      map = <String, dynamic>{};
    }
    if (map is Map) {
      map = Map<String, dynamic>.from(map);
    }

    var queryDataType = T.toString();
    if (queryDataType == 'String') {
      return data;
    } else if (queryDataType == 'List<String>') {
      return List<String>.from(data) as T;
    } else if (queryDataType == 'dynamic') {
      return data;
    } else {
      return await Future.value(JsonConvert.fromJsonAsT<T>(map));
    }
  }

  ///需要完善
  static T? getBeanSync<T>(dynamic data) {
    if (null == data) return null;
    dynamic map;
    try {
      map = JsonUtils.getMap(data);
    } catch (e) {
      // print(e);
      map = <String, dynamic>{};
    }
    if (map is Map) {
      map = Map<String, dynamic>.from(map);
    }

    var queryDataType = T.toString();
    if (queryDataType == 'String') {
      return data;
    } else if (queryDataType == 'List<String>') {
      return List<String>.from(data) as T;
    } else if (queryDataType == 'dynamic') {
      return data;
    } else {
      return JsonConvert.fromJsonAsT<T>(map);
//      return await Future.value(JsonConvert.fromJsonAsT<T>(common.map));
    }
  }

  Future<Map<String, dynamic>> loadLocalJson(String name) async {
    String jsonString = await rootBundle.loadString('assets/$name.json');
    return json.decode(jsonString);
  }
}
