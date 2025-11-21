import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:flutter/material.dart';

import 'package:kayo_package/extension/_index_extension.dart';

import 'package:kayo_package/kayo_package.dart';

import 'package:media_kit/media_kit.dart';

import 'package:omt/utils/color_utils.dart';

import 'package:omt/utils/shared_utils.dart';


OnePictureDataEntity $OnePictureDataEntityFromJson(Map<String, dynamic> json) {
  final OnePictureDataEntity onePictureDataEntity = OnePictureDataEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    onePictureDataEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    onePictureDataEntity.message = message;
  }
  final OnePictureDataData? data = jsonConvert.convert<OnePictureDataData>(
      json['data']);
  if (data != null) {
    onePictureDataEntity.data = data;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    onePictureDataEntity.status = status;
  }
  final dynamic details = json['details'];
  if (details != null) {
    onePictureDataEntity.details = details;
  }
  final String? requestId = jsonConvert.convert<String>(json['request_id']);
  if (requestId != null) {
    onePictureDataEntity.requestId = requestId;
  }
  return onePictureDataEntity;
}

Map<String, dynamic> $OnePictureDataEntityToJson(OnePictureDataEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  data['status'] = entity.status;
  data['details'] = entity.details;
  data['request_id'] = entity.requestId;
  return data;
}

extension OnePictureDataEntityExtension on OnePictureDataEntity {
  OnePictureDataEntity copyWith({
    int? code,
    String? message,
    OnePictureDataData? data,
    String? status,
    dynamic details,
    String? requestId,
  }) {
    return OnePictureDataEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data
      ..status = status ?? this.status
      ..details = details ?? this.details
      ..requestId = requestId ?? this.requestId;
  }
}

OnePictureDataData $OnePictureDataDataFromJson(Map<String, dynamic> json) {
  final OnePictureDataData onePictureDataData = OnePictureDataData();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    onePictureDataData.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    onePictureDataData.name = name;
  }
  final String? nodeCode = jsonConvert.convert<String>(json['node_code']);
  if (nodeCode != null) {
    onePictureDataData.nodeCode = nodeCode;
  }
  final List<String>? fault = (json['fault'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (fault != null) {
    onePictureDataData.fault = fault;
  }
  final String? idParent = jsonConvert.convert<String>(json['idParent']);
  if (idParent != null) {
    onePictureDataData.idParent = idParent;
  }
  final String? nodeCodeParent = jsonConvert.convert<String>(
      json['nodeCodeParent']);
  if (nodeCodeParent != null) {
    onePictureDataData.nodeCodeParent = nodeCodeParent;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    onePictureDataData.type = type;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    onePictureDataData.typeText = typeText;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    onePictureDataData.desc = desc;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    onePictureDataData.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    onePictureDataData.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    onePictureDataData.mac = mac;
  }
  final bool? sameTypeData = jsonConvert.convert<bool>(json['sameTypeData']);
  if (sameTypeData != null) {
    onePictureDataData.sameTypeData = sameTypeData;
  }
  final bool? ignore = jsonConvert.convert<bool>(json['ignore']);
  if (ignore != null) {
    onePictureDataData.ignore = ignore;
  }
  final bool? show = jsonConvert.convert<bool>(json['show']);
  if (show != null) {
    onePictureDataData.show = show;
  }
  final bool? unknown = jsonConvert.convert<bool>(json['unknown']);
  if (unknown != null) {
    onePictureDataData.unknown = unknown;
  }
  final OnePictureDataData? parent = jsonConvert.convert<OnePictureDataData>(
      json['parent']);
  if (parent != null) {
    onePictureDataData.parent = parent;
  }
  final bool? showAddBtn2 = jsonConvert.convert<bool>(json['showAddBtn2']);
  if (showAddBtn2 != null) {
    onePictureDataData.showAddBtn2 = showAddBtn2;
  }
  final List<OnePictureDataData>? nextList = (json['nextList'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<OnePictureDataData>(e) as OnePictureDataData)
      .toList();
  if (nextList != null) {
    onePictureDataData.nextList = nextList;
  }
  final String? lineColor = jsonConvert.convert<String>(json['lineColor']);
  if (lineColor != null) {
    onePictureDataData.lineColor = lineColor;
  }
  final String? errorTxt = jsonConvert.convert<String>(json['errorTxt']);
  if (errorTxt != null) {
    onePictureDataData.errorTxt = errorTxt;
  }
  final bool? showArrow = jsonConvert.convert<bool>(json['showArrow']);
  if (showArrow != null) {
    onePictureDataData.showArrow = showArrow;
  }
  final bool? showBorder = jsonConvert.convert<bool>(json['showBorder']);
  if (showBorder != null) {
    onePictureDataData.showBorder = showBorder;
  }
  final List<OnePictureDataData>? children = (json['children'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<OnePictureDataData>(e) as OnePictureDataData)
      .toList();
  if (children != null) {
    onePictureDataData.children = children;
  }
  return onePictureDataData;
}

Map<String, dynamic> $OnePictureDataDataToJson(OnePictureDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['node_code'] = entity.nodeCode;
  data['fault'] = entity.fault;
  data['idParent'] = entity.idParent;
  data['nodeCodeParent'] = entity.nodeCodeParent;
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['desc'] = entity.desc;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['sameTypeData'] = entity.sameTypeData;
  data['ignore'] = entity.ignore;
  data['show'] = entity.show;
  data['unknown'] = entity.unknown;
  data['parent'] = entity.parent?.toJson();
  data['showAddBtn2'] = entity.showAddBtn2;
  data['nextList'] = entity.nextList.map((v) => v.toJson()).toList();
  data['lineColor'] = entity.lineColor;
  data['errorTxt'] = entity.errorTxt;
  data['showArrow'] = entity.showArrow;
  data['showBorder'] = entity.showBorder;
  data['children'] = entity.children.map((v) => v.toJson()).toList();
  return data;
}

extension OnePictureDataDataExtension on OnePictureDataData {
  OnePictureDataData copyWith({
    String? id,
    String? name,
    String? nodeCode,
    List<String>? fault,
    String? idParent,
    String? nodeCodeParent,
    int? type,
    String? typeText,
    String? desc,
    String? deviceCode,
    String? ip,
    String? mac,
    bool? sameTypeData,
    bool? ignore,
    bool? show,
    bool? unknown,
    OnePictureDataData? parent,
    bool? showAddBtn2,
    IconData? iconData,
    String? icon,
    List<OnePictureDataData>? nextList,
    String? lineColor,
    String? errorTxt,
    bool? showArrow,
    bool? showBorder,
    List<OnePictureDataData>? children,
  }) {
    return OnePictureDataData()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..nodeCode = nodeCode ?? this.nodeCode
      ..fault = fault ?? this.fault
      ..idParent = idParent ?? this.idParent
      ..nodeCodeParent = nodeCodeParent ?? this.nodeCodeParent
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..desc = desc ?? this.desc
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..sameTypeData = sameTypeData ?? this.sameTypeData
      ..ignore = ignore ?? this.ignore
      ..show = show ?? this.show
      ..unknown = unknown ?? this.unknown
      ..parent = parent ?? this.parent
      ..showAddBtn2 = showAddBtn2 ?? this.showAddBtn2
      ..iconData = iconData ?? this.iconData
      ..icon = icon ?? this.icon
      ..nextList = nextList ?? this.nextList
      ..lineColor = lineColor ?? this.lineColor
      ..errorTxt = errorTxt ?? this.errorTxt
      ..showArrow = showArrow ?? this.showArrow
      ..showBorder = showBorder ?? this.showBorder
      ..children = children ?? this.children;
  }
}