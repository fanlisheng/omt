import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/remove/device_list_entity.dart';

DeviceListEntity $DeviceListEntityFromJson(Map<String, dynamic> json) {
  final DeviceListEntity deviceListEntity = DeviceListEntity();
  final List<DeviceListData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DeviceListData>(e) as DeviceListData)
      .toList();
  if (data != null) {
    deviceListEntity.data = data;
  }
  return deviceListEntity;
}

Map<String, dynamic> $DeviceListEntityToJson(DeviceListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  return data;
}

extension DeviceListEntityExtension on DeviceListEntity {
  DeviceListEntity copyWith({
    List<DeviceListData>? data,
  }) {
    return DeviceListEntity()
      ..data = data ?? this.data;
  }
}

DeviceListData $DeviceListDataFromJson(Map<String, dynamic> json) {
  final DeviceListData deviceListData = DeviceListData();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    deviceListData.id = id;
  }
  final String? nodeCode = jsonConvert.convert<String>(json['node_code']);
  if (nodeCode != null) {
    deviceListData.nodeCode = nodeCode;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    deviceListData.name = name;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    deviceListData.type = type;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    deviceListData.typeText = typeText;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceListData.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    deviceListData.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    deviceListData.mac = mac;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    deviceListData.desc = desc;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    deviceListData.selected = selected;
  }
  return deviceListData;
}

Map<String, dynamic> $DeviceListDataToJson(DeviceListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['node_code'] = entity.nodeCode;
  data['name'] = entity.name;
  data['type'] = entity.type;
  data['type_text'] = entity.typeText;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['desc'] = entity.desc;
  data['selected'] = entity.selected;
  return data;
}

extension DeviceListDataExtension on DeviceListData {
  DeviceListData copyWith({
    String? id,
    String? nodeCode,
    String? name,
    int? type,
    String? typeText,
    String? deviceCode,
    String? ip,
    String? mac,
    String? desc,
    bool? selected,
  }) {
    return DeviceListData()
      ..id = id ?? this.id
      ..nodeCode = nodeCode ?? this.nodeCode
      ..name = name ?? this.name
      ..type = type ?? this.type
      ..typeText = typeText ?? this.typeText
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..desc = desc ?? this.desc
      ..selected = selected ?? this.selected;
  }
}