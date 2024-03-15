import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:flutter/cupertino.dart';

import 'package:kayo_package/kayo_package.dart';


IdNameValueEntity $IdNameValueEntityFromJson(Map<String, dynamic> json) {
  final IdNameValueEntity idNameValueEntity = IdNameValueEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    idNameValueEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    idNameValueEntity.message = message;
  }
  final List<IdNameValue>? data = (json['data'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<IdNameValue>(e) as IdNameValue).toList();
  if (data != null) {
    idNameValueEntity.data = data;
  }
  return idNameValueEntity;
}

Map<String, dynamic> $IdNameValueEntityToJson(IdNameValueEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  return data;
}

extension IdNameValueEntityExtension on IdNameValueEntity {
  IdNameValueEntity copyWith({
    int? code,
    String? message,
    List<IdNameValue>? data,
  }) {
    return IdNameValueEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

IdNameValue $IdNameValueFromJson(Map<String, dynamic> json) {
  final IdNameValue idNameValue = IdNameValue();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    idNameValue.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    idNameValue.name = name;
  }
  final String? showName = jsonConvert.convert<String>(json['showName']);
  if (showName != null) {
    idNameValue.showName = showName;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    idNameValue.value = value;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    idNameValue.isSelected = isSelected;
  }
  final bool? isMultiple = jsonConvert.convert<bool>(json['isMultiple']);
  if (isMultiple != null) {
    idNameValue.isMultiple = isMultiple;
  }
  final IdNameValue? selectSub = jsonConvert.convert<IdNameValue>(
      json['selectSub']);
  if (selectSub != null) {
    idNameValue.selectSub = selectSub;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    idNameValue.color = color;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    idNameValue.url = url;
  }
  final List<int>? ids = (json['ids'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<int>(e) as int).toList();
  if (ids != null) {
    idNameValue.ids = ids;
  }
  final int? flex = jsonConvert.convert<int>(json['flex']);
  if (flex != null) {
    idNameValue.flex = flex;
  }
  final List<IdNameValue>? children = (json['children'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<IdNameValue>(e) as IdNameValue).toList();
  if (children != null) {
    idNameValue.children = children;
  }
  final int? count = jsonConvert.convert<int>(json['count']);
  if (count != null) {
    idNameValue.count = count;
  }
  return idNameValue;
}

Map<String, dynamic> $IdNameValueToJson(IdNameValue entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['showName'] = entity.showName;
  data['value'] = entity.value;
  data['isSelected'] = entity.isSelected;
  data['isMultiple'] = entity.isMultiple;
  data['selectSub'] = entity.selectSub?.toJson();
  data['color'] = entity.color;
  data['url'] = entity.url;
  data['ids'] = entity.ids;
  data['flex'] = entity.flex;
  data['children'] = entity.children?.map((v) => v.toJson()).toList();
  data['count'] = entity.count;
  return data;
}

extension IdNameValueExtension on IdNameValue {
  IdNameValue copyWith({
    int? id,
    String? name,
    String? showName,
    String? value,
    bool? isSelected,
    bool? isMultiple,
    IdNameValue? selectSub,
    String? color,
    String? url,
    List<int>? ids,
    int? flex,
    List<IdNameValue>? children,
    int? count,
  }) {
    return IdNameValue()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..showName = showName ?? this.showName
      ..value = value ?? this.value
      ..isSelected = isSelected ?? this.isSelected
      ..isMultiple = isMultiple ?? this.isMultiple
      ..selectSub = selectSub ?? this.selectSub
      ..color = color ?? this.color
      ..url = url ?? this.url
      ..ids = ids ?? this.ids
      ..flex = flex ?? this.flex
      ..children = children ?? this.children
      ..count = count ?? this.count;
  }
}