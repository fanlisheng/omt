import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package_utils.dart';
import '../../bean/update/update_info.dart';
import '../../http/service/update/update_service.dart';
import '../../utils/context_utils.dart';
import 'update_dialog.dart';

class UpdateManager {
  static final UpdateManager _instance = UpdateManager._internal();
  factory UpdateManager() => _instance;
  UpdateManager._internal();

  final UpdateService _updateService = UpdateService();
  bool _hasCheckedUpdate = false;

  // 在应用启动时检查更新
  Future<void> checkUpdateOnStartup(BuildContext context) async {
    if (_hasCheckedUpdate) return;
    
    try {
      // 延迟检查，避免影响应用启动速度
      await Future.delayed(const Duration(seconds: 2));
      
      final updateInfo = await _updateService.checkForUpdate();
      // if (updateInfo != null && context.mounted) {
      if (updateInfo != null && context.mounted) {
        _showUpdateDialog(context, updateInfo);
      }
      
      _hasCheckedUpdate = true;
    } catch (e) {
      print('启动时检查更新失败: $e');
    }
  }

  // 手动检查更新
  Future<void> checkUpdateManually(BuildContext context) async {
    try {
      // 显示加载指示器
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final updateInfo = await _updateService.checkForUpdate();
      
      // 关闭加载指示器
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (updateInfo != null && context.mounted) {
        _showUpdateDialog(context, updateInfo);
      } else if (context.mounted) {
        // 显示无更新提示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('当前已是最新版本'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 关闭加载指示器
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // 显示错误提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('检查更新失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 显示更新弹窗（公共方法）
  void showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
    _showUpdateDialog(context, updateInfo);
  }

  // 显示更新弹窗
  void _showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
    var context1 = ContextUtils.instance.getGlobalContextOrThrow();
    showDialog(
      context: context1,
      barrierDismissible: !updateInfo.forceUpdate,
      builder: (context) => UpdateDialog(
        updateInfo: updateInfo,
        onCancel: () {
          // 保存更新信息到本地，下次启动时提醒
          _updateService.saveUpdateInfo(updateInfo);
        },
      ),
    );
  }

  // 检查是否有本地保存的更新信息
  Future<void> checkLocalUpdateInfo(BuildContext context) async {
    try {
      final localUpdateInfo = await _updateService.getLocalUpdateInfo();
      if (localUpdateInfo != null && context.mounted) {
        // 显示本地保存的更新提醒
        _showLocalUpdateReminder(context, localUpdateInfo);
      }
    } catch (e) {
      print('检查本地更新信息失败: $e');
    }
  }

  // 显示本地更新提醒
  void _showLocalUpdateReminder(BuildContext context, UpdateInfo updateInfo) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('更新提醒'),
        content: Text('检测到之前有可用更新（${updateInfo.version}），是否现在安装？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('稍后'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showUpdateDialog(context, updateInfo);
            },
            child: const Text('立即更新'),
          ),
        ],
      ),
    );
  }

  // 重置更新检查状态（用于测试）
  void resetUpdateCheck() {
    _hasCheckedUpdate = false;
  }
}