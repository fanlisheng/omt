import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../bean/common/code_data.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../utils/image_utils.dart';

class EditCameraViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceDetailCameraData deviceInfo;

  EditCameraViewModel( this.deviceInfo);

  // ===== 摄像头相关属性 =====
  List<IdNameValue> inOutList = [];
  List<IdNameValue> cameraTypeList = [];
  List<IdNameValue> regulationList = [];
  CameraDeviceEntity cameraDevice = CameraDeviceEntity();

  // late final player = Player();
  // late var videoController = VideoController(player);
  // List<CameraDeviceEntity> cameraDeviceList = [];
  // List<TextEditingController> deviceDetailNvr = [];

  // DeviceDetailAiData? selectedAi;

  @override
  void initState() {
    super.initState();
    // 初始化摄像头列表和控制器
    cameraDevice.code = deviceInfo.deviceCode;
    // cameraDevice.ip = deviceInfo.ip;
    // cameraDevice.mac = deviceInfo.mac;
    cameraDevice.rtsp = deviceInfo.rtspUrl;
    cameraDevice.rtspController =
        TextEditingController(text: deviceInfo.rtspUrl);
    cameraDevice.deviceNameController =
        TextEditingController(text: deviceInfo.name);
    cameraDevice.videoIdController =
        TextEditingController(text: deviceInfo.cameraCode);
    cameraDevice.isOpen = true;

    // cameraDeviceList = [cameraDevice];
    // deviceDetailNvr = [TextEditingController()];

    // 初始化摄像头类型列表
    _getCameraStatusList();
    _getCameraTypeList();

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        // 设置选中的进出口
        for (var entry in inOutList) {
          if (entry.name == deviceInfo.passName) {
            cameraDevice.selectedEntryExit = entry;
            break;
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    // 销毁所有控制器
    cameraDevice.rtspController.dispose();
    cameraDevice.deviceNameController.dispose();
    cameraDevice.videoIdController.dispose();

    super.dispose();
  }

  saveCameraEdit() {
    if ((cameraDevice.deviceNameController.text.isEmpty) ||
        ((cameraDevice.selectedCameraType?.value ?? -1) == -1) ||
        ((cameraDevice.selectedRegulation?.value ?? -1) == -1) ||
        ((cameraDevice.selectedEntryExit?.id ?? -1) == -1)) {
      LoadingUtils.showToast(data: '"设备名称、摄像头类型、进出口、是否纳入监管"不能为空！');
      return;
    }
    HttpQuery.share.homePageService.editCamera(
        nodeId: deviceInfo.nodeId.toInt(),
        name: cameraDevice.deviceNameController.text,
        cameraType: (cameraDevice.selectedCameraType?.value ?? "0").toInt(),
        passId: cameraDevice.selectedEntryExit?.id ?? 0,
        controlStatus: (cameraDevice.selectedRegulation?.value ?? "0").toInt(),
        onSuccess: (CodeMessageData? value) {
          LoadingUtils.show(data: "修改成功!");
          IntentUtils.share.popResultOk(context!);
        });
  }

  // 获取摄像头类型列表
  void _getCameraTypeList() {
    HttpQuery.share.installService.getCameraType(
      onSuccess: (List<IdNameValue>? data) {
        cameraTypeList = data ?? [];
        // 设置选中的摄像头类型
        for (var entry in cameraTypeList) {
          if (entry.name == deviceInfo.cameraTypeText) {
            cameraDevice.selectedCameraType = entry;
            break;
          }
        }
        notifyListeners();
      },
    );
  }

  // 获取摄像头状态列表
  void _getCameraStatusList() {
    HttpQuery.share.installService.getCameraStatus(
      onSuccess: (List<IdNameValue>? data) {
        regulationList = data ?? [];
        // 设置选中的监管状态
        for (var entry in regulationList) {
          if (entry.name == deviceInfo.controlStatusText) {
            cameraDevice.selectedRegulation = entry;
            break;
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}
