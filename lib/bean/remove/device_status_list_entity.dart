import 'dart:convert';
import 'device_list_entity.dart';

class DeviceStatusListEntity {
  List<DeviceListData>? approvedFailedDevices = [];
  List<DeviceListData>? pendingApprovalDevices = [];
  List<DeviceListData>? remainingDevices = [];

  DeviceStatusListEntity();

  factory DeviceStatusListEntity.fromJson(Map<String, dynamic> json) {
    return DeviceStatusListEntity()
      ..approvedFailedDevices = (json['approved_failed_devices'] as List?)
          ?.map((e) => DeviceListData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..pendingApprovalDevices = (json['pending_approval_devices'] as List?)
          ?.map((e) => DeviceListData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..remainingDevices = (json['remaining_devices'] as List?)
          ?.map((e) => DeviceListData.fromJson(e as Map<String, dynamic>))
          .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'approved_failed_devices': approvedFailedDevices?.map((e) => e.toJson()).toList(),
      'pending_approval_devices': pendingApprovalDevices?.map((e) => e.toJson()).toList(),
      'remaining_devices': remainingDevices?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}