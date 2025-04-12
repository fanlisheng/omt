import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_power_entity.dart';

DeviceDetailPowerEntity $DeviceDetailPowerEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailPowerEntity deviceDetailPowerEntity = DeviceDetailPowerEntity();
  final DeviceDetailPowerData? data = jsonConvert.convert<
      DeviceDetailPowerData>(json['data']);
  if (data != null) {
    deviceDetailPowerEntity.data = data;
  }
  return deviceDetailPowerEntity;
}

Map<String, dynamic> $DeviceDetailPowerEntityToJson(
    DeviceDetailPowerEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailPowerEntityExtension on DeviceDetailPowerEntity {
  DeviceDetailPowerEntity copyWith({
    DeviceDetailPowerData? data,
  }) {
    return DeviceDetailPowerEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailPowerData $DeviceDetailPowerDataFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailPowerData deviceDetailPowerData = DeviceDetailPowerData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailPowerData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailPowerData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailPowerData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailPowerData.labelName = labelName;
  }
  final String? powerType = jsonConvert.convert<String>(json['power_type']);
  if (powerType != null) {
    deviceDetailPowerData.powerType = powerType;
  }
  final int? batteryCapacity = jsonConvert.convert<int>(
      json['battery_capacity']);
  if (batteryCapacity != null) {
    deviceDetailPowerData.batteryCapacity = batteryCapacity;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailPowerData.nodeId = nodeId;
  }
  final String? instanceId = jsonConvert.convert<String>(json['instance_id']);
  if (instanceId != null) {
    deviceDetailPowerData.instanceId = instanceId;
  }
  return deviceDetailPowerData;
}

Map<String, dynamic> $DeviceDetailPowerDataToJson(
    DeviceDetailPowerData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['power_type'] = entity.powerType;
  data['battery_capacity'] = entity.batteryCapacity;
  data['node_id'] = entity.nodeId;
  data['instance_id'] = entity.instanceId;
  return data;
}

extension DeviceDetailPowerDataExtension on DeviceDetailPowerData {
  DeviceDetailPowerData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? powerType,
    int? batteryCapacity,
    String? nodeId,
    String? instanceId,
  }) {
    return DeviceDetailPowerData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..powerType = powerType ?? this.powerType
      ..batteryCapacity = batteryCapacity ?? this.batteryCapacity
      ..nodeId = nodeId ?? this.nodeId
      ..instanceId = instanceId ?? this.instanceId;
  }
}