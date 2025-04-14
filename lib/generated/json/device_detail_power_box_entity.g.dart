import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_detail_power_box_entity.dart';

DeviceDetailPowerBoxEntity $DeviceDetailPowerBoxEntityFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailPowerBoxEntity deviceDetailPowerBoxEntity = DeviceDetailPowerBoxEntity();
  final DeviceDetailPowerBoxData? data = jsonConvert.convert<
      DeviceDetailPowerBoxData>(json['data']);
  if (data != null) {
    deviceDetailPowerBoxEntity.data = data;
  }
  return deviceDetailPowerBoxEntity;
}

Map<String, dynamic> $DeviceDetailPowerBoxEntityToJson(
    DeviceDetailPowerBoxEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension DeviceDetailPowerBoxEntityExtension on DeviceDetailPowerBoxEntity {
  DeviceDetailPowerBoxEntity copyWith({
    DeviceDetailPowerBoxData? data,
  }) {
    return DeviceDetailPowerBoxEntity()
      ..data = data ?? this.data;
  }
}

DeviceDetailPowerBoxData $DeviceDetailPowerBoxDataFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailPowerBoxData deviceDetailPowerBoxData = DeviceDetailPowerBoxData();
  final String? instanceName = jsonConvert.convert<String>(
      json['instance_name']);
  if (instanceName != null) {
    deviceDetailPowerBoxData.instanceName = instanceName;
  }
  final String? gateName = jsonConvert.convert<String>(json['gate_name']);
  if (gateName != null) {
    deviceDetailPowerBoxData.gateName = gateName;
  }
  final String? passName = jsonConvert.convert<String>(json['pass_name']);
  if (passName != null) {
    deviceDetailPowerBoxData.passName = passName;
  }
  final String? labelName = jsonConvert.convert<String>(json['label_name']);
  if (labelName != null) {
    deviceDetailPowerBoxData.labelName = labelName;
  }
  final String? deviceCode = jsonConvert.convert<String>(json['device_code']);
  if (deviceCode != null) {
    deviceDetailPowerBoxData.deviceCode = deviceCode;
  }
  final String? iotConnectStatus = jsonConvert.convert<String>(
      json['iot_connect_status']);
  if (iotConnectStatus != null) {
    deviceDetailPowerBoxData.iotConnectStatus = iotConnectStatus;
  }
  final int? batteryVoltage = jsonConvert.convert<int>(json['battery_voltage']);
  if (batteryVoltage != null) {
    deviceDetailPowerBoxData.batteryVoltage = batteryVoltage;
  }
  final int? batteryCapacity = jsonConvert.convert<int>(
      json['battery_capacity']);
  if (batteryCapacity != null) {
    deviceDetailPowerBoxData.batteryCapacity = batteryCapacity;
  }
  final String? powerStatus = jsonConvert.convert<String>(json['power_status']);
  if (powerStatus != null) {
    deviceDetailPowerBoxData.powerStatus = powerStatus;
  }
  final String? workTime = jsonConvert.convert<String>(json['work_time']);
  if (workTime != null) {
    deviceDetailPowerBoxData.workTime = workTime;
  }
  final int? inletTemperature = jsonConvert.convert<int>(
      json['inlet_temperature']);
  if (inletTemperature != null) {
    deviceDetailPowerBoxData.inletTemperature = inletTemperature;
  }
  final int? outletTemperature = jsonConvert.convert<int>(
      json['outlet_temperature']);
  if (outletTemperature != null) {
    deviceDetailPowerBoxData.outletTemperature = outletTemperature;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    deviceDetailPowerBoxData.version = version;
  }
  final List<
      DeviceDetailPowerBoxDataDcInterfaces>? dcInterfaces = (json['dc_interfaces'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceDetailPowerBoxDataDcInterfaces>(
          e) as DeviceDetailPowerBoxDataDcInterfaces).toList();
  if (dcInterfaces != null) {
    deviceDetailPowerBoxData.dcInterfaces = dcInterfaces;
  }
  final String? nodeId = jsonConvert.convert<String>(json['node_id']);
  if (nodeId != null) {
    deviceDetailPowerBoxData.nodeId = nodeId;
  }
  final String? instanceId = jsonConvert.convert<String>(json['instance_id']);
  if (instanceId != null) {
    deviceDetailPowerBoxData.instanceId = instanceId;
  }
  return deviceDetailPowerBoxData;
}

Map<String, dynamic> $DeviceDetailPowerBoxDataToJson(
    DeviceDetailPowerBoxData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['instance_name'] = entity.instanceName;
  data['gate_name'] = entity.gateName;
  data['pass_name'] = entity.passName;
  data['label_name'] = entity.labelName;
  data['device_code'] = entity.deviceCode;
  data['iot_connect_status'] = entity.iotConnectStatus;
  data['battery_voltage'] = entity.batteryVoltage;
  data['battery_capacity'] = entity.batteryCapacity;
  data['power_status'] = entity.powerStatus;
  data['work_time'] = entity.workTime;
  data['inlet_temperature'] = entity.inletTemperature;
  data['outlet_temperature'] = entity.outletTemperature;
  data['version'] = entity.version;
  data['dc_interfaces'] = entity.dcInterfaces?.map((v) => v.toJson()).toList();
  data['node_id'] = entity.nodeId;
  data['instance_id'] = entity.instanceId;
  return data;
}

extension DeviceDetailPowerBoxDataExtension on DeviceDetailPowerBoxData {
  DeviceDetailPowerBoxData copyWith({
    String? instanceName,
    String? gateName,
    String? passName,
    String? labelName,
    String? deviceCode,
    String? iotConnectStatus,
    int? batteryVoltage,
    int? batteryCapacity,
    String? powerStatus,
    String? workTime,
    int? inletTemperature,
    int? outletTemperature,
    String? version,
    List<DeviceDetailPowerBoxDataDcInterfaces>? dcInterfaces,
    String? nodeId,
    String? instanceId,
  }) {
    return DeviceDetailPowerBoxData()
      ..instanceName = instanceName ?? this.instanceName
      ..gateName = gateName ?? this.gateName
      ..passName = passName ?? this.passName
      ..labelName = labelName ?? this.labelName
      ..deviceCode = deviceCode ?? this.deviceCode
      ..iotConnectStatus = iotConnectStatus ?? this.iotConnectStatus
      ..batteryVoltage = batteryVoltage ?? this.batteryVoltage
      ..batteryCapacity = batteryCapacity ?? this.batteryCapacity
      ..powerStatus = powerStatus ?? this.powerStatus
      ..workTime = workTime ?? this.workTime
      ..inletTemperature = inletTemperature ?? this.inletTemperature
      ..outletTemperature = outletTemperature ?? this.outletTemperature
      ..version = version ?? this.version
      ..dcInterfaces = dcInterfaces ?? this.dcInterfaces
      ..nodeId = nodeId ?? this.nodeId
      ..instanceId = instanceId ?? this.instanceId;
  }
}

DeviceDetailPowerBoxDataDcInterfaces $DeviceDetailPowerBoxDataDcInterfacesFromJson(
    Map<String, dynamic> json) {
  final DeviceDetailPowerBoxDataDcInterfaces deviceDetailPowerBoxDataDcInterfaces = DeviceDetailPowerBoxDataDcInterfaces();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    deviceDetailPowerBoxDataDcInterfaces.id = id;
  }
  final int? interfaceNum = jsonConvert.convert<int>(json['interface_num']);
  if (interfaceNum != null) {
    deviceDetailPowerBoxDataDcInterfaces.interfaceNum = interfaceNum;
  }
  final String? statusText = jsonConvert.convert<String>(json['status_text']);
  if (statusText != null) {
    deviceDetailPowerBoxDataDcInterfaces.statusText = statusText;
  }
  final int? voltage = jsonConvert.convert<int>(json['voltage']);
  if (voltage != null) {
    deviceDetailPowerBoxDataDcInterfaces.voltage = voltage;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    deviceDetailPowerBoxDataDcInterfaces.current = current;
  }
  final String? connectDevice = jsonConvert.convert<String>(
      json['connect_device']);
  if (connectDevice != null) {
    deviceDetailPowerBoxDataDcInterfaces.connectDevice = connectDevice;
  }
  return deviceDetailPowerBoxDataDcInterfaces;
}

Map<String, dynamic> $DeviceDetailPowerBoxDataDcInterfacesToJson(
    DeviceDetailPowerBoxDataDcInterfaces entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['interface_num'] = entity.interfaceNum;
  data['status_text'] = entity.statusText;
  data['voltage'] = entity.voltage;
  data['current'] = entity.current;
  data['connect_device'] = entity.connectDevice;
  return data;
}

extension DeviceDetailPowerBoxDataDcInterfacesExtension on DeviceDetailPowerBoxDataDcInterfaces {
  DeviceDetailPowerBoxDataDcInterfaces copyWith({
    int? id,
    int? interfaceNum,
    String? statusText,
    int? voltage,
    int? current,
    String? connectDevice,
  }) {
    return DeviceDetailPowerBoxDataDcInterfaces()
      ..id = id ?? this.id
      ..interfaceNum = interfaceNum ?? this.interfaceNum
      ..statusText = statusText ?? this.statusText
      ..voltage = voltage ?? this.voltage
      ..current = current ?? this.current
      ..connectDevice = connectDevice ?? this.connectDevice;
  }
}