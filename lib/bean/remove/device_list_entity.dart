import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_list_entity.g.dart';
import 'dart:convert';

export 'package:omt/generated/json/device_list_entity.g.dart';

@JsonSerializable()
class DeviceListEntity {
  List<DeviceListData>? data = [];

  DeviceListEntity();

  factory DeviceListEntity.fromJson(Map<String, dynamic> json) =>
      $DeviceListEntityFromJson(json);

  Map<String, dynamic> toJson() => $DeviceListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceListData {
  String? id = '';
  @JSONField(name: 'node_id')
  String? nodeId = '';
  @JSONField(name: 'node_code')
  String? nodeCode = '';
  String? name = '';
  int? type = 0;
  @JSONField(name: 'type_text')
  String? typeText = '';
  @JSONField(name: 'device_code')
  String? deviceCode = '';
  String? ip = '';
  String? mac = '';
  String? desc = '';
  bool? selected = true;

  DeviceListData();

  factory DeviceListData.fromJson(Map<String, dynamic> json) =>
      $DeviceListDataFromJson(json);

  Map<String, dynamic> toJson() => $DeviceListDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}


@JsonSerializable()
class DevicesRemoveStatusEntity {
  // DevicesRemoveStatusData? data;
  @JSONField(name: 'uninstall_failed_devices')
  List<DeviceListData>? uninstallFailedDevices = [];
  @JSONField(name: 'wait_approve_devices')
  List<DeviceListData>? waitApproveDevices = [];
  @JSONField(name: 'uninstallable_devices')
  List<DeviceListData>? uninstallableDevices = [];

  DevicesRemoveStatusEntity();

  factory DevicesRemoveStatusEntity.fromJson(Map<String, dynamic> json) => $DevicesRemoveStatusEntityFromJson(json);

  Map<String, dynamic> toJson() => $DevicesRemoveStatusEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DevicesRemoveStatusData {
  @JSONField(name: 'uninstall_failed_devices')
  List<DeviceListData>? uninstallFailedDevices = [];
  @JSONField(name: 'wait_approve_devices')
  List<DeviceListData>? waitApproveDevices = [];
  @JSONField(name: 'uninstallable_devices')
  List<DeviceListData>? uninstallableDevices = [];

  DevicesRemoveStatusData();

  factory DevicesRemoveStatusData.fromJson(Map<String, dynamic> json) =>
      $DevicesRemoveStatusDataFromJson(json);

  	Map<String, dynamic> toJson() => $DevicesRemoveStatusDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
