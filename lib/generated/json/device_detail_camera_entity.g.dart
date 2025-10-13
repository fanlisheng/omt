import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_camera_entity.dart';

DeviceDetailCameraEntity $DeviceDetailCameraEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailCameraEntity deviceDetailCameraEntity = DeviceDetailCameraEntity();
  final DeviceDetailCameraData? data = jsonConvert.convert<
      DeviceDetailCameraData>(json['data']);
  if (data != null) {
    deviceDetailCameraEntity.data = data;
  }
  return deviceDetailCameraEntity;
}

Map<String, dynamic> $DeviceDetailCameraEntityToJson(
    DeviceDetailCameraEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailCameraEntityExtension on DeviceDetailCameraEntity {
  DeviceDetailCameraEntity copyWith({
    DeviceDetailCameraData? data,
  }) {
    return DeviceDetailCameraEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailCameraData $DeviceDetailCameraDataFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailCameraData deviceDetailCameraData = DeviceDetailCameraData();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    deviceDetailCameraData.name = name;
  }
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailCameraData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailCameraData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailCameraData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailCameraData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailCameraData.deviceCode = deviceCode;
  }
  final String? rtspUrl = jsonConvert.convert<String>(json['rtsp_url']);
  if (rtspUrl != null) {
    deviceDetailCameraData.rtspUrl = rtspUrl;
  }
  final String? aiDeviceCode = jsonConvert.convert<String>(
      json['ai_device_code']);
  if (aiDeviceCode != null) {
    deviceDetailCameraData.aiDeviceCode = aiDeviceCode;
  }
  final String? cameraTypeText = jsonConvert.convert<String>(
      json['camera_type_text']);
  if (cameraTypeText != null) {
    deviceDetailCameraData.cameraTypeText = cameraTypeText;
  }
  final String? controlStatusText = jsonConvert.convert<String>(
      json['control_status_text']);
  if (controlStatusText != null) {
    deviceDetailCameraData.controlStatusText = controlStatusText;
  }
  final String? cameraCode = jsonConvert.convert<String>(json['camera_code']);
  if (cameraCode != null) {
    deviceDetailCameraData.cameraCode = cameraCode;
  }
  final List<String>? cameraStatus = (json['camera_status'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (cameraStatus != null) {
    deviceDetailCameraData.cameraStatus = cameraStatus;
  }
  final List<
      DeviceDetailCameraDataPhoto>? lastBgPhotos = (json['last_bg_photos'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceDetailCameraDataPhoto>(
          e) as DeviceDetailCameraDataPhoto).toList();
  if (lastBgPhotos != null) {
    deviceDetailCameraData.lastBgPhotos = lastBgPhotos;
  }
  final List<
      DeviceDetailCameraDataPhoto>? lastSnapPhotos = (json['last_snap_photos'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceDetailCameraDataPhoto>(
          e) as DeviceDetailCameraDataPhoto).toList();
  if (lastSnapPhotos != null) {
    deviceDetailCameraData.lastSnapPhotos = lastSnapPhotos;
  }
  final DeviceDetailCameraDataPhoto? dayBasicPhoto = jsonConvert.convert<
      DeviceDetailCameraDataPhoto>(json['day_basic_photo']);
  if (dayBasicPhoto != null) {
    deviceDetailCameraData.dayBasicPhoto = dayBasicPhoto;
  }
  final DeviceDetailCameraDataPhoto? nightBasicPhoto = jsonConvert.convert<
      DeviceDetailCameraDataPhoto>(json['night_basic_photo']);
  if (nightBasicPhoto != null) {
    deviceDetailCameraData.nightBasicPhoto = nightBasicPhoto;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailCameraData.nodeId = nodeId;
  }
  final String? aiDeviceIp = jsonConvert.convert<String>(json['ai_device_ip']);
  if (aiDeviceIp != null) {
    deviceDetailCameraData.aiDeviceIp = aiDeviceIp;
  }
  return deviceDetailCameraData;
}

Map<String, dynamic> $DeviceDetailCameraDataToJson(
    DeviceDetailCameraData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['rtsp_url'] = entity.rtspUrl;
  data['ai_device_code'] = entity.aiDeviceCode;
  data['camera_type_text'] = entity.cameraTypeText;
  data['control_status_text'] = entity.controlStatusText;
  data['camera_code'] = entity.cameraCode;
  data['camera_status'] = entity.cameraStatus;
  data['last_bg_photos'] = entity.lastBgPhotos?.map((v) => v.toJson()).toList();
  data['last_snap_photos'] =
      entity.lastSnapPhotos?.map((v) => v.toJson()).toList();
  data['day_basic_photo'] = entity.dayBasicPhoto?.toJson();
  data['night_basic_photo'] = entity.nightBasicPhoto?.toJson();
  data['node_id'] = entity.nodeId;
  data['ai_device_ip'] = entity.aiDeviceIp;
  return data;
}

extension DeviceDetailCameraDataExtension on DeviceDetailCameraData {
  DeviceDetailCameraData copyWith({
    String? name,
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    String? rtspUrl,
    String? aiDeviceCode,
    String? cameraTypeText,
    String? controlStatusText,
    String? cameraCode,
    List<String>? cameraStatus,
    List<DeviceDetailCameraDataPhoto>? lastBgPhotos,
    List<DeviceDetailCameraDataPhoto>? lastSnapPhotos,
    DeviceDetailCameraDataPhoto? dayBasicPhoto,
    DeviceDetailCameraDataPhoto? nightBasicPhoto,
    String? nodeId,
    String? aiDeviceIp,
  }) {
    return DeviceDetailCameraData()
      ..name = name ?? this.name
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..rtspUrl = rtspUrl ?? this.rtspUrl
      ..aiDeviceCode = aiDeviceCode ?? this.aiDeviceCode
      ..cameraTypeText = cameraTypeText ?? this.cameraTypeText
      ..controlStatusText = controlStatusText ?? this.controlStatusText
      ..cameraCode = cameraCode ?? this.cameraCode
      ..cameraStatus = cameraStatus ?? this.cameraStatus
      ..lastBgPhotos = lastBgPhotos ?? this.lastBgPhotos
      ..lastSnapPhotos = lastSnapPhotos ?? this.lastSnapPhotos
      ..dayBasicPhoto = dayBasicPhoto ?? this.dayBasicPhoto
      ..nightBasicPhoto = nightBasicPhoto ?? this.nightBasicPhoto
      ..nodeId = nodeId ?? this.nodeId
      ..aiDeviceIp = aiDeviceIp ?? this.aiDeviceIp;
  }
}

DeviceDetailCameraSnapList $DeviceDetailCameraSnapListFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailCameraSnapList deviceDetailCameraSnapList = DeviceDetailCameraSnapList();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    deviceDetailCameraSnapList.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    deviceDetailCameraSnapList.message = message;
  }
  final List<DeviceDetailCameraDataPhoto>? data = (json['data'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceDetailCameraDataPhoto>(
          e) as DeviceDetailCameraDataPhoto).toList();
  if (data != null) {
    deviceDetailCameraSnapList.data = data;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    deviceDetailCameraSnapList.status = status;
  }
  final String? details = jsonConvert.convert<String>(json['details']);
  if (details != null) {
    deviceDetailCameraSnapList.details = details;
  }
  final PageData? page = jsonConvert.convert<PageData>(json['page']);
  if (page != null) {
    deviceDetailCameraSnapList.page = page;
  }
  final String? requestId = jsonConvert.convert<String>(json['request_id']);
  if (requestId != null) {
    deviceDetailCameraSnapList.requestId = requestId;
  }
  return deviceDetailCameraSnapList;
}

Map<String, dynamic> $DeviceDetailCameraSnapListToJson(
    DeviceDetailCameraSnapList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  data['status'] = entity.status;
  data['details'] = entity.details;
  data['page'] = entity.page?.toJson();
  data['request_id'] = entity.requestId;
  return data;
}

extension DeviceDetailCameraSnapListExtension on DeviceDetailCameraSnapList {
  DeviceDetailCameraSnapList copyWith({
    String? code,
    String? message,
    List<DeviceDetailCameraDataPhoto>? data,
    String? status,
    String? details,
    PageData? page,
    String? requestId,
  }) {
    return DeviceDetailCameraSnapList()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data
      ..status = status ?? this.status
      ..details = details ?? this.details
      ..page = page ?? this.page
      ..requestId = requestId ?? this.requestId;
  }
}

DeviceDetailCameraDataPhoto $DeviceDetailCameraDataPhotoFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailCameraDataPhoto deviceDetailCameraDataPhoto = DeviceDetailCameraDataPhoto();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    deviceDetailCameraDataPhoto.url = url;
  }
  final String? updatedBy = jsonConvert.convert<String>(json['updated_by']);
  if (updatedBy != null) {
    deviceDetailCameraDataPhoto.updatedBy = updatedBy;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    deviceDetailCameraDataPhoto.updatedAt = updatedAt;
  }
  final String? snapAt = jsonConvert.convert<String>(json['snap_at']);
  if (snapAt != null) {
    deviceDetailCameraDataPhoto.snapAt = snapAt;
  }
  final String? typeText = jsonConvert.convert<String>(json['type_text']);
  if (typeText != null) {
    deviceDetailCameraDataPhoto.typeText = typeText;
  }
  return deviceDetailCameraDataPhoto;
}

Map<String, dynamic> $DeviceDetailCameraDataPhotoToJson(
    DeviceDetailCameraDataPhoto entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  data['updated_by'] = entity.updatedBy;
  data['updated_at'] = entity.updatedAt;
  data['snap_at'] = entity.snapAt;
  data['type_text'] = entity.typeText;
  return data;
}

extension DeviceDetailCameraDataPhotoExtension on DeviceDetailCameraDataPhoto {
  DeviceDetailCameraDataPhoto copyWith({
    String? url,
    String? updatedBy,
    String? updatedAt,
    String? snapAt,
    String? typeText,
  }) {
    return DeviceDetailCameraDataPhoto()
      ..url = url ?? this.url
      ..updatedBy = updatedBy ?? this.updatedBy
      ..updatedAt = updatedAt ?? this.updatedAt
      ..snapAt = snapAt ?? this.snapAt
      ..typeText = typeText ?? this.typeText;
  }
}

PageData $PageDataFromJson(Map<String, dynamic> json) {
  final PageData pageData = PageData();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    pageData.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    pageData.page = page;
  }
  final int? limit = jsonConvert.convert<int>(json['limit']);
  if (limit != null) {
    pageData.limit = limit;
  }
  return pageData;
}

Map<String, dynamic> $PageDataToJson(PageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['limit'] = entity.limit;
  return data;
}

extension PageDataExtension on PageData {
  PageData copyWith({
    int? total,
    int? page,
    int? limit,
  }) {
    return PageData()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..limit = limit ?? this.limit;
  }
}