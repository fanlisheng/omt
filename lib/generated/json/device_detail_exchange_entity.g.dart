import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_exchange_entity.dart';

DeviceDetailExchangeEntity $DeviceDetailExchangeEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailExchangeEntity deviceDetailExchangeEntity = DeviceDetailExchangeEntity();
  final DeviceDetailExchangeData? data = jsonConvert.convert<
      DeviceDetailExchangeData>(json['data']);
  if (data != null) {
    deviceDetailExchangeEntity.data = data;
  }
  return deviceDetailExchangeEntity;
}

Map<String, dynamic> $DeviceDetailExchangeEntityToJson(
    DeviceDetailExchangeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailExchangeEntityExtension on DeviceDetailExchangeEntity {
  DeviceDetailExchangeEntity copyWith({
    DeviceDetailExchangeData? data,
  }) {
    return DeviceDetailExchangeEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailExchangeData $DeviceDetailExchangeDataFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailExchangeData deviceDetailExchangeData = DeviceDetailExchangeData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailExchangeData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailExchangeData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailExchangeData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailExchangeData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailExchangeData.deviceCode = deviceCode;
  }
  final int? interfaceNum = jsonConvert.convert<int>(json['interface_num']);
  if (interfaceNum != null) {
    deviceDetailExchangeData.interfaceNum = interfaceNum;
  }
  final String? powerMethod = jsonConvert.convert<String>(json['power_method']);
  if (powerMethod != null) {
    deviceDetailExchangeData.powerMethod = powerMethod;
  }
  return deviceDetailExchangeData;
}

Map<String, dynamic> $DeviceDetailExchangeDataToJson(
    DeviceDetailExchangeData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['interface_num'] = entity.interfaceNum;
  data['power_method'] = entity.powerMethod;
  return data;
}

extension DeviceDetailExchangeDataExtension on DeviceDetailExchangeData {
  DeviceDetailExchangeData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    int? interfaceNum,
    String? powerMethod,
  }) {
    return DeviceDetailExchangeData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..interfaceNum = interfaceNum ?? this.interfaceNum
      ..powerMethod = powerMethod ?? this.powerMethod;
  }
}