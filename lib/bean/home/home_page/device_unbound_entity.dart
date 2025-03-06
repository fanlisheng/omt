import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_unbound_entity.g.dart';
import 'dart:convert';

// import 'device_entity.dart';
export 'package:omt/generated/json/device_unbound_entity.g.dart';

@JsonSerializable()
class DeviceUnboundEntity {
  @JSONField(name: "all_count")
  List<DeviceUnboundAllCount>? allCount;
  @JSONField(name: "abnormal_count")
  List<DeviceUnboundAbnormalCount>? abnormalCount;
  @JSONField(name: "unbound_devices")
  List<DeviceEntity>? unboundDevices;

  DeviceUnboundEntity();

  factory DeviceUnboundEntity.fromJson(Map<String, dynamic> json) =>
      $DeviceUnboundEntityFromJson(json);

  Map<String, dynamic> toJson() => $DeviceUnboundEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceUnboundAllCount {
  @JSONField(name: "device_type")
  int? deviceType;
  @JSONField(name: "device_type_text")
  String? deviceTypeText;
  int? count;

  DeviceUnboundAllCount();

  factory DeviceUnboundAllCount.fromJson(Map<String, dynamic> json) =>
      $DeviceUnboundAllCountFromJson(json);

  Map<String, dynamic> toJson() => $DeviceUnboundAllCountToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceUnboundAbnormalCount {
  @JSONField(name: "device_type")
  int? deviceType;
  @JSONField(name: "device_type_text")
  String? deviceTypeText;
  int? count;

  DeviceUnboundAbnormalCount();

  factory DeviceUnboundAbnormalCount.fromJson(Map<String, dynamic> json) =>
      $DeviceUnboundAbnormalCountFromJson(json);

  Map<String, dynamic> toJson() => $DeviceUnboundAbnormalCountToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
