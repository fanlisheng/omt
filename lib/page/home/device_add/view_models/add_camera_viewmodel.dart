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
import 'package:omt/utils/sys_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../utils/image_utils.dart';
import '../../search_device/services/device_search_service.dart';

class AddCameraViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;

  final List<DeviceDetailAiData> aiDeviceList;

  AddCameraViewModel(this.pNodeCode, this.aiDeviceList);

  // ===== 摄像头相关属性 =====

  List<IdNameValue> inOutList = [];
  late final player = Player();
  late var videoController = VideoController(player);
  List<CameraDeviceEntity> cameraDeviceList = [CameraDeviceEntity()];
  List<TextEditingController> deviceDetailNvr = [TextEditingController()];
  List<IdNameValue> cameraTypeList = [];
  List<IdNameValue> regulationList = [];
  DeviceDetailAiData? selectedAi;

  @override
  void initState() {
    super.initState();
    // 初始化摄像头类型列表
    _getCameraStatusList();
    _getCameraTypeList();
    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    // 销毁所有控制器
    player.dispose();
    super.dispose();
  }

  // 连接摄像头
  connectCameraAction(int index) async {
    LoadingUtils.show(data: "连接中...");
    CameraDeviceEntity e = cameraDeviceList[index];
    if (e.rtspController.text.isEmpty) return;
    e.rtsp = e.rtspController.text;
    player.open(Media(e.rtsp!));
    videoController = VideoController(player);
    e.ip = DeviceUtils.getIpFromRtsp(e.rtsp!);
    try {
      DeviceEntity? deviceEntity =
      await hikvisionDeviceInfo(ipAddress: e.ip ?? "");
      if (deviceEntity != null) {
        e.code = deviceEntity.deviceCode ?? "";
        e.mac = deviceEntity.mac;
        e.isOpen = true;
      } else {
        LoadingUtils.showError(data: "连接失败!");
      }
    } catch (e) {
      LoadingUtils.showError(data: "连接失败, 请检查rtsp!");
    }

    LoadingUtils.dismiss();
    notifyListeners();
  }

  // 完成摄像头设置
  void completeCameraAction(BuildContext context,
      CameraDeviceEntity cameraDeviceEntity) {
    CameraDeviceEntity cameraDevice = cameraDeviceList.first;
    if ((cameraDevice.deviceNameController.text.isEmpty) ||
        ((cameraDevice.selectedCameraType?.value ?? -1) == -1) ||
        ((cameraDevice.selectedRegulation?.value ?? -1) == -1) ||
        ((cameraDevice.selectedEntryExit?.id ?? -1) == -1)) {
      LoadingUtils.showToast(
          data: '"设备名称、摄像头类型、进出口、是否纳入监管"不能为空！');
      return;
    }
    Map<String, dynamic> aiParams = {
      "ip": selectedAi?.ip ?? "",
      "mac": selectedAi?.mac ?? "",
    };
    Map<String, dynamic> cameraParams = {
      "device_code": cameraDeviceEntity.code ?? "",
      "name": cameraDeviceEntity.deviceNameController.text ?? "",
      "ip": cameraDeviceEntity.ip ?? "",
      "mac": cameraDeviceEntity.mac,
      "rtsp_url": cameraDeviceEntity.rtsp,
      "pass_id": cameraDeviceEntity.selectedEntryExit?.id ?? -1,
      "camera_type": cameraDeviceEntity.selectedCameraType?.value.toInt() ?? 0,
      "control_status": cameraDeviceEntity.selectedRegulation?.value.toInt() ??
          0,
    };
    if (cameraDeviceEntity.videoIdController.text.isNotEmpty) {
      cameraParams["camera_code"] = cameraDeviceEntity.videoIdController.text;
    }

    HttpQuery.share.installService.aiDeviceCameraInstall(
        pNodeCode: pNodeCode,
        aiDevice: aiParams,
        camera: cameraParams,
        onSuccess: (data) {
          cameraDeviceEntity.readOnly = true;
          Navigator.pop(context);
          notifyListeners();
        },
        onError: (error) {
          LoadingUtils.showToast(data: '安装失败: $error');
        });
  }

  // 重启识别
  restartRecognitionAction(CameraDeviceEntity cameraDeviceEntity) {
    notifyListeners();
    HttpQuery.share.homePageService.manualSnapCamera(
        deviceCode: cameraDeviceEntity.code??"",
        aiDeviceCode: selectedAi?.deviceCode ?? "",
        onSuccess: (a) {
          LoadingUtils.show(data: "重启识别成功!");
        });
  }

  // 图片预览
  photoPreviewAction(CameraDeviceEntity cameraDeviceEntity) {
    HttpQuery.share.homePageService.cameraPhotoList(
      page: 1,
      deviceCode: cameraDeviceEntity.code ?? "",
      type: 1,
      snapAts: [],
      onSuccess: (DeviceDetailCameraSnapList? data) {
        if (data != null) {
          ImageUtils.share.showBigImg(
            context!,
            url: ImageUtils.share.getImageUrl(
              url: data.data?.last.url ?? "",
            ),
          );
        }
      },
      onError: (error) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('已经是这天的最后一张了')),
        // );
      },
    );
  }

  // 删除摄像头
  deleteCameraAction(int index) {
    notifyListeners();
  }

  // 编辑摄像头
  editCameraAction(int index) {
    notifyListeners();
  }

  // 获取摄像头类型列表
  void _getCameraTypeList() {
    HttpQuery.share.installService.getCameraType(
      onSuccess: (List<IdNameValue>? data) {
        cameraTypeList = data ?? [];
        notifyListeners();
      },
    );
  }

  // 获取摄像头状态列表
  void _getCameraStatusList() {
    HttpQuery.share.installService.getCameraStatus(
      onSuccess: (List<IdNameValue>? data) {
        regulationList = data ?? [];
        notifyListeners();
      },
    );
  }

  @override
  loadData({ValueChanged? onSuccess,
    ValueChanged? onCache,
    ValueChanged<String>? onError}) {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}
