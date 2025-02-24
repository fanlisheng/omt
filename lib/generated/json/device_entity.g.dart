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
  }) {
    return DeviceEntity()
      ..deviceType = deviceType ?? this.deviceType
      ..deviceTypeText = deviceTypeText ?? this.deviceTypeText
      ..ip = ip ?? this.ip
      ..deviceCode = deviceCode ?? this.deviceCode
      ..mac = mac ?? this.mac
      ..selected = selected ?? this.selected;
  }
}