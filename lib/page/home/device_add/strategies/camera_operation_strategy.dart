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
}

/// 参数验证结果
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  const ValidationResult.success() : isValid = true, errorMessage = null;
  const ValidationResult.failure(this.errorMessage) : isValid = false;
}