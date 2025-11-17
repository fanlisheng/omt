import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omt/bean/install/install_cache_data.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/shared_utils.dart';

/// 安装设备缓存服务
class InstallCacheService {
  static const String _baseCacheKey = 'install_device_cache';
  static InstallCacheService? _instance;
  
  // 标志位：是否应该从首页恢复缓存
  bool _shouldRestoreFromHome = false;
  
  InstallCacheService._internal();
  
  static InstallCacheService get instance {
    _instance ??= InstallCacheService._internal();
    return _instance!;
  }
  
  /// 设置是否应该从首页恢复缓存
  void setShouldRestoreFromHome(bool should) {
    _shouldRestoreFromHome = should;
  }
  
  /// 获取是否应该从首页恢复缓存
  bool getShouldRestoreFromHome() {
    return _shouldRestoreFromHome;
  }
  
  /// 清除恢复标志
  void clearRestoreFlag() {
    _shouldRestoreFromHome = false;
  }
  
  /// 获取用户特定的缓存key
  Future<String> _getUserCacheKey() async {
    try {
      final userInfo = await SharedUtils.getUserInfo();
      if (userInfo?.phone != null && userInfo!.phone!.isNotEmpty) {
        return '${_baseCacheKey}_${userInfo.phone}';
      }
      // 如果没有用户信息，使用默认key
      return _baseCacheKey;
    } catch (e) {
      print('获取用户缓存key失败: $e');
      return _baseCacheKey;
    }
  }
  
  /// 保存缓存数据
  Future<bool> saveCacheData(InstallCacheData cacheData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = await _getUserCacheKey();
      final jsonString = jsonEncode(cacheData.toJson());
      return await prefs.setString(cacheKey, jsonString);
    } catch (e) {
      print('保存安装缓存数据失败: $e');
      return false;
    }
  }
  
  /// 读取缓存数据
  Future<InstallCacheData?> getCacheData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = await _getUserCacheKey();
      final jsonString = prefs.getString(cacheKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return InstallCacheData.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      print('读取安装缓存数据失败: $e');
      return null;
    }
  }
  
  /// 检查是否有缓存数据
  Future<bool> hasCacheData() async {
    try {
      final cacheData = await getCacheData();
      return cacheData != null && cacheData.hasValidData();
    } catch (e) {
      print('检查安装缓存数据失败: $e');
      return false;
    }
  }
  
  /// 清除缓存数据
  Future<bool> clearCacheData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = await _getUserCacheKey();
      return await prefs.remove(cacheKey);
    } catch (e) {
      print('清除安装缓存数据失败: $e');
      return false;
    }
  }
  
  /// 将CameraDeviceEntity转换为Map用于缓存
  static Map<String, dynamic> cameraDeviceToMap(CameraDeviceEntity camera) {
    return {
      'isOpen': camera.isOpen,
      'rtsp': camera.rtsp,
      'code': camera.code,
      'mac': camera.mac,
      'ip': camera.ip,
      'connectionStatus': camera.connectionStatus,
      'isPlaying': camera.isPlaying,
      'playResult': camera.playResult,
      'readOnly': camera.readOnly,
      'isAddEnd': camera.isAddEnd,
      'selectedAi': camera.selectedAi?.toJson(),
      'rtspControllerText': camera.rtspController.text,
      'deviceNameControllerText': camera.deviceNameController.text,
      'videoIdControllerText': camera.videoIdController.text,
      'selectedEntryExit': camera.selectedEntryExit?.toJson(),
      'selectedCameraType': camera.selectedCameraType?.toJson(),
      'selectedRegulation': camera.selectedRegulation?.toJson(),
    };
  }
  
  /// 将Map转换为CameraDeviceEntity
  static CameraDeviceEntity cameraDeviceFromMap(Map<String, dynamic> map) {
    final camera = CameraDeviceEntity(
      isOpen: map['isOpen'],
      rtsp: map['rtsp'],
      code: map['code'],
    );
    
    camera.mac = map['mac'];
    camera.ip = map['ip'];
    camera.connectionStatus = map['connectionStatus'] ?? 0;
    camera.isPlaying = map['isPlaying'] ?? false;
    camera.playResult = map['playResult'];
    camera.readOnly = map['readOnly'] ?? false;
    camera.isAddEnd = map['isAddEnd'] ?? false;
    
    if (map['selectedAi'] != null) {
      camera.selectedAi = DeviceDetailAiData.fromJson(map['selectedAi']);
    }
    
    camera.rtspController.text = map['rtspControllerText'] ?? '';
    camera.deviceNameController.text = map['deviceNameControllerText'] ?? '';
    camera.videoIdController.text = map['videoIdControllerText'] ?? '';
    
    if (map['selectedEntryExit'] != null) {
      camera.selectedEntryExit = IdNameValue.fromJson(map['selectedEntryExit']);
    }
    if (map['selectedCameraType'] != null) {
      camera.selectedCameraType = IdNameValue.fromJson(map['selectedCameraType']);
    }
    if (map['selectedRegulation'] != null) {
      camera.selectedRegulation = IdNameValue.fromJson(map['selectedRegulation']);
    }
    
    return camera;
  }
  
  /// 将CameraDeviceEntity列表转换为Map列表
  static List<Map<String, dynamic>> cameraDeviceListToMapList(List<CameraDeviceEntity> cameras) {
    return cameras.map((camera) => cameraDeviceToMap(camera)).toList();
  }
  
  /// 将Map列表转换为CameraDeviceEntity列表
  static List<CameraDeviceEntity> cameraDeviceListFromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => cameraDeviceFromMap(map)).toList();
  }
}