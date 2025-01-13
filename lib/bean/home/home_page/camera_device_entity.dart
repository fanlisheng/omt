import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/camera_device_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/camera_device_entity.g.dart';

@JsonSerializable()
//
class CameraDeviceEntity {

  bool? isOpen = false;
	String? rtsp;
	String? code;
	String? name;
	String? type;
	String? entryExit;
	String? isRegulation;
	String? id;

  //不允许编辑
  bool readOnly = false;
  TextEditingController rtspController = TextEditingController();
  //设备名称
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController videoIdController = TextEditingController();
  // 进/出口选项
  String selectedEntryExit = "";
  //摄像头类型
  String selectedCameraType = "";
  //是否纳入监管
  String selectedRegulation = "";

  CameraDeviceEntity(
      {this.rtsp,
      this.code,
      this.name,
      this.type,
      this.entryExit,
      this.isRegulation,
      this.id,
      this.isOpen,
      });

  factory CameraDeviceEntity.fromJson(Map<String, dynamic> json) => $CameraDeviceEntityFromJson(json);

	Map<String, dynamic> toJson() => $CameraDeviceEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}