import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/page/home/photo_preview/widgets/photo_preview_screen.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailCameraViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  final Function(bool) onChange;
  bool isChange = false;

  DetailCameraViewModel(this.nodeId, {required this.onChange});

  int photoCurrentIndex = 0;

  List<DeviceEntity> aiDeviceList = [];
  String selectedAiIp = "";
  List<CameraDeviceEntity> deviceList = [CameraDeviceEntity()];

  //视频
  late final player = Player();
  late final controller = VideoController(player);

  DeviceDetailCameraData deviceInfo = DeviceDetailCameraData();

  @override
  void initState() async {
    super.initState();

    requestData();
  }

  void requestData() {
    HttpQuery.share.homePageService.deviceDetailCamera(
        nodeId: nodeId,
        onSuccess: (DeviceDetailCameraData? a) {
          deviceInfo = a ?? DeviceDetailCameraData();
          // player.open(Media('https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
          player.open(Media(deviceInfo.rtspUrl ?? ""));
          notifyListeners();
        });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  //完成
  completeEventAction() {
    notifyListeners();
  }

  //连接
  connectEventAction() {
    deviceList.first.rtsp = deviceList.first.rtspController.text;
    notifyListeners();
  }

  //重启识别
  restartRecognitionAction() {
    notifyListeners();
    HttpQuery.share.homePageService.manualSnapCamera(
        deviceCode: deviceInfo.deviceCode ?? "",
        aiDeviceCode: deviceInfo.aiDeviceCode ?? "",
        onSuccess: (a) {
          LoadingUtils.show(data: "重启识别成功!");
        });
  }

  //图片
  photoPreviewEventAction() {
    notifyListeners();
  }

  //编辑
  editEventAction() {
    IntentUtils.share
        .push(context!, routeName: RouterPage.EditCameraPage, data: {
      "data": deviceInfo,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        isChange = true;
        onChange(isChange);
        requestData();
      }
    });
  }

  gotoPhotoPreviewScreen() {
    IntentUtils.share
        .push(context!, routeName: RouterPage.PhotoPreviewScreen, data: {
      "data": PhotoPreviewScreenData(
          deviceCode: deviceInfo.deviceCode ?? "",
          nodeId: nodeId,
          dayBasicPhoto: deviceInfo.dayBasicPhoto,
          nightBasicPhoto: deviceInfo.nightBasicPhoto)
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        requestData();
      }
    });
  }
}
