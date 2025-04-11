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
