import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/bean/home/home_page/local_device_entity.dart';
import 'device_add_viewmodel.dart';

class AddCameraViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool isInstall; //是安装 默认否
  AddCameraViewModel(this.deviceType, this.stepNumber, this.isInstall);

  List<LocalDeviceEntity> aiDeviceList = [];
  String selectedAiIp = "";
  List<CameraDeviceEntity> deviceList = [CameraDeviceEntity()];

  //视频
  late final player = Player();
  late final controller = VideoController(player);
  // 创建一个 TextEditingController 列表来动态管理每个 TextField 的内容
  List<TextEditingController> controllers = [TextEditingController()];

  List<String> cameraTypeList = ["共用进出口", "进出口1", "进出口2"];
  List<String> entryExitList = ["共用进出口", "进出口1", "进出口2"];
  List<String> regulationList = ["是", "否"];

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {

    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }


  //完成
  completeEventAction() {
    deviceList.first.readOnly = true;
    if(isInstall){
      deviceList.add(CameraDeviceEntity());
    }
    notifyListeners();
  }

  //连接
  connectEventAction(){
    deviceList.first.rtsp = deviceList.first.rtspController.text;
    notifyListeners();
  }

  //重启识别
  restartRecognitionEventAction(){
    notifyListeners();
  }

  //图片
  photoPreviewEventAction(){
    notifyListeners();
  }

 // 删除
  deleteEventAction(int index){
    notifyListeners();
  }

  //编辑
  editEventAction(int index){
    notifyListeners();
  }
}
