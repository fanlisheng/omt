import 'reset_manager.dart';

/// 页面重置工具类
class ResetUtils {
  /// 重置安装页面
  static void resetInstallDeviceScreen() {
    // 触发安装页面的重置
    resetManager.triggerReset('install_device_reset');
  }
} 