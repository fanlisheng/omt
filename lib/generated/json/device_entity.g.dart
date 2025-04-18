import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/generated/json/base/json_convert_content.dart';

import 'package:omt/utils/device_utils.dart';

import 'package:xml/xml.dart';


DeviceEntity $DeviceEntityFromJson(Map<String, dynamic> json) {
  final DeviceEntity deviceEntity = DeviceEntity();
  final int? deviceType = jsonConvert.convert<int>(json['device_type']);
  if (deviceType != null) {
    deviceEntity.deviceType = deviceType;
  }
  final String? deviceTypeText = jsonConvert.convert<String>(
      json['deviceTypeText']);
  if (deviceTypeText != null) {
    deviceEntity.deviceTypeText = deviceTypeText;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    deviceEntity.ip = ip;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceEntity.deviceCode = deviceCode;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    deviceEntity.mac = mac;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    deviceEntity.selected = selected;
  }
  final List<String>? fault = (json['fault'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (fault != null) {
    deviceEntity.fault = fault;
  }
  return deviceEntity;
}

Map<String, dynamic> $DeviceEntityToJson(DeviceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['device_type'] = entity.deviceType;
  data['deviceTypeText'] = entity.deviceTypeText;
  data['ip'] = entity.ip;
  data['device_code'] = entity.deviceCode;
  data['mac'] = entity.mac;
  data['selected'] = entity.selected;
  data['fault'] = entity.fault;
  return data;
}

extension DeviceEntityExtension on DeviceEntity {
  DeviceEntity copyWith({
    int? deviceType,
    String? deviceTypeText,
    String? ip,
    String? deviceCode,
    String? mac,
    bool? selected,
    List<String>? fault,
  }) {
    return DeviceEntity()
      ..deviceType = deviceType ?? this.deviceType
      ..deviceTypeText = deviceTypeText ?? this.deviceTypeText
      ..ip = ip ?? this.ip
      ..deviceCode = deviceCode ?? this.deviceCode
      ..mac = mac ?? this.mac
      ..selected = selected ?? this.selected
      ..fault = fault ?? this.fault;
  }
}

DeviceScanEntity $DeviceScanEntityFromJson(Map<String, dynamic> json) {
  final DeviceScanEntity deviceScanEntity = DeviceScanEntity();
  final String? instanceId = jsonConvert.convert<String>(json['instance_id']);
  if (instanceId != null) {
    deviceScanEntity.instanceId = instanceId;
  }
  final List<DeviceEntity>? devices = (json['devices'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<DeviceEntity>(e) as DeviceEntity).toList();
  if (devices != null) {
    deviceScanEntity.devices = devices;
  }
  final List<DeviceEntity>? unboundDevices = (json['unbound_devices'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<DeviceEntity>(e) as DeviceEntity).toList();
  if (unboundDevices != null) {
    deviceScanEntity.unboundDevices = unboundDevices;
  }
  return deviceScanEntity;
}

Map<String, dynamic> $DeviceScanEntityToJson(DeviceScanEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_id'] = entity.instanceId;
  data['devices'] = entity.devices?.map((v) => v.toJson()).toList();
  data['unbound_devices'] =
      entity.unboundDevices?.map((v) => v.toJson()).toList();
  return data;
}

extension DeviceScanEntityExtension on DeviceScanEntity {
  DeviceScanEntity copyWith({
    String? instanceId,
    List<DeviceEntity>? devices,
    List<DeviceEntity>? unboundDevices,
  }) {
    return DeviceScanEntity()
      ..instanceId = instanceId ?? this.instanceId
      ..devices = devices ?? this.devices
      ..unboundDevices = unboundDevices ?? this.unboundDevices;
  }
}