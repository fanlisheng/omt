import 'package:kayo_package/kayo_package.dart';
import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../http/http_query.dart';
import 'camera_operation_strategy.dart';

/// 摄像头替换策略
/// 用于处理摄像头替换场景，需要pNodeCode参数
/// 调用aiDeviceCameraInstall API进行摄像头替换
class ReplaceCameraStrategy implements CameraOperationStrategy {
  @override
  String get strategyName => 'ReplaceCameraStrategy';

  @override
  String get successMessage => '替换成功';

  @override
  String get failureMessagePrefix => '替换失败';

  @override
  bool get shouldSetReadOnlyAfterSuccess => true;

  @override
  ValidationResult validateParameters({
    required CameraDeviceEntity cameraDevice,
    String? pNodeCode,
    int? gateId,
    String? instanceId,
  }) {
    // 基础摄像头信息验证
    if (!_validateBasicCameraInfo(cameraDevice)) {
      return const ValidationResult.failure('"设备名称、摄像头类型、进出口、是否纳入监管"不能为空！');
    }

    // 替换操作需要pNodeCode
    if (pNodeCode == null || pNodeCode.isEmpty) {
      return const ValidationResult.failure('替换操作需要pNodeCode参数');
    }

    // 替换操作需要gateId和instanceId
    if (gateId == null || gateId <= 0) {
      return const ValidationResult.failure('gateId不能为空或无效');
    }

    if (instanceId == null || instanceId.isEmpty) {
      return const ValidationResult.failure('instanceId不能为空');
    }

    // AI设备验证
    if (cameraDevice.selectedAi == null) {
      return const ValidationResult.failure('请选择AI设备');
    }

    return const ValidationResult.success();
  }

  @override
  Future<void> executeOperation({
    required CameraDeviceEntity cameraDevice,
    String? pNodeCode,
    int? gateId,
    String? instanceId,
    required Map<String, dynamic> aiParams,
    required Map<String, dynamic> cameraParams,
    required Function(dynamic) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // 替换操作使用与添加相同的API，但可能需要额外的标识参数
      // 这里可以根据实际API需求添加替换标识
      await HttpQuery.share.installService.aiDeviceCameraInstall(
        pNodeCode: pNodeCode!,
        aiDevice: aiParams,
        camera: cameraParams,
        gateId: gateId!,
        instanceId: instanceId!,
        onSuccess: onSuccess,
        onError: onError,
      );
    } catch (e) {
      onError('$failureMessagePrefix: $e');
    }
  }

  /// 验证基础摄像头信息
  bool _validateBasicCameraInfo(CameraDeviceEntity cameraDevice) {
    return cameraDevice.deviceNameController.text.isNotEmpty &&
        (cameraDevice.selectedCameraType?.value ?? -1) != -1 &&
        (cameraDevice.selectedRegulation?.value ?? -1) != -1 &&
        (cameraDevice.selectedEntryExit?.id ?? -1) != -1;
  }
}