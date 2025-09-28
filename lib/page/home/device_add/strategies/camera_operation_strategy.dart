import 'package:flutter/material.dart';
import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../utils/result.dart';
import '../../../../http/http_query.dart';

/// 相机操作策略接口
/// 定义了相机操作的通用行为，包括参数验证、API调用和结果处理
abstract class CameraOperationStrategy {
  /// 策略名称，用于日志和调试
  String get strategyName;
  
  /// 成功消息
  String get successMessage;
  
  /// 失败消息前缀
  String get failureMessagePrefix;
  
  /// 操作完成后是否设置只读状态
  bool get shouldSetReadOnlyAfterSuccess;
  
  /// 操作类型的显示名称
  String get displayName;
  
  /// 完成按钮的文本
  String get completeButtonText;
  
  /// 继续操作的文本
  String get continueActionText;
  
  /// 确认对话框的标题
  String get confirmDialogTitle;
  
  /// 确认按钮的文本
  String get confirmButtonText;
  
  /// 验证操作所需的参数
  /// 返回验证结果，如果验证失败会包含错误信息
  ValidationResult validateParameters({
    required CameraDeviceEntity cameraDevice,
    String? pNodeCode,
    int? gateId,
    String? instanceId,
  });
  
  /// 执行API调用
  /// 返回操作结果
  Future<void> executeOperation({
    required CameraDeviceEntity cameraDevice,
    String? pNodeCode,
    int? gateId,
    String? instanceId,
    required Map<String, dynamic> aiParams,
    required Map<String, dynamic> cameraParams,
    required Function(dynamic) onSuccess,
    required Function(String) onError,
  });
  
  /// 操作成功后的处理
  /// 由各个具体策略实现，处理特定于该策略的成功后逻辑
  void onOperationSuccess(BuildContext context, CameraDeviceEntity cameraDeviceEntity, {void Function()? onSaveCache});
}

/// 参数验证结果
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  const ValidationResult.success() : isValid = true, errorMessage = null;
  const ValidationResult.failure(this.errorMessage) : isValid = false;
}