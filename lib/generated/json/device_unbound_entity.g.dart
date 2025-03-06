import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/home/home_page/device_unbound_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';


DeviceUnboundEntity $DeviceUnboundEntityFromJson(Map<String, dynamic> json) {
  final DeviceUnboundEntity deviceUnboundEntity = DeviceUnboundEntity();
  final List<DeviceUnboundAllCount>? allCount = (json['all_count'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DeviceUnboundAllCount>(e) as DeviceUnboundAllCount)
      .toList();
  if (allCount != null) {
    deviceUnboundEntity.allCount = allCount;
  }
  final List<
      DeviceUnboundAbnormalCount>? abnormalCount = (json['abnormal_count'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DeviceUnboundAbnormalCount>(
          e) as DeviceUnboundAbnormalCount).toList();
  if (abnormalCount != null) {
    deviceUnboundEntity.abnormalCount = abnormalCount;
  }
  final List<DeviceEntity>? unboundDevices = (json['unbound_devices'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<DeviceEntity>(e) as DeviceEntity).toList();
  if (unboundDevices != null) {
    deviceUnboundEntity.unboundDevices = unboundDevices;
  }
  return deviceUnboundEntity;
}

Map<String, dynamic> $DeviceUnboundEntityToJson(DeviceUnboundEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['all_count'] = entity.allCount?.map((v) => v.toJson()).toList();
  data['abnormal_count'] =
      entity.abnormalCount?.map((v) => v.toJson()).toList();
  data['unbound_devices'] =
      entity.unboundDevices?.map((v) => v.toJson()).toList();
  return data;
}

extension DeviceUnboundEntityExtension on DeviceUnboundEntity {
  DeviceUnboundEntity copyWith({
    List<DeviceUnboundAllCount>? allCount,
    List<DeviceUnboundAbnormalCount>? abnormalCount,
    List<DeviceEntity>? unboundDevices,
  }) {
    return DeviceUnboundEntity()
      ..allCount = allCount ?? this.allCount
      ..abnormalCount = abnormalCount ?? this.abnormalCount
      ..unboundDevices = unboundDevices ?? this.unboundDevices;
  }
}

DeviceUnboundAllCount $DeviceUnboundAllCountFromJson(
    Map<String, dynamic> json) {
  final DeviceUnboundAllCount deviceUnboundAllCount = DeviceUnboundAllCount();
  final int? deviceType = jsonConvert.convert<int>(json['device_type']);
  if (deviceType != null) {
    deviceUnboundAllCount.deviceType = deviceType;
  }
  final String? deviceTypeText = jsonConvert.convert<String>(
      json['device_type_text']);
  if (deviceTypeText != null) {
    deviceUnboundAllCount.deviceTypeText = deviceTypeText;
  }
  final int? count = jsonConvert.convert<int>(json['count']);
  if (count != null) {
    deviceUnboundAllCount.count = count;
  }
  return deviceUnboundAllCount;
}

Map<String, dynamic> $DeviceUnboundAllCountToJson(
    DeviceUnboundAllCount entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['device_type'] = entity.deviceType;
  data['device_type_text'] = entity.deviceTypeText;
  data['count'] = entity.count;
  return data;
}

extension DeviceUnboundAllCountExtension on DeviceUnboundAllCount {
  DeviceUnboundAllCount copyWith({
    int? deviceType,
    String? deviceTypeText,
    int? count,
  }) {
    return DeviceUnboundAllCount()
      ..deviceType = deviceType ?? this.deviceType
      ..deviceTypeText = deviceTypeText ?? this.deviceTypeText
      ..count = count ?? this.count;
  }
}

DeviceUnboundAbnormalCount $DeviceUnboundAbnormalCountFromJson(
    Map<String, dynamic> json) {
  final DeviceUnboundAbnormalCount deviceUnboundAbnormalCount = DeviceUnboundAbnormalCount();
  final int? deviceType = jsonConvert.convert<int>(json['device_type']);
  if (deviceType != null) {
    deviceUnboundAbnormalCount.deviceType = deviceType;
  }
  final String? deviceTypeText = jsonConvert.convert<String>(
      json['device_type_text']);
  if (deviceTypeText != null) {
    deviceUnboundAbnormalCount.deviceTypeText = deviceTypeText;
  }
  final int? count = jsonConvert.convert<int>(json['count']);
  if (count != null) {
    deviceUnboundAbnormalCount.count = count;
  }
  return deviceUnboundAbnormalCount;
}

Map<String, dynamic> $DeviceUnboundAbnormalCountToJson(
    DeviceUnboundAbnormalCount entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['device_type'] = entity.deviceType;
  data['device_type_text'] = entity.deviceTypeText;
  data['count'] = entity.count;
  return data;
}

extension DeviceUnboundAbnormalCountExtension on DeviceUnboundAbnormalCount {
  DeviceUnboundAbnormalCount copyWith({
    int? deviceType,
    String? deviceTypeText,
    int? count,
  }) {
    return DeviceUnboundAbnormalCount()
      ..deviceType = deviceType ?? this.deviceType
      ..deviceTypeText = deviceTypeText ?? this.deviceTypeText
      ..count = count ?? this.count;
  }
}