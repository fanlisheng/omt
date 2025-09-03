import 'package:flutter/foundation.dart';
import 'package:kayo_package/mvvm/base/base_view_model.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:omt/utils/device_utils.dart';

import '../../../../bean/home/home_page/device_entity.dart'; // 假设 DeviceUtils 已定义

class AiSearchViewModel extends BaseViewModel {
  bool _isAiSearching = false;
  List<DeviceEntity> _aiSearchResults = [];
  String? _selectedAiIp;
  Function()? _onSearchCompleted;

  bool get isAiSearching => _isAiSearching;

  List<DeviceEntity> get aiSearchResults => _aiSearchResults;

  String? get selectedAiIp => _selectedAiIp;
  
  set onSearchCompleted(Function()? callback) {
    _onSearchCompleted = callback;
  }

  @override
  void initState() async {
    super.initState();
    // 延迟搜索以避免弹窗显示时卡顿
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_disposed) {
        startAiSearch();
      }
    });
  }

  bool _disposed = false;

  set selectedAiIp(String? value) {
    _selectedAiIp = value;
    notifyListeners();
  }

  // 开始搜索 AI 设备
  Future<void> startAiSearch() async {
    _isAiSearching = true;
    _aiSearchResults = [];
    _selectedAiIp = null;
    notifyListeners();

    try {
      final devices = await DeviceUtils.scanAndFetchDevicesInfo(
        shouldStop: () => !_isAiSearching,
        deviceType: "AI设备",
      );
      _aiSearchResults = devices;
    } catch (e) {
      print("搜索 AI 设备失败: $e");
    }
    _isAiSearching = false;
    notifyListeners();
    
    // 搜索完成回调
    if (_onSearchCompleted != null) {
      _onSearchCompleted!();
    }
  }

  // 停止搜索
  void stopAiSearch() {
    _isAiSearching = false;
    try {
      LoadingUtils.dismiss();
    } catch (e) {
      if (kDebugMode) {
        print('取消加载动画失败: $e');
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stopAiSearch(); // 确保搜索停止
    try {
      super.dispose();
    } catch (e) {
      // 忽略父类dispose错误
    }
  }
}
