import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'dart:convert';
import 'package:omt/generated/json/camera_entity.g.dart';

@JsonSerializable()
class CameraHttpEntity {
  int? code;
  String? message;
  CommonPageData? page;
  List<CameraInfoEntity>? data;

  CameraHttpEntity();

  factory CameraHttpEntity.fromJson(Map<String, dynamic> json) =>
      $CameraHttpEntityFromJson(json);

  Map<String, dynamic> toJson() => $CameraHttpEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CameraInfoEntity {
  String? gb_id;
  String? name;
  String? parent_id;
  String? lat;
  String? lng;
  String? pic;
  String? ip_address;
  String? rect_data;
  int? online;
  int? ptz_type;
  String? channel_info;
  String? point_name;

  CameraInfoEntity();

  factory CameraInfoEntity.fromJson(Map<String, dynamic> json) =>
      $CameraInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $CameraInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  duplicateIP(List<CameraInfoEntity?> list, CameraInfoEntity data) {
    var ipAddress = data.ip_address;
    int count = list.where((entity) => entity?.ip_address == ipAddress).length;
    if (BaseSysUtils.empty(ipAddress) || count < 2) {
      return false;
    }
    return count > 1;
  }
}
