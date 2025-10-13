import 'dart:convert';


import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/device_detail_camera_entity.g.dart';

@JsonSerializable()
class DeviceDetailCameraEntity {
  DeviceDetailCameraData? data;

  DeviceDetailCameraEntity();

  factory DeviceDetailCameraEntity.fromJson(Map<String, dynamic> json) =>
      $DeviceDetailCameraEntityFromJson(json);

  Map<String, dynamic> toJson() => $DeviceDetailCameraEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceDetailCameraData {
  String? name;
  @JSONField(name: "instance_name")
  String? instanceName;
  @JSONField(name: "gate_name")
  String? gateName;
  @JSONField(name: "pass_name")
  String? passName;
  @JSONField(name: "label_name")
  String? labelName;
  @JSONField(name: "device_code")
  String? deviceCode;
  @JSONField(name: "rtsp_url")
  String? rtspUrl;
  @JSONField(name: "ai_device_code")
  String? aiDeviceCode;
  @JSONField(name: "camera_type_text")
  String? cameraTypeText;
  @JSONField(name: "control_status_text")
  String? controlStatusText;
  @JSONField(name: "camera_code")
  String? cameraCode;
  @JSONField(name: "camera_status")
  List<String>? cameraStatus;
  @JSONField(name: "last_bg_photos")
  List<DeviceDetailCameraDataPhoto>? lastBgPhotos;
  @JSONField(name: "last_snap_photos")
  List<DeviceDetailCameraDataPhoto>? lastSnapPhotos;
  @JSONField(name: "day_basic_photo")
  DeviceDetailCameraDataPhoto? dayBasicPhoto;
  @JSONField(name: "night_basic_photo")
  DeviceDetailCameraDataPhoto? nightBasicPhoto;
  @JSONField(name: "node_id")
  String? nodeId;
  @JSONField(name: "ai_device_ip")
  String? aiDeviceIp;

  DeviceDetailCameraData();

  factory DeviceDetailCameraData.fromJson(Map<String, dynamic> json) =>
      $DeviceDetailCameraDataFromJson(json);

  Map<String, dynamic> toJson() => $DeviceDetailCameraDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceDetailCameraSnapList {
  String? code;
  String? message;
  List<DeviceDetailCameraDataPhoto>? data;
  String? status;
  String? details;
  PageData? page;
  @JSONField(name: "request_id")
  String? requestId;

  DeviceDetailCameraSnapList();

  factory DeviceDetailCameraSnapList.fromJson(Map<String, dynamic> json) =>
      $DeviceDetailCameraSnapListFromJson(json);

  Map<String, dynamic> toJson() => $DeviceDetailCameraSnapListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceDetailCameraDataPhoto {
  String? url;
  @JSONField(name: "updated_by")
  String? updatedBy;
  @JSONField(name: "updated_at")
  String? updatedAt;
  @JSONField(name: "snap_at")
  String? snapAt;
  @JSONField(name: "type_text")
  String? typeText;

  DeviceDetailCameraDataPhoto(
      {this.url, this.updatedBy, this.updatedAt, this.snapAt, this.typeText});

  factory DeviceDetailCameraDataPhoto.fromJson(Map<String, dynamic> json) =>
      $DeviceDetailCameraDataPhotoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceDetailCameraDataPhotoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PageData {
  int? total;
  int? page;
  int? limit;

  PageData();

  factory PageData.fromJson(Map<String, dynamic> json) =>
      $PageDataFromJson(json);

  Map<String, dynamic> toJson() => $PageDataToJson(this);
}
