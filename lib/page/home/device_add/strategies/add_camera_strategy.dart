import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../bean/video/video_configuration/Video_Connect_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/shared_utils.dart';
import 'camera_operation_strategy.dart';

/// 设备添加策略
/// 用于处理直接添加场景，即pNodeCode为空的情况
/// 调用aiDeviceCameraInstall API进行设备添加
class AddCameraStrategy implements CameraOperationStrategy {
  @override
  String get strategyName => 'AddCameraStrategy';

  @override
  String get successMessage => '添加成功';

  @override
  String get failureMessagePrefix => '添加失败';

  @override
  bool get shouldSetReadOnlyAfterSuccess => true;

  @override
  String get displayName => '添加';

  @override
  String get completeButtonText => '添加完成';

  @override
  String get continueActionText => '+继续添加';

  @override
  String get confirmDialogTitle => '请确认摄像头添加信息是否有误，摄像头信息将更新至服务端';

  @override
  String get confirmButtonText => '确认添加';

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

    // 添加操作需要pNodeCode
    if (pNodeCode == null || pNodeCode.isEmpty) {
      return const ValidationResult.failure('pNodeCode不能为空');
    }

    // 添加操作需要gateId和instanceId
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
      // 第一步：创建本地AI设备配置信息
      var webcam = VideoInfoCamEntity()
        ..name = cameraDevice.deviceNameController.text
        ..value = cameraDevice.code ?? ""
        ..rtsp = cameraDevice.rtsp
        ..in_out = cameraDevice.selectedEntryExit?.id ?? -1;

      // 第二步：设置控制IP
      await SharedUtils.setControlIP(cameraDevice.selectedAi?.ip ?? "");

      // 第三步：配置本地AI设备信息
      HttpQuery.share.homePageService.configAi(
        data: webcam,
        onSuccess: (data) {
          // 第四步：配置成功后，调用添加API（aiDeviceCameraInstall）
          HttpQuery.share.installService.aiDeviceCameraInstall(
            pNodeCode: pNodeCode!,
            aiDevice: aiParams,
            camera: cameraParams,
            onSuccess: onSuccess,
            onError: (error) {
              // 如果添加失败需要删除AI上的配置
              HttpQuery.share.homePageService.removeConfigAi(
                deviceCode: cameraDevice.code,
                onSuccess: (data) {},
              );
              onError('$failureMessagePrefix: $error');
            },
          );
        },
        onError: (error) {
          onError('配置本地AI设备信息失败: $error');
        },
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