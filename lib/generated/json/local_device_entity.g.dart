import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/local_device_entity.dart';
import 'package:xml/xml.dart';


LocalDeviceEntity $LocalDeviceEntityFromJson(Map<String, dynamic> json) {
  final LocalDeviceEntity localDeviceEntity = LocalDeviceEntity();
  final String? domainName = jsonConvert.convert<String>(json['domainName']);
  if (domainName != null) {
    localDeviceEntity.domainName = domainName;
  }
  final String? deviceName = jsonConvert.convert<String>(json['deviceName']);
  if (deviceName != null) {
    localDeviceEntity.deviceName = deviceName;
  }
  final String? deviceType = jsonConvert.convert<String>(json['deviceType']);
  if (deviceType != null) {
    localDeviceEntity.deviceType = deviceType;
  }
  final String? target = jsonConvert.convert<String>(json['target']);
  if (target != null) {
    localDeviceEntity.target = target;
  }
  final int? port = jsonConvert.convert<int>(json['port']);
  if (port != null) {
    localDeviceEntity.port = port;
  }
  final String? ipAddress = jsonConvert.convert<String>(json['ipAddress']);
  if (ipAddress != null) {
    localDeviceEntity.ipAddress = ipAddress;
  }
  final String? macAddress = jsonConvert.convert<String>(json['macAddress']);
  if (macAddress != null) {
    localDeviceEntity.macAddress = macAddress;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    localDeviceEntity.text = text;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    localDeviceEntity.selected = selected;
  }
  return localDeviceEntity;
}

Map<String, dynamic> $LocalDeviceEntityToJson(LocalDeviceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['domainName'] = entity.domainName;
  data['deviceName'] = entity.deviceName;
  data['deviceType'] = entity.deviceType;
  data['target'] = entity.target;
  data['port'] = entity.port;
  data['ipAddress'] = entity.ipAddress;
  data['macAddress'] = entity.macAddress;
  data['text'] = entity.text;
  data['selected'] = entity.selected;
  return data;
}

extension LocalDeviceEntityExtension on LocalDeviceEntity {
  LocalDeviceEntity copyWith({
    String? domainName,
    String? deviceName,
    String? deviceType,
    String? target,
    int? port,
    String? ipAddress,
    String? macAddress,
    String? text,
    bool? selected,
  }) {
    return LocalDeviceEntity()
      ..domainName = domainName ?? this.domainName
      ..deviceName = deviceName ?? this.deviceName
      ..deviceType = deviceType ?? this.deviceType
      ..target = target ?? this.target
      ..port = port ?? this.port
      ..ipAddress = ipAddress ?? this.ipAddress
      ..macAddress = macAddress ?? this.macAddress
      ..text = text ?? this.text
      ..selected = selected ?? this.selected;
  }
}