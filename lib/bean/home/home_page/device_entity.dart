import 'dart:convert';

import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:xml/xml.dart';

import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/device_entity.g.dart';

@JsonSerializable()
class DeviceEntity {
  @JSONField(name: "device_type")
  int? deviceType;
  String? deviceTypeText;
  String? ip;
  @JSONField(name: "device_code")
  String? deviceCode;
  String? mac;
  bool? selected;
  List<String>? fault;

  DeviceEntity(
      {this.deviceType,
      this.deviceTypeText,
      this.ip,
      this.deviceCode,
      this.mac,
      this.selected});

  factory DeviceEntity.fromJson(Map<String, dynamic> json) =>
      $DeviceEntityFromJson(json);

  Map<String, dynamic> toJson() => $DeviceEntityToJson(this);

  factory DeviceEntity.fromXml(String xmlString, String ip) {
    final document = XmlDocument.parse(xmlString);
    final deviceInfoElement = document.findElements('DeviceInfo').first;
    String deviceTypeText =
        deviceInfoElement.findElements('deviceType').first.text;
    String mac = deviceInfoElement.findElements('macAddress').first.text;
    String deviceCode = deviceInfoElement.findElements('deviceID').first.text;

    DeviceEntity a = DeviceEntity(
      deviceTypeText: deviceTypeText,
      // deviceType: deviceType,
      ip: ip,
      mac: mac,
      deviceCode: deviceCode,
    );
    return a;
  }
}

@JsonSerializable()
class DeviceScanEntity {
  @JSONField(name: "instance_id")
  String? instanceId;
  List<DeviceEntity>? devices;
  @JSONField(name: "unbound_devices")
  List<DeviceEntity>? unboundDevices;

  DeviceScanEntity();

  factory DeviceScanEntity.fromJson(Map<String, dynamic> json) => $DeviceScanEntityFromJson(json);

  Map<String, dynamic> toJson() => $DeviceScanEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
