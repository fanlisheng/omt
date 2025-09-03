import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';

/// 安装设备缓存数据模型
/// 使用具体设备数据缓存方式
class InstallCacheData {
  // 基本信息
  int currentStep;
  StrIdNameValue? selectedInstance;
  IdNameValue? selectedDoor;
  IdNameValue? selectedInOut;
  List<StrIdNameValue> selectedTags;
  
  // AI设备数据
  List<DeviceDetailAiData> aiDeviceList;
  
  // 摄像头设备数据
  List<Map<String, dynamic>> cameraDeviceList;
  
  // NVR设备数据
  Map<String, dynamic>? nvrData;
  
  // 电源箱设备数据
  Map<String, dynamic>? powerBoxData;
  
  // 电源及其他设备数据
  Map<String, dynamic>? powerData;
  
  // 缓存创建时间
  DateTime createdAt;
  
  InstallCacheData({
    this.currentStep = 1,
    this.selectedInstance,
    this.selectedDoor,
    this.selectedInOut,
    this.selectedTags = const [],
    this.aiDeviceList = const [],
    this.cameraDeviceList = const [],
    this.nvrData,
    this.powerBoxData,
    this.powerData,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  /// 从JSON创建实例
  factory InstallCacheData.fromJson(Map<String, dynamic> json) {
    return InstallCacheData(
      currentStep: json['currentStep'] ?? 1,
      selectedInstance: json['selectedInstance'] != null 
          ? StrIdNameValue.fromJson(json['selectedInstance']) 
          : null,
      selectedDoor: json['selectedDoor'] != null 
          ? IdNameValue.fromJson(json['selectedDoor']) 
          : null,
      selectedInOut: json['selectedInOut'] != null 
          ? IdNameValue.fromJson(json['selectedInOut']) 
          : null,
      selectedTags: (json['selectedTags'] as List<dynamic>? ?? [])
          .map((e) => StrIdNameValue.fromJson(e))
          .toList(),
      aiDeviceList: (json['aiDeviceList'] as List<dynamic>? ?? [])
          .map((e) => DeviceDetailAiData.fromJson(e))
          .toList(),
      cameraDeviceList: (json['cameraDeviceList'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
      nvrData: json['nvrData'],
      powerBoxData: json['powerBoxData'],
      powerData: json['powerData'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'selectedInstance': selectedInstance?.toJson(),
      'selectedDoor': selectedDoor?.toJson(),
      'selectedInOut': selectedInOut?.toJson(),
      'selectedTags': selectedTags.map((e) => e.toJson()).toList(),
      'aiDeviceList': aiDeviceList.map((e) => e.toJson()).toList(),
      'cameraDeviceList': cameraDeviceList,
      'nvrData': nvrData,
      'powerBoxData': powerBoxData,
      'powerData': powerData,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// 检查是否有有效数据
  bool hasValidData() {
    return currentStep > 1 || 
           selectedInstance != null || 
           selectedDoor != null ||
           selectedTags.isNotEmpty ||
           aiDeviceList.isNotEmpty ||
           cameraDeviceList.isNotEmpty ||
           nvrData != null ||
           powerBoxData != null ||
           powerData != null;
  }
  
  /// 清空所有数据
  void clear() {
    currentStep = 1;
    selectedInstance = null;
    selectedDoor = null;
    selectedInOut = null;
    selectedTags.clear();
    aiDeviceList.clear();
    cameraDeviceList.clear();
    nvrData = null;
    powerBoxData = null;
    powerData = null;
    createdAt = DateTime.now();
  }
}