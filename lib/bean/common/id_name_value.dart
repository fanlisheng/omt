import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/id_name_value.g.dart';

///
///  tfblue_flutter_module
///  id_name_value.dart
///
///  Created by kayoxu on 2020/6/26 at 8:52 PM
///  Copyright © 2020 kayoxu. All rights reserved.
///
@JsonSerializable()
class IdNameValueEntity {
  int? code;
  String? message;
  List<IdNameValue>? data;

  IdNameValueEntity();

  factory IdNameValueEntity.fromJson(Map<String, dynamic> json) =>
      $IdNameValueEntityFromJson(json);

  Map<String, dynamic> toJson() => $IdNameValueEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class IdNameValue {
  int? id;
  String? name;
  String? showName;
  String? value;
  bool? isSelected;
  bool? isMultiple;
  IdNameValue? selectSub;
  String? color;
  String? url;
  List<int>? ids;
  int? flex;
  List<IdNameValue>? children;
  int? count;

  IdNameValue({
    this.id,
    this.flex,
    this.ids,
    this.name,
    this.showName,
    this.value,
    this.children,
    this.selectSub,
    this.isSelected,
    this.color,
    this.isMultiple,
  });

  String get nameShow => name ?? '$id';

  IdNameValue.all() {
    this.id = -1;
    this.name = '全部';
  }

  IdNameValue.cd() {
    this.id = 5101;
    this.name = '成都市';
  }

  String get itemId {
    return '$id$name$value';
  }

  factory IdNameValue.fromJson(Map<String, dynamic> json) =>
      $IdNameValueFromJson(json);

  Map<String, dynamic> toJson() => $IdNameValueToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
