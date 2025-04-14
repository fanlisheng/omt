import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';

DeviceDetailAiEntity $DeviceDetailAiEntityFromJson(Map<String, dynamic> json) {
  final DeviceDetailAiEntity deviceDetailAiEntity = DeviceDetailAiEntity();
  final DeviceDetailAiData? data = jsonConvert.convert<DeviceDetailAiData>(
      json['data']);
  if (data != null) {
    deviceDetailAiEntity.data = data;
  }
  return deviceDetailAiEntity;
}

Map<String, dynamic> $DeviceDetailAiEntityToJson(DeviceDetailAiEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailAiEntityExtension on DeviceDetailAiEntity {
  DeviceDetailAiEntity copyWith({
    DeviceDetailAiData? data,
  }) {
    return DeviceDetailAiEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailAiData $DeviceDetailAiDataFromJson(Map<String, dynamic> json) {
  final DeviceDetailAiData deviceDetailAiData = DeviceDetailAiData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailAiData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailAiData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailAiData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailAiData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailAiData.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    deviceDetailAiData.ip = ip;
  }
  final String? programVersion = jsonConvert.convert<String>(
      json['program_version']);
  if (programVersion != null) {
    deviceDetailAiData.programVersion = programVersion;
  }
  final String? identityVersion = jsonConvert.convert<String>(
      json['identity_version']);
  if (identityVersion != null) {
    deviceDetailAiData.identityVersion = identityVersion;
  }
  final String? cameraDeviceCode = jsonConvert.convert<String>(
      json['camera_device_code']);
  if (cameraDeviceCode != null) {
    deviceDetailAiData.cameraDeviceCode = cameraDeviceCode;
  }
  final String? iotConnectStatus = jsonConvert.convert<String>(
      json['iot_connect_status']);
  if (iotConnectStatus != null) {
    deviceDetailAiData.iotConnectStatus = iotConnectStatus;
  }
  final String? serverHost = jsonConvert.convert<String>(json['server_host']);
  if (serverHost != null) {
    deviceDetailAiData.serverHost = serverHost;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailAiData.nodeId = nodeId;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    deviceDetailAiData.mac = mac;
  }
  final bool? isProgramLatest = jsonConvert.convert<bool>(
      json['is_program_latest']);
  if (isProgramLatest != null) {
    deviceDetailAiData.isProgramLatest = isProgramLatest;
  }
  final bool? isIdentityLatest = jsonConvert.convert<bool>(
      json['is_identity_latest']);
  if (isIdentityLatest != null) {
    deviceDetailAiData.isIdentityLatest = isIdentityLatest;
  }
  return deviceDetailAiData;
}

Map<String, dynamic> $DeviceDetailAiDataToJson(DeviceDetailAiData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['program_version'] = entity.programVersion;
  data['identity_version'] = entity.identityVersion;
  data['camera_device_code'] = entity.cameraDeviceCode;
  data['iot_connect_status'] = entity.iotConnectStatus;
  data['server_host'] = entity.serverHost;
  data['node_id'] = entity.nodeId;
  data['mac'] = entity.mac;
  data['is_program_latest'] = entity.isProgramLatest;
  data['is_identity_latest'] = entity.isIdentityLatest;
  return data;
}

extension DeviceDetailAiDataExtension on DeviceDetailAiData {
  DeviceDetailAiData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    String? ip,
    String? programVersion,
    String? identityVersion,
    String? cameraDeviceCode,
    String? iotConnectStatus,
    String? serverHost,
    String? nodeId,
    String? mac,
    bool? isProgramLatest,
    bool? isIdentityLatest,
  }) {
    return DeviceDetailAiData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..programVersion = programVersion ?? this.programVersion
      ..identityVersion = identityVersion ?? this.identityVersion
      ..cameraDeviceCode = cameraDeviceCode ?? this.cameraDeviceCode
      ..iotConnectStatus = iotConnectStatus ?? this.iotConnectStatus
      ..serverHost = serverHost ?? this.serverHost
      ..nodeId = nodeId ?? this.nodeId
      ..mac = mac ?? this.mac
      ..isProgramLatest = isProgramLatest ?? this.isProgramLatest
      ..isIdentityLatest = isIdentityLatest ?? this.isIdentityLatest;
  }
}