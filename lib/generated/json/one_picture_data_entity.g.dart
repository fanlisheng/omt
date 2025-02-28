import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';

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
  final List<OnePictureDataDataChildren>? children = (json['children'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<OnePictureDataDataChildren>(
          e) as OnePictureDataDataChildren).toList();
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
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['desc'] = entity.desc;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['children'] = entity.children?.map((v) => v.toJson()).toList();
  return data;
}

extension OnePictureDataDataExtension on OnePictureDataData {
  OnePictureDataData copyWith({
    String? id,
    String? name,
    String? nodeCode,
    int? type,
    String? typeText,
    String? desc,
    String? deviceCode,
    String? ip,
    String? mac,
    List<OnePictureDataDataChildren>? children,
  }) {
    return OnePictureDataData()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..nodeCode = nodeCode ?? this.nodeCode
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..desc = desc ?? this.desc
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..children = children ?? this.children;
  }
}

OnePictureDataDataChildren $OnePictureDataDataChildrenFromJson(
    Map<String, dynamic> json) {
  final OnePictureDataDataChildren onePictureDataDataChildren = OnePictureDataDataChildren();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    onePictureDataDataChildren.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    onePictureDataDataChildren.name = name;
  }
  final String? nodeCode = jsonConvert.convert<String>(json['node_code']);
  if (nodeCode != null) {
    onePictureDataDataChildren.nodeCode = nodeCode;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    onePictureDataDataChildren.type = type;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    onePictureDataDataChildren.typeText = typeText;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    onePictureDataDataChildren.desc = desc;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    onePictureDataDataChildren.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    onePictureDataDataChildren.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    onePictureDataDataChildren.mac = mac;
  }
  final List<
      OnePictureDataDataChildrenChildren>? children = (json['children'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<OnePictureDataDataChildrenChildren>(
          e) as OnePictureDataDataChildrenChildren).toList();
  if (children != null) {
    onePictureDataDataChildren.children = children;
  }
  return onePictureDataDataChildren;
}

Map<String, dynamic> $OnePictureDataDataChildrenToJson(
    OnePictureDataDataChildren entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['node_code'] = entity.nodeCode;
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['desc'] = entity.desc;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['children'] = entity.children?.map((v) => v.toJson()).toList();
  return data;
}

extension OnePictureDataDataChildrenExtension on OnePictureDataDataChildren {
  OnePictureDataDataChildren copyWith({
    String? id,
    String? name,
    String? nodeCode,
    int? type,
    String? typeText,
    String? desc,
    String? deviceCode,
    String? ip,
    String? mac,
    List<OnePictureDataDataChildrenChildren>? children,
  }) {
    return OnePictureDataDataChildren()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..nodeCode = nodeCode ?? this.nodeCode
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..desc = desc ?? this.desc
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..children = children ?? this.children;
  }
}

OnePictureDataDataChildrenChildren $OnePictureDataDataChildrenChildrenFromJson(
    Map<String, dynamic> json) {
  final OnePictureDataDataChildrenChildren onePictureDataDataChildrenChildren = OnePictureDataDataChildrenChildren();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    onePictureDataDataChildrenChildren.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    onePictureDataDataChildrenChildren.name = name;
  }
  final String? nodeCode = jsonConvert.convert<String>(json['node_code']);
  if (nodeCode != null) {
    onePictureDataDataChildrenChildren.nodeCode = nodeCode;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    onePictureDataDataChildrenChildren.type = type;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    onePictureDataDataChildrenChildren.typeText = typeText;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    onePictureDataDataChildrenChildren.desc = desc;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    onePictureDataDataChildrenChildren.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    onePictureDataDataChildrenChildren.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    onePictureDataDataChildrenChildren.mac = mac;
  }
  final List<
      OnePictureDataDataChildrenChildrenChildren>? children = (json['children'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<OnePictureDataDataChildrenChildrenChildren>(
          e) as OnePictureDataDataChildrenChildrenChildren).toList();
  if (children != null) {
    onePictureDataDataChildrenChildren.children = children;
  }
  return onePictureDataDataChildrenChildren;
}

Map<String, dynamic> $OnePictureDataDataChildrenChildrenToJson(
    OnePictureDataDataChildrenChildren entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['node_code'] = entity.nodeCode;
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['desc'] = entity.desc;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['children'] = entity.children?.map((v) => v.toJson()).toList();
  return data;
}

extension OnePictureDataDataChildrenChildrenExtension on OnePictureDataDataChildrenChildren {
  OnePictureDataDataChildrenChildren copyWith({
    String? id,
    String? name,
    String? nodeCode,
    int? type,
    String? typeText,
    String? desc,
    String? deviceCode,
    String? ip,
    String? mac,
    List<OnePictureDataDataChildrenChildrenChildren>? children,
  }) {
    return OnePictureDataDataChildrenChildren()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..nodeCode = nodeCode ?? this.nodeCode
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..desc = desc ?? this.desc
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..children = children ?? this.children;
  }
}

OnePictureDataDataChildrenChildrenChildren $OnePictureDataDataChildrenChildrenChildrenFromJson(
    Map<String, dynamic> json) {
  final OnePictureDataDataChildrenChildrenChildren onePictureDataDataChildrenChildrenChildren = OnePictureDataDataChildrenChildrenChildren();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    onePictureDataDataChildrenChildrenChildren.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    onePictureDataDataChildrenChildrenChildren.name = name;
  }
  final String? nodeCode = jsonConvert.convert<String>(json['node_code']);
  if (nodeCode != null) {
    onePictureDataDataChildrenChildrenChildren.nodeCode = nodeCode;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    onePictureDataDataChildrenChildrenChildren.type = type;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    onePictureDataDataChildrenChildrenChildren.typeText = typeText;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    onePictureDataDataChildrenChildrenChildren.desc = desc;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    onePictureDataDataChildrenChildrenChildren.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    onePictureDataDataChildrenChildrenChildren.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    onePictureDataDataChildrenChildrenChildren.mac = mac;
  }
  final List<dynamic>? children = (json['children'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (children != null) {
    onePictureDataDataChildrenChildrenChildren.children = children;
  }
  return onePictureDataDataChildrenChildrenChildren;
}

Map<String, dynamic> $OnePictureDataDataChildrenChildrenChildrenToJson(
    OnePictureDataDataChildrenChildrenChildren entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['node_code'] = entity.nodeCode;
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['desc'] = entity.desc;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['children'] = entity.children;
  return data;
}

extension OnePictureDataDataChildrenChildrenChildrenExtension on OnePictureDataDataChildrenChildrenChildren {
  OnePictureDataDataChildrenChildrenChildren copyWith({
    String? id,
    String? name,
    String? nodeCode,
    int? type,
    String? typeText,
    String? desc,
    String? deviceCode,
    String? ip,
    String? mac,
    List<dynamic>? children,
  }) {
    return OnePictureDataDataChildrenChildrenChildren()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..nodeCode = nodeCode ?? this.nodeCode
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..desc = desc ?? this.desc
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..children = children ?? this.children;
  }
}