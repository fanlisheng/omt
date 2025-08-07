import 'dart:async';

/// 全局重置管理器，用于管理不同页面的重置操作
class ResetManager {
  // 单例模式
  static final ResetManager _instance = ResetManager._internal();
  
  factory ResetManager() {
    return _instance;
  }
  
  ResetManager._internal();
  
  // 存储各种重置流
  final Map<String, StreamController<bool>> _resetControllers = {};
  
  // 获取重置流
  Stream<bool> getResetStream(String key) {
    if (!_resetControllers.containsKey(key)) {
      _resetControllers[key] = StreamController<bool>.broadcast();
    }
    return _resetControllers[key]!.stream;
  }
  
  // 触发重置
  void triggerReset(String key) {
    if (_resetControllers.containsKey(key)) {
      _resetControllers[key]!.add(true);
    }
  }
  
  // 关闭特定的流
  void closeStream(String key) {
    if (_resetControllers.containsKey(key)) {
      _resetControllers[key]!.close();
      _resetControllers.remove(key);
    }
  }
  
  // 关闭所有流
  void dispose() {
    for (var controller in _resetControllers.values) {
      controller.close();
    }
    _resetControllers.clear();
  }
}

// 方便全局访问的实例
final resetManager = ResetManager(); 