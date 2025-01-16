import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/local_device_entity.g.dart';
import 'dart:convert';

import 'package:xml/xml.dart';
export 'package:omt/generated/json/local_device_entity.g.dart';

@JsonSerializable()
class LocalDeviceEntity {
  String? domainName;
  String? deviceName;
  String? deviceType;
  String? target;
  int? port;
  String? ipAddress;
  String? macAddress;
  String? text;
  bool? selected;

  LocalDeviceEntity(
      {this.domainName,
      this.deviceName,
      this.deviceType,
      this.target,
      this.port,
      this.ipAddress,
      this.macAddress,
      this.text,
      this.selected});

  factory LocalDeviceEntity.fromJson(Map<String, dynamic> json) =>
      $LocalDeviceEntityFromJson(json);

  Map<String, dynamic> toJson() => $LocalDeviceEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  factory LocalDeviceEntity.fromXml(String xmlString, String ip) {
    final document = XmlDocument.parse(xmlString);
    final deviceInfoElement = document.findElements('DeviceInfo').first;
    return LocalDeviceEntity(
      deviceType: deviceInfoElement.findElements('deviceType').first.text,
      ipAddress: ip,
      macAddress: deviceInfoElement.findElements('macAddress').first.text,
    );
  }
}
