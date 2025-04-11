import 'package:flutter/foundation.dart';
import 'package:kayo_package/mvvm/base/base_view_model.dart';
import 'package:omt/utils/device_utils.dart';

import '../../../../bean/home/home_page/device_entity.dart'; // 假设 DeviceUtils 已定义

class AiSearchViewModel extends BaseViewModel {
  bool _isAiSearching = false;
  List<DeviceEntity> _aiSearchResults = [];
  String? _selectedAiIp;

  bool get isAiSearching => _isAiSearching;

  List<DeviceEntity> get aiSearchResults => _aiSearchResults;

  String? get selectedAiIp => _selectedAiIp;

  @override
  void initState() async {
    super.initState();
    startAiSearch();
  }

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
  }

  // 停止搜索
  void stopAiSearch() {
    _isAiSearching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopAiSearch(); // 确保搜索停止
    super.dispose();
  }
}
