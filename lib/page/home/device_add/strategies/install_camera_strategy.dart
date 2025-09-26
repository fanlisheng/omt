import 'package:kayo_package/kayo_package.dart';
import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../http/http_query.dart';
import 'camera_operation_strategy.dart';

/// 设备安装策略
/// 用于处理设备绑定场景，即pNodeCode不为空的情况
/// 调用installStep1 API进行设备安装
class InstallCameraStrategy implements CameraOperationStrategy {
  @override
  String get strategyName => 'InstallCameraStrategy';

  @override
  String get successMessage => '安装成功';

  @override
  String get failureMessagePrefix => '安装失败';

  @override
  bool get shouldSetReadOnlyAfterSuccess => true;

  @override
  String get displayName => '安装';

  @override
  String get completeButtonText => '安装完成';

  @override
  String get continueActionText => '+继续安装';

  @override
  String get confirmDialogTitle => '请确认摄像头安装信息是否有误，摄像头信息将更新至服务端';

  @override
  String get confirmButtonText => '确认安装';

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

    // 安装操作需要gateId和instanceId
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
      await HttpQuery.share.installService.installStep1(
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