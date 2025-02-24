import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_camera_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_camera_entity.g.dart';

@JsonSerializable()
class DeviceDetailCameraEntity {
	DeviceDetailCameraData? data;

	DeviceDetailCameraEntity();

	factory DeviceDetailCameraEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailCameraEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailCameraEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailCameraData {
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
	List<DeviceDetailCameraDataPhoto>? cameraStatus;
	@JSONField(name: "last_bg_photos")
	List<DeviceDetailCameraDataPhoto>? lastBgPhotos;
	@JSONField(name: "last_snap_photos")
	List<DeviceDetailCameraDataPhoto>? lastSnapPhotos;
	@JSONField(name: "day_basic_photo")
	DeviceDetailCameraDataPhoto? dayBasicPhoto;
	@JSONField(name: "night_basic_photo")
	DeviceDetailCameraDataPhoto? nightBasicPhoto;

	DeviceDetailCameraData();

	factory DeviceDetailCameraData.fromJson(Map<String, dynamic> json) => $DeviceDetailCameraDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailCameraDataToJson(this);

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

	DeviceDetailCameraDataPhoto();

	factory DeviceDetailCameraDataPhoto.fromJson(Map<String, dynamic> json) => $DeviceDetailCameraDataPhotoFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailCameraDataPhotoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
