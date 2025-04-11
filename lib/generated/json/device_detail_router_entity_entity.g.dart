import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_router_entity_entity.dart';

DeviceDetailRouterEntity $DeviceDetailRouterEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailRouterEntity deviceDetailRouterEntity = DeviceDetailRouterEntity();
  final DeviceDetailRouterData? data = jsonConvert.convert<
      DeviceDetailRouterData>(json['data']);
  if (data != null) {
    deviceDetailRouterEntity.data = data;
  }
  return deviceDetailRouterEntity;
}

Map<String, dynamic> $DeviceDetailRouterEntityToJson(
    DeviceDetailRouterEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailRouterEntityExtension on DeviceDetailRouterEntity {
  DeviceDetailRouterEntity copyWith({
    DeviceDetailRouterData? data,
  }) {
    return DeviceDetailRouterEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailRouterData $DeviceDetailRouterDataFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailRouterData deviceDetailRouterData = DeviceDetailRouterData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailRouterData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailRouterData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailRouterData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailRouterData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailRouterData.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    deviceDetailRouterData.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    deviceDetailRouterData.mac = mac;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    deviceDetailRouterData.typeText = typeText;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailRouterData.nodeId = nodeId;
  }
  return deviceDetailRouterData;
}

Map<String, dynamic> $DeviceDetailRouterDataToJson(
    DeviceDetailRouterData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['type_text'] = entity.typeText;
  data['node_id'] = entity.nodeId;
  return data;
}

extension DeviceDetailRouterDataExtension on DeviceDetailRouterData {
  DeviceDetailRouterData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    String? ip,
    String? mac,
    String? typeText,
    String? nodeId,
  }) {
    return DeviceDetailRouterData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..typeText = typeText ?? this.typeText
      ..nodeId = nodeId ?? this.nodeId;
  }
}