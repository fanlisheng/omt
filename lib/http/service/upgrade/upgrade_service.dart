import 'package:flutter/cupertino.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/http/service/fileService/fileService.dart';

///
/// 升级服务类
/// 处理AI设备的升级相关功能
///
class UpgradeService {
  final FileService _fileService = FileService();
  
  // 升级接口路径常量
  static const String _upgradeMainPath = '/upgrade/local/main';
  static const String _upgradeAiPath = '/upgrade/local/ai';
  
  /// 检查在线升级状态
  /// 获取设备可用的升级信息
  /// 返回参数json: status
  /// status=1 可以在线升级，status=2 不可以在线升级
  checkOnlineUpgradeStatus({
    required String deviceIp,
    ValueChanged<Map<String, dynamic>?>? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    try {
      String url = '${API.share.hostDeviceConfiguration(deviceIp)}/upgrade/online/status';
      HttpManager.share.doHttpPost<Map<String, dynamic>>(
        url,
        {},
        method: 'POST',
        autoHideDialog: false,
        autoShowDialog: false,
        onSuccess: onSuccess,
        onError: onError,
      );
    } catch (e) {
      onError?.call('检查在线升级状态失败: ${e.toString()}');
    }
  }
  
  /// 检查工控机连通性
  /// 参考video_configuration_service.dart中的connect方法
  checkControllerConnectivity({
    required String host,
    ValueChanged<bool>? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      'http://$host:8000/central_control/get',
      {},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: false,
      onSuccess: (data) {
        onSuccess?.call(true);
      },
      onError: (error) {
        onSuccess?.call(false);
      },
    );
  }
  
  /// 上传升级文件
  uploadUpgradeFile({
    required String deviceIp,
    required String filePath,
    required String upgradeType, // 'program' 或 'identity'
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<String>? onError,
    ValueChanged<double>? onProgress,
  }) async {
    // 根据upgradeType选择对应的API路径
    String apiPath;
    switch (upgradeType) {
      case 'program':
        apiPath = _upgradeMainPath;
        break;
      case 'identity':
        apiPath = _upgradeAiPath;
        break;
      default:
        onError?.call('不支持的升级类型: $upgradeType');
        return;
    }
    
    await _fileService.uploadUpgradeFile(
      deviceIp,
      filePath,
      apiPath,
      onProgress: onProgress,
      onSuccess: () => onSuccess?.call(null),
      onError: onError,
    );
  }

}