import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_nvr_entity.dart';

DeviceDetailNvrEntity $DeviceDetailNvrEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailNvrEntity deviceDetailNvrEntity = DeviceDetailNvrEntity();
  final DeviceDetailNvrData? data = jsonConvert.convert<DeviceDetailNvrData>(
      json['data']);
  if (data != null) {
    deviceDetailNvrEntity.data = data;
  }
  return deviceDetailNvrEntity;
}

Map<String, dynamic> $DeviceDetailNvrEntityToJson(
    DeviceDetailNvrEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailNvrEntityExtension on DeviceDetailNvrEntity {
  DeviceDetailNvrEntity copyWith({
    DeviceDetailNvrData? data,
  }) {
    return DeviceDetailNvrEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailNvrData $DeviceDetailNvrDataFromJson(Map<String, dynamic> json) {
  final DeviceDetailNvrData deviceDetailNvrData = DeviceDetailNvrData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailNvrData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailNvrData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailNvrData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailNvrData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailNvrData.deviceCode = deviceCode;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    deviceDetailNvrData.ip = ip;
  }
  final String? mac = jsonConvert.convert<String>(json['mac']);
  if (mac != null) {
    deviceDetailNvrData.mac = mac;
  }
  final List<DeviceDetailNvrDataChannels>? channels = (json['channels'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceDetailNvrDataChannels>(
          e) as DeviceDetailNvrDataChannels).toList();
  if (channels != null) {
    deviceDetailNvrData.channels = channels;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailNvrData.nodeId = nodeId;
  }
  return deviceDetailNvrData;
}

Map<String, dynamic> $DeviceDetailNvrDataToJson(DeviceDetailNvrData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['ip'] = entity.ip;
  data['mac'] = entity.mac;
  data['channels'] = entity.channels?.map((v) => v.toJson()).toList();
  data['node_id'] = entity.nodeId;
  return data;
}

extension DeviceDetailNvrDataExtension on DeviceDetailNvrData {
  DeviceDetailNvrData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    String? ip,
    String? mac,
    List<DeviceDetailNvrDataChannels>? channels,
    String? nodeId,
  }) {
    return DeviceDetailNvrData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..ip = ip ?? this.ip
      ..mac = mac ?? this.mac
      ..channels = channels ?? this.channels
      ..nodeId = nodeId ?? this.nodeId;
  }
}

DeviceDetailNvrDataChannels $DeviceDetailNvrDataChannelsFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailNvrDataChannels deviceDetailNvrDataChannels = DeviceDetailNvrDataChannels();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    deviceDetailNvrDataChannels.id = id;
  }
  final int? channelNum = jsonConvert.convert<int>(json['channel_num']);
  if (channelNum != null) {
    deviceDetailNvrDataChannels.channelNum = channelNum;
  }
  final String? recordStatus = jsonConvert.convert<String>(
      json['record_status']);
  if (recordStatus != null) {
    deviceDetailNvrDataChannels.recordStatus = recordStatus;
  }
  final String? signalStatus = jsonConvert.convert<String>(
      json['signal_status']);
  if (signalStatus != null) {
    deviceDetailNvrDataChannels.signalStatus = signalStatus;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    deviceDetailNvrDataChannels.updatedAt = updatedAt;
  }
  return deviceDetailNvrDataChannels;
}

Map<String, dynamic> $DeviceDetailNvrDataChannelsToJson(
    DeviceDetailNvrDataChannels entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['channel_num'] = entity.channelNum;
  data['record_status'] = entity.recordStatus;
  data['signal_status'] = entity.signalStatus;
  data['updated_at'] = entity.updatedAt;
  return data;
}

extension DeviceDetailNvrDataChannelsExtension on DeviceDetailNvrDataChannels {
  DeviceDetailNvrDataChannels copyWith({
    int? id,
    int? channelNum,
    String? recordStatus,
    String? signalStatus,
    String? updatedAt,
  }) {
    return DeviceDetailNvrDataChannels()
      ..id = id ?? this.id
      ..channelNum = channelNum ?? this.channelNum
      ..recordStatus = recordStatus ?? this.recordStatus
      ..signalStatus = signalStatus ?? this.signalStatus
      ..updatedAt = updatedAt ?? this.updatedAt;
  }
}