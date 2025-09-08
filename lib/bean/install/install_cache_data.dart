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
  
  // AI设备相关缓存数据
  int? gateId;
  String? instanceId;
  
  // 摄像头相关缓存数据
  List<IdNameValue>? cameraInOutList;
  List<IdNameValue>? cameraTypeList;
  List<IdNameValue>? regulationList;
  
  // NVR相关缓存数据
  bool? isNvrNeeded;
  IdNameValue? selectedNarInOut;
  List<IdNameValue>? nvrInOutList;
  Map<String, dynamic>? selectedNvr;
  Map<String, dynamic>? nvrDeviceData;
  
  // 电源箱相关缓存数据
  bool? isPowerBoxNeeded;
  IdNameValue? selectedPowerBoxInOut;
  List<IdNameValue>? powerBoxInOutList;
  Map<String, dynamic>? selectedDeviceDetailPowerBox;
  List<Map<String, dynamic>>? powerBoxList;
  
  // 电源相关缓存数据
  String? portType;
  bool? batteryMains;
  bool? battery;
  bool? isCapacity80;
  IdNameValue? selectedPowerInOut;
  List<IdNameValue>? powerInOutList;
  IdNameValue? selectedRouterType;
  List<IdNameValue>? routerTypeList;
  String? routerIp;
  String? mac;
  List<Map<String, dynamic>>? exchangeDevices;
  IdNameValue? selectedExchangeInOut;
  
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
    this.gateId,
    this.instanceId,
    this.cameraInOutList,
    this.cameraTypeList,
    this.regulationList,
    this.isNvrNeeded,
    this.selectedNarInOut,
    this.nvrInOutList,
    this.selectedNvr,
    this.nvrDeviceData,
    this.isPowerBoxNeeded,
    this.selectedPowerBoxInOut,
    this.powerBoxInOutList,
    this.selectedDeviceDetailPowerBox,
    this.powerBoxList,
    this.portType,
    this.batteryMains,
    this.battery,
    this.isCapacity80,
    this.selectedPowerInOut,
    this.powerInOutList,
    this.selectedRouterType,
    this.routerTypeList,
    this.routerIp,
    this.mac,
    this.exchangeDevices,
    this.selectedExchangeInOut,
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
      gateId: json['gateId'],
      instanceId: json['instanceId'],
      cameraInOutList: (json['cameraInOutList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      cameraTypeList: (json['cameraTypeList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      regulationList: (json['regulationList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      isNvrNeeded: json['isNvrNeeded'],
      selectedNarInOut: json['selectedNarInOut'] != null 
          ? IdNameValue.fromJson(json['selectedNarInOut']) 
          : null,
      nvrInOutList: (json['nvrInOutList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      selectedNvr: json['selectedNvr'],
      nvrDeviceData: json['nvrDeviceData'],
      isPowerBoxNeeded: json['isPowerBoxNeeded'],
      selectedPowerBoxInOut: json['selectedPowerBoxInOut'] != null 
          ? IdNameValue.fromJson(json['selectedPowerBoxInOut']) 
          : null,
      powerBoxInOutList: (json['powerBoxInOutList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      selectedDeviceDetailPowerBox: json['selectedDeviceDetailPowerBox'],
      powerBoxList: (json['powerBoxList'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
      portType: json['portType'],
      batteryMains: json['batteryMains'],
      battery: json['battery'],
      isCapacity80: json['isCapacity80'],
      selectedPowerInOut: json['selectedPowerInOut'] != null 
          ? IdNameValue.fromJson(json['selectedPowerInOut']) 
          : null,
      powerInOutList: (json['powerInOutList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      selectedRouterType: json['selectedRouterType'] != null 
          ? IdNameValue.fromJson(json['selectedRouterType']) 
          : null,
      routerTypeList: (json['routerTypeList'] as List<dynamic>? ?? [])
          .map((e) => IdNameValue.fromJson(e))
          .toList(),
      routerIp: json['routerIp'],
      mac: json['mac'],
      exchangeDevices: (json['exchangeDevices'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
      selectedExchangeInOut: json['selectedExchangeInOut'] != null 
          ? IdNameValue.fromJson(json['selectedExchangeInOut']) 
          : null,
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
      'gateId': gateId,
      'instanceId': instanceId,
      'cameraInOutList': cameraInOutList?.map((e) => e.toJson()).toList(),
      'cameraTypeList': cameraTypeList?.map((e) => e.toJson()).toList(),
      'regulationList': regulationList?.map((e) => e.toJson()).toList(),
      'isNvrNeeded': isNvrNeeded,
      'selectedNarInOut': selectedNarInOut?.toJson(),
      'nvrInOutList': nvrInOutList?.map((e) => e.toJson()).toList(),
      'selectedNvr': selectedNvr,
      'nvrDeviceData': nvrDeviceData,
      'isPowerBoxNeeded': isPowerBoxNeeded,
      'selectedPowerBoxInOut': selectedPowerBoxInOut?.toJson(),
      'powerBoxInOutList': powerBoxInOutList?.map((e) => e.toJson()).toList(),
      'selectedDeviceDetailPowerBox': selectedDeviceDetailPowerBox,
      'powerBoxList': powerBoxList,
      'portType': portType,
      'batteryMains': batteryMains,
      'battery': battery,
      'isCapacity80': isCapacity80,
      'selectedPowerInOut': selectedPowerInOut?.toJson(),
      'powerInOutList': powerInOutList?.map((e) => e.toJson()).toList(),
      'selectedRouterType': selectedRouterType?.toJson(),
      'routerTypeList': routerTypeList?.map((e) => e.toJson()).toList(),
      'routerIp': routerIp,
      'mac': mac,
      'exchangeDevices': exchangeDevices,
      'selectedExchangeInOut': selectedExchangeInOut?.toJson(),
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