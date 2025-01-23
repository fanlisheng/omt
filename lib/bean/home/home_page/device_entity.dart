import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:xml/xml.dart';

import '../../../generated/json/base/json_field.dart';

// @JsonSerializable()
class DeviceEntity {
  @JSONField(name: "device_type")
  int? deviceType;
  String? deviceTypeText;
  String? ip;
  @JSONField(name: "device_code")
  String? deviceCode;
  String? mac;
  bool? selected;

  DeviceEntity(
      {this.deviceType,
      this.deviceTypeText,
      this.ip,
      this.deviceCode,
      this.mac,
      this.selected});

  // factory DeviceEntity.fromJson(Map<String, dynamic> json) =>
  //     $DeviceEntityFromJson(json);
  //
  // Map<String, dynamic> toJson() => $DeviceEntityToJson(this);

  factory DeviceEntity.fromXml(String xmlString, String ip) {
    final document = XmlDocument.parse(xmlString);
    final deviceInfoElement = document.findElements('DeviceInfo').first;
    String deviceTypeText =
        deviceInfoElement.findElements('deviceType').first.text;
    int deviceType = DeviceUtils.getDeviceType(deviceTypeText);
    String mac = deviceInfoElement.findElements('macAddress').first.text;
    String deviceCode = deviceInfoElement.findElements('deviceID').first.text;

    DeviceEntity a = DeviceEntity(
      deviceTypeText: deviceTypeText,
      deviceType: deviceType,
      ip: ip,
      mac: mac,
      deviceCode: deviceCode,
    );
    return a;
  }
}
