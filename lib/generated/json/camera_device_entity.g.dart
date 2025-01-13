import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:fluent_ui/fluent_ui.dart';


CameraDeviceEntity $CameraDeviceEntityFromJson(Map<String, dynamic> json) {
  final CameraDeviceEntity cameraDeviceEntity = CameraDeviceEntity();
  final bool? isOpen = jsonConvert.convert<bool>(json['isOpen']);
  if (isOpen != null) {
    cameraDeviceEntity.isOpen = isOpen;
  }
  final String? rtsp = jsonConvert.convert<String>(json['rtsp']);
  if (rtsp != null) {
    cameraDeviceEntity.rtsp = rtsp;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    cameraDeviceEntity.code = code;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    cameraDeviceEntity.name = name;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    cameraDeviceEntity.type = type;
  }
  final String? entryExit = jsonConvert.convert<String>(json['entryExit']);
  if (entryExit != null) {
    cameraDeviceEntity.entryExit = entryExit;
  }
  final String? isRegulation = jsonConvert.convert<String>(
      json['isRegulation']);
  if (isRegulation != null) {
    cameraDeviceEntity.isRegulation = isRegulation;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    cameraDeviceEntity.id = id;
  }
  final bool? readOnly = jsonConvert.convert<bool>(json['readOnly']);
  if (readOnly != null) {
    cameraDeviceEntity.readOnly = readOnly;
  }
  final TextEditingController? rtspController = jsonConvert.convert<
      TextEditingController>(json['rtspController']);
  if (rtspController != null) {
    cameraDeviceEntity.rtspController = rtspController;
  }
  final TextEditingController? deviceNameController = jsonConvert.convert<
      TextEditingController>(json['deviceNameController']);
  if (deviceNameController != null) {
    cameraDeviceEntity.deviceNameController = deviceNameController;
  }
  final TextEditingController? videoIdController = jsonConvert.convert<
      TextEditingController>(json['videoIdController']);
  if (videoIdController != null) {
    cameraDeviceEntity.videoIdController = videoIdController;
  }
  final String? selectedEntryExit = jsonConvert.convert<String>(
      json['selectedEntryExit']);
  if (selectedEntryExit != null) {
    cameraDeviceEntity.selectedEntryExit = selectedEntryExit;
  }
  final String? selectedCameraType = jsonConvert.convert<String>(
      json['selectedCameraType']);
  if (selectedCameraType != null) {
    cameraDeviceEntity.selectedCameraType = selectedCameraType;
  }
  final String? selectedRegulation = jsonConvert.convert<String>(
      json['selectedRegulation']);
  if (selectedRegulation != null) {
    cameraDeviceEntity.selectedRegulation = selectedRegulation;
  }
  return cameraDeviceEntity;
}

Map<String, dynamic> $CameraDeviceEntityToJson(CameraDeviceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['isOpen'] = entity.isOpen;
  data['rtsp'] = entity.rtsp;
  data['code'] = entity.code;
  data['name'] = entity.name;
  data['type'] = entity.type;
  data['entryExit'] = entity.entryExit;
  data['isRegulation'] = entity.isRegulation;
  data['id'] = entity.id;
  data['readOnly'] = entity.readOnly;
  data['selectedEntryExit'] = entity.selectedEntryExit;
  data['selectedCameraType'] = entity.selectedCameraType;
  data['selectedRegulation'] = entity.selectedRegulation;
  return data;
}

extension CameraDeviceEntityExtension on CameraDeviceEntity {
  CameraDeviceEntity copyWith({
    bool? isOpen,
    String? rtsp,
    String? code,
    String? name,
    String? type,
    String? entryExit,
    String? isRegulation,
    String? id,
    bool? readOnly,
    TextEditingController? rtspController,
    TextEditingController? deviceNameController,
    TextEditingController? videoIdController,
    String? selectedEntryExit,
    String? selectedCameraType,
    String? selectedRegulation,
  }) {
    return CameraDeviceEntity()
      ..isOpen = isOpen ?? this.isOpen
      ..rtsp = rtsp ?? this.rtsp
      ..code = code ?? this.code
      ..name = name ?? this.name
      ..type = type ?? this.type
      ..entryExit = entryExit ?? this.entryExit
      ..isRegulation = isRegulation ?? this.isRegulation
      ..id = id ?? this.id
      ..readOnly = readOnly ?? this.readOnly
      ..rtspController = rtspController ?? this.rtspController
      ..deviceNameController = deviceNameController ?? this.deviceNameController
      ..videoIdController = videoIdController ?? this.videoIdController
      ..selectedEntryExit = selectedEntryExit ?? this.selectedEntryExit
      ..selectedCameraType = selectedCameraType ?? this.selectedCameraType
      ..selectedRegulation = selectedRegulation ?? this.selectedRegulation;
  }
}