import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:omt/http/service/upgrade/upgrade_service.dart';
import 'package:omt/page/home/device_detail/widgets/upgrade_dialog.dart';
import 'package:kayo_package/utils/loading_utils.dart';

/// 升级ViewModel
class UpgradeViewModel extends ChangeNotifier {
  final UpgradeService _upgradeService = UpgradeService();
  
  String? _deviceCode;
  String? _deviceIp;
  bool _isUpgrading = false;
  Timer? _statusCheckTimer;
  
  bool get isUpgrading => _isUpgrading;
  
  void setDeviceInfo(String deviceCode, String deviceIp) {
    _deviceCode = deviceCode;
    _deviceIp = deviceIp;
  }
  
  /// 开始下载流程
  void startDownload(BuildContext context, String upgradeType) {
    _showUpgradeSuccessDialog(context, upgradeType);
    // _showUpgradeFailureDialog(context, upgradeType, "测试一下");
    // _startWaitingUpgrade(context, upgradeType);
    // if (_deviceCode == null || _deviceIp == null) {
    //   LoadingUtils.showToast(data: '设备信息不完整');
    //   return;
    // }
    
    // 直接进入本地上传升级流程
    // _showFileUploadDialog(context, upgradeType);
  }
  
  /// 开始升级流程
  void startUpgrade(BuildContext context, String upgradeType) {
    if (_deviceCode == null || _deviceIp == null) {
      LoadingUtils.showToast(data: '设备信息不完整');
      return;
    }
    
    // 检查工控机连通性
    _checkControllerConnectivity(context, upgradeType);
  }
  
  /// 检查工控机连通性
  void _checkControllerConnectivity(BuildContext context, String upgradeType) {
    _upgradeService.checkControllerConnectivity(
      host: _deviceIp!,
      onSuccess: (isConnected) {
        if (isConnected) {
          // 连通，显示升级方式选择弹窗
          _showUpgradeMethodDialog(context, upgradeType);
        } else {
          // 不连通，默认本地上传升级
          _showFileUploadDialog(context, upgradeType);
        }
      },
      onError: (error) {
        // 连接失败，默认本地上传升级
        _showFileUploadDialog(context, upgradeType);
      },
    );
  }
  
  /// 显示升级方式选择弹窗
  void _showUpgradeMethodDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    
    showDialog(
      context: context,
      builder: (context) => UpgradeMethodDialog(
        title: title,
        onLocalUpgrade: () => _showFileUploadDialog(context, upgradeType),
        onOnlineUpgrade: () => _startOnlineUpgrade(context, upgradeType),
      ),
    );
  }
  
  /// 显示文件上传弹窗
  void _showFileUploadDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    String? selectedFilePath;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FileUploadDialog(
        title: title,
        onFileSelected: (filePath) {
          selectedFilePath = filePath;
        },
        onConfirm: () {
          if (selectedFilePath != null) {
            _startLocalUpgrade(context, upgradeType, selectedFilePath!);
          }
        },
      ),
    );
  }
  
  /// 开始本地上传升级
  void _startLocalUpgrade(BuildContext context, String upgradeType, String filePath) {
    _isUpgrading = true;
    notifyListeners();
    
    _upgradeService.uploadUpgradeFile(
      deviceIp: _deviceIp!,
      filePath: filePath,
      upgradeType: upgradeType,
      onSuccess: (data) {
        // 上传成功，开始等待升级
        _startWaitingUpgrade(context, upgradeType);
      },
      onError: (error) {
        _isUpgrading = false;
        notifyListeners();
        Navigator.of(context).pop(); // 关闭上传弹窗
        _showUpgradeFailureDialog(context, upgradeType, error);
      },
      onProgress: (progress) {
        // 更新上传进度
      },
    );
  }
  
  /// 开始在线升级
  void _startOnlineUpgrade(BuildContext context, String upgradeType) {
    _isUpgrading = true;
    notifyListeners();
    
    // TODO: 实现在线升级逻辑
    LoadingUtils.showToast(data: '在线升级功能开发中...');

    _isUpgrading = false;
    notifyListeners();
  }
  
  /// 开始等待升级
  void _startWaitingUpgrade(BuildContext context, String upgradeType) {
    _isUpgrading = true;
    notifyListeners();
    
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    
    // 显示正在升级的对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpgradeProgressDialog(
        title: title,
      ),
    );
    
    // 设置15秒总超时（确保比ping超时时间长）
    Timer(const Duration(seconds: 13), () {
      if (_isUpgrading && context.mounted) {
        _statusCheckTimer?.cancel();
        _onUpgradeFailure(context, upgradeType, '升级总超时，请检查设备状态');
      }
    });
    
    // 1秒后开始ping设备
    Future.delayed(const Duration(seconds: 1), () {
      _startPingDevice(context, upgradeType);
    });
  }
  
  /// 开始ping设备
  void _startPingDevice(BuildContext context, String upgradeType) {
    Timer? pingTimer;
    int pingCount = 0;
    const maxPingAttempts = 5; // 最多ping 6次（12秒）
    
    pingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      pingCount++;
      
      if (pingCount > maxPingAttempts) {
        timer.cancel();
        // ping超时时不立即调用失败，让总超时Timer处理
        // 这样可以确保进度对话框能被正确关闭
        return;
      }
      
      bool isReachable = await _upgradeService.pingDevice(_deviceIp!);
      
      if (isReachable) {
        timer.cancel();
        // ping通后，开始检查升级状态
        _startCheckUpgradeStatus(context, upgradeType);
      }
    });
  }
  
  /// 开始检查升级状态
  void _startCheckUpgradeStatus(BuildContext context, String upgradeType) {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _upgradeService.checkUpgradeStatus(
        deviceIp: _deviceIp!,
        upgradeType: upgradeType,
        onSuccess: (data) {
          if (data != null) {
            String status = data['status'] ?? '';
            if (status == 'success') {
              // 升级成功
              timer.cancel();
              _onUpgradeSuccess(context, upgradeType);
            } else if (status == 'failed') {
              // 升级失败
              timer.cancel();
              String reason = data['reason'] ?? '未知错误';
              _onUpgradeFailure(context, upgradeType, reason);
            }
            // 其他状态继续等待
          }
        },
        onError: (error) {
          // 检查状态失败，继续重试
        },
      );
    });
  }
  
  /// 升级成功
  void _onUpgradeSuccess(BuildContext context, String upgradeType) {
    _isUpgrading = false;
    notifyListeners();
    
    Navigator.of(context).pop(); // 关闭等待弹窗
    _showUpgradeSuccessDialog(context, upgradeType);
  }
  
  /// 显示升级成功弹窗
  void _showUpgradeSuccessDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    
    showDialog(
      context: context,
      builder: (context) => UpgradeResultDialog(
        title: title,
        isSuccess: true,
        onConfirm: () {
          // 升级成功后的处理逻辑
        },
      ),
    );
  }
  
  /// 升级失败
  void _onUpgradeFailure(BuildContext context, String upgradeType, String reason) {
    _isUpgrading = false;
    notifyListeners();
    
    Navigator.of(context).pop(); // 关闭等待弹窗
    _showUpgradeFailureDialog(context, upgradeType, reason);
  }
  
  /// 显示升级失败弹窗
  void _showUpgradeFailureDialog(BuildContext context, String upgradeType, String reason) {
    String title = upgradeType == 'program' ? '主程版本升级失败' : '识别版本升级失败';
    
    showDialog(
      context: context,
      builder: (context) => UpgradeResultDialog(
        title: title,
        isSuccess: false,
        errorDetails: reason,
        onRetry: () {
          Navigator.of(context).pop();
          startUpgrade(context, upgradeType);
        },
        onConfirm: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}