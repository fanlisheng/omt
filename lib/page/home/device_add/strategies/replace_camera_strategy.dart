import 'package:flutter/material.dart';

import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../bean/video/video_configuration/Video_Connect_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/shared_utils.dart';
import 'camera_operation_strategy.dart';

/// 摄像头替换策略
/// 用于处理摄像头替换场景，需要pNodeCode参数
/// 调用webcamReplace API进行摄像头替换
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
  String get displayName => '替换';

  @override
  String get completeButtonText => '替换完成';

  @override
  String get continueActionText => '+继续替换';

  @override
  String get confirmDialogTitle => '请确认摄像头替换信息是否有误，摄像头信息将更新至服务端';

  @override
  String get confirmButtonText => '确认替换';

  @override
  void onOperationSuccess(BuildContext context, CameraDeviceEntity cameraDeviceEntity, {void Function()? onSaveCache}) {
    cameraDeviceEntity.readOnly = true;
    cameraDeviceEntity.isAddEnd = true;
    Navigator.pop(context);
  }

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
      // 直接调用替换API
      HttpQuery.share.homePageService.replaceCamera(
        ip: "192.168.101.82",
        oldUdid: pNodeCode ?? "",
        newUdid: cameraDevice.code ?? "",
        rtsp: cameraDevice.rtsp ?? "",
        onSuccess: onSuccess,
        onError: onError,
      );
    } catch (e) {
      onError('$failureMessagePrefix: $e');
    }
  }

  /// 验证基础摄像头信息
  bool _validateBasicCameraInfo(CameraDeviceEntity cameraDevice) {
    return cameraDevice.deviceNameController.text.isNotEmpty;
  }
}