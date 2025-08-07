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
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../bean/video/video_configuration/Video_Connect_entity.dart';
import '../../../../router_utils.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/shared_utils.dart';
import '../../photo_preview/widgets/photo_preview_screen.dart';
import '../../search_device/services/device_search_service.dart';

class AddCameraViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;

  List<DeviceDetailAiData> aiDeviceList;
  int gateId = 0;
  String instanceId = "";

  AddCameraViewModel(this.pNodeCode, this.aiDeviceList);

  // ===== 摄像头相关属性 =====

  List<IdNameValue> inOutList = [];
  List<IdNameValue> cameraTypeList = [];
  List<IdNameValue> regulationList = [];

  List<CameraDeviceEntity> cameraDeviceList = [CameraDeviceEntity()];

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
        inOutList.removeAt(0);
        notifyListeners();
      },
    );
    if (aiDeviceList.length == 1) {
      cameraDeviceList.first.selectedAi = aiDeviceList.first;
    }
  }

  @override
  void dispose() {
    // 销毁所有控制器
    _disposeAllResources();
    super.dispose();
  }

  // 释放所有资源的方法
  void _disposeAllResources() {
    for (var camera in cameraDeviceList) {
      // 释放视频播放器
      if (camera.player.state.playing) {
        camera.player.pause();
      }
      camera.player.dispose();

      // 释放文本控制器
      camera.rtspController.dispose();
      camera.deviceNameController.dispose();
      camera.videoIdController.dispose();
    }
  }

  // 连接摄像头
  connectCameraAction(int index) async {
    LoadingUtils.show(data: "连接中...");
    CameraDeviceEntity e = cameraDeviceList[index];
    if (e.rtspController.text.isEmpty) {
      LoadingUtils.dismiss();
      LoadingUtils.showInfo(data: "RTSP地址不能为空!");
      return;
    }
    e.rtsp = e.rtspController.text;
    e.player.open(Media(e.rtsp!));
    e.videoController = VideoController(e.player);
    e.ip = DeviceUtils.getIpFromRtsp(e.rtsp!);
    try {
      DeviceEntity? deviceEntity =
          await hikvisionDeviceInfo(ipAddress: e.ip ?? "");
      if (deviceEntity != null) {
        e.code = deviceEntity.deviceCode ?? "";
        e.mac = deviceEntity.mac;
        e.isOpen = true;
        cameraDeviceList[index] = e;
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
  bool checkCameraInfo(CameraDeviceEntity cameraDeviceEntity) {
    if ((cameraDeviceEntity.deviceNameController.text.isEmpty) ||
        ((cameraDeviceEntity.selectedCameraType?.value ?? -1) == -1) ||
        ((cameraDeviceEntity.selectedRegulation?.value ?? -1) == -1) ||
        ((cameraDeviceEntity.selectedEntryExit?.id ?? -1) == -1)) {
      LoadingUtils.showToast(data: '"设备名称、摄像头类型、进出口、是否纳入监管"不能为空！');
      return false;
    }
    return true;
  }

  Future<void> completeCameraAction(
      BuildContext context, CameraDeviceEntity cameraDeviceEntity) async {
    CameraDeviceEntity cameraDevice = cameraDeviceEntity;
    // if (checkCameraInfo(cameraDevice) == false) {
    //   return;
    // }
    // if ((cameraDevice.deviceNameController.text.isEmpty) ||
    //     ((cameraDevice.selectedCameraType?.value ?? -1) == -1) ||
    //     ((cameraDevice.selectedRegulation?.value ?? -1) == -1) ||
    //     ((cameraDevice.selectedEntryExit?.id ?? -1) == -1)) {
    //   LoadingUtils.showToast(data: '"设备名称、摄像头类型、进出口、是否纳入监管"不能为空！');
    //   return;
    // }

    var webcam = VideoInfoCamEntity()
      ..name = cameraDeviceEntity.deviceNameController.text
      ..value = cameraDeviceEntity.code ?? ""
      ..rtsp = cameraDeviceEntity.rtsp
      ..in_out = cameraDeviceEntity.selectedEntryExit?.id ?? -1;

    await SharedUtils.setControlIP(cameraDevice.selectedAi?.ip ?? "");

    //修改本地ai设备信息
    HttpQuery.share.homePageService.configAi(
        data: webcam,
        onSuccess: (data) {
          //调用添加
          Map<String, dynamic> aiParams = {
            "ip": cameraDevice.selectedAi?.ip ?? "",
            "mac": cameraDevice.selectedAi?.mac ?? "",
          };
          Map<String, dynamic> cameraParams = {
            "device_code": cameraDeviceEntity.code ?? "",
            "name": cameraDeviceEntity.deviceNameController.text ?? "",
            "ip": cameraDeviceEntity.ip ?? "",
            "mac": cameraDeviceEntity.mac,
            "rtsp_url": cameraDeviceEntity.rtsp,
            "pass_id": cameraDeviceEntity.selectedEntryExit?.id ?? -1,
            "camera_type":
                cameraDeviceEntity.selectedCameraType?.value.toInt() ?? 0,
            "control_status":
                cameraDeviceEntity.selectedRegulation?.value.toInt() ?? 0,
          };
          if (cameraDeviceEntity.videoIdController.text.isNotEmpty) {
            cameraParams["camera_code"] =
                cameraDeviceEntity.videoIdController.text;
          }

          //如果是添加
          if (pNodeCode.isNotEmpty) {
            HttpQuery.share.installService.aiDeviceCameraInstall(
                pNodeCode: pNodeCode,
                aiDevice: aiParams,
                camera: cameraParams,
                onSuccess: (data) {
                  cameraDeviceEntity.readOnly = true;
                  cameraDeviceEntity.isAddEnd = true;
                  Navigator.pop(context);
                  notifyListeners();
                },
                onError: (error) {
                  //如果安装失败需要删除Ai上的配置
                  HttpQuery.share.homePageService.removeConfigAi(
                      deviceCode: cameraDeviceEntity.code,
                      onSuccess: (data) {});
                  LoadingUtils.showToast(data: '添加失败: $error');
                });
          } else {
            HttpQuery.share.installService.installStep1(
                aiDevice: aiParams,
                camera: cameraParams,
                gateId: gateId,
                instanceId: instanceId,
                onSuccess: (data) {
                  cameraDeviceEntity.readOnly = true;
                  cameraDeviceEntity.isAddEnd = true;
                  Navigator.pop(context);
                  notifyListeners();
                },
                onError: (error) {
                  //如果安装失败需要删除Ai上的配置
                  HttpQuery.share.homePageService.removeConfigAi(
                      deviceCode: cameraDeviceEntity.code,
                      onSuccess: (data) {});
                  LoadingUtils.showToast(data: '安装失败: $error');
                });
          }
        },
        onError: (e) {
          LoadingUtils.showError(data: "配置本地AI设备信息失败");
        });
  }

  // 重启识别
  restartRecognitionAction(CameraDeviceEntity cameraDeviceEntity) {
    notifyListeners();
    HttpQuery.share.homePageService.manualSnapCamera(
        deviceCode: cameraDeviceEntity.code ?? "",
        aiDeviceCode: cameraDeviceEntity.selectedAi?.deviceCode ?? "",
        onSuccess: (a) {
          LoadingUtils.showToast(data: "重启识别成功!");
        });
  }

  // 图片预览
  photoPreviewAction(CameraDeviceEntity cameraDeviceEntity) {
    IntentUtils.share
        .push(context!, routeName: RouterPage.PhotoPreviewScreen, data: {
      "data": PhotoPreviewScreenData(
          deviceCode: cameraDeviceEntity.code ?? "",
          dayBasicPhoto: null,
          nightBasicPhoto: null)
    })?.then((value) {});
    // HttpQuery.share.homePageService.cameraPhotoList(
    //   page: 1,
    //   deviceCode: cameraDeviceEntity.code ?? "",
    //   type: 1,
    //   snapAts: [],
    //   onSuccess: (DeviceDetailCameraSnapList? data) {
    //     if (data != null) {
    //       ImageUtils.share.showBigImg(
    //         context!,
    //         url: ImageUtils.share.getImageUrl(
    //           url: data.data?.last.url ?? "",
    //         ),
    //       );
    //     }
    //   },
    //   onError: (error) {
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   const SnackBar(content: Text('已经是这天的最后一张了')),
    //     // );
    //   },
    // );
  }

  // 删除摄像头
  deleteCameraAction(int index) {
    notifyListeners();
  }

  // 编辑摄像头
  editCameraAction(CameraDeviceEntity e) {
    e.readOnly = false;
    e.isOpen = true;
    e.isAddEnd = false;
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

  //添加完成
  void addComplete() {
    // for (var device in cameraDeviceList) {
    //   if (device.isAddEnd == true) {
    //     IntentUtils.share.popResultOk(context!);
    //     return;
    //   }
    // }
    bool allAddEnd =
        cameraDeviceList.every((device) => device.isAddEnd == true);
    if (allAddEnd) {
      IntentUtils.share.popResultOk(context!);
      return;
    } else {
      LoadingUtils.showToast(data: "请先提交所有设备的数据");
    }
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
