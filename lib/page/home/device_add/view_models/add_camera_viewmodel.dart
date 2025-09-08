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
import 'package:omt/services/install_cache_service.dart';
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

  // 缓存服务
  final InstallCacheService _cacheService = InstallCacheService.instance;

  List<CameraDeviceEntity> cameraDeviceList = [CameraDeviceEntity()];

  @override
  void initState() {
    super.initState();

    if (aiDeviceList.length == 1) {
      cameraDeviceList.first.selectedAi = aiDeviceList.first;
    }

    // 然后加载基础数据
    _loadInitialData();

  }

  /// 加载初始数据
  void _loadInitialData() {
    int completedRequests = 0;
    const int totalRequests = 3;

    void checkAllRequestsCompleted() {
      completedRequests++;
      if (completedRequests == totalRequests) {
        // 所有请求完成后，智能恢复缓存选择项
        _smartRestoreCacheSelections();
        notifyListeners();
      }
    }

    // 初始化摄像头类型列表
    HttpQuery.share.installService.getCameraType(
      onSuccess: (List<IdNameValue>? data) {
        cameraTypeList = data ?? [];
        checkAllRequestsCompleted();
      },
    );

    // 初始化摄像头状态列表
    HttpQuery.share.installService.getCameraStatus(
      onSuccess: (List<IdNameValue>? data) {
        regulationList = data ?? [];
        checkAllRequestsCompleted();
      },
    );

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        if (inOutList.isNotEmpty) {
          inOutList.removeAt(0);
        }
        checkAllRequestsCompleted();
      },
    );
  }

  /// 智能恢复缓存选择项（公共方法）
  void smartRestoreCacheSelections() {
    _smartRestoreCacheSelections();
  }

  /// 智能恢复缓存选择项
  void _smartRestoreCacheSelections() {
    // 遍历所有摄像头设备，智能恢复每个设备的选择项
    for (var cameraDevice in cameraDeviceList) {
      // 智能恢复摄像头类型选择
      if (cameraDevice.selectedCameraType != null &&
          cameraTypeList.isNotEmpty) {
        IdNameValue? matchedType;
        bool typeExists = cameraTypeList.any((type) {
          if (type.value == cameraDevice.selectedCameraType?.value) {
            matchedType = type;
            return true;
          }
          return false;
        });
        if (typeExists && matchedType != null) {
          // 只有当对象引用不同时才重新赋值，避免不必要的UI更新
          if (cameraDevice.selectedCameraType != matchedType) {
            cameraDevice.selectedCameraType = matchedType;
          }
        } else {
          // 如果缓存的摄像头类型不在新列表中，清空选择
          cameraDevice.selectedCameraType = null;
        }
      }

      // 智能恢复进出口选择
      if (cameraDevice.selectedEntryExit != null && inOutList.isNotEmpty) {
        IdNameValue? matchedInOut;
        bool inOutExists = inOutList.any((inOut) {
          if (inOut.id == cameraDevice.selectedEntryExit?.id) {
            matchedInOut = inOut;
            return true;
          }
          return false;
        });
        if (inOutExists && matchedInOut != null) {
          // 只有当对象引用不同时才重新赋值，避免不必要的UI更新
          if (cameraDevice.selectedEntryExit != matchedInOut) {
            cameraDevice.selectedEntryExit = matchedInOut;
          }
        } else {
          // 如果缓存的进出口不在新列表中，清空选择
          cameraDevice.selectedEntryExit = null;
        }
      }

      // 智能恢复监管状态选择
      if (cameraDevice.selectedRegulation != null &&
          regulationList.isNotEmpty) {
        IdNameValue? matchedRegulation;
        bool regulationExists = regulationList.any((regulation) {
          if (regulation.value == cameraDevice.selectedRegulation?.value) {
            matchedRegulation = regulation;
            return true;
          }
          return false;
        });
        if (regulationExists && matchedRegulation != null) {
          // 只有当对象引用不同时才重新赋值，避免不必要的UI更新
          if (cameraDevice.selectedRegulation != matchedRegulation) {
            cameraDevice.selectedRegulation = matchedRegulation;
          }
        } else {
          // 如果缓存的监管状态不在新列表中，清空选择
          cameraDevice.selectedRegulation = null;
        }
      }
    }

    // 通知UI更新
    notifyListeners();
  }

  @override
  void dispose() {
    // 销毁所有控制器
    _disposeAllResources();
    try {
      super.dispose();
    } catch (e) {
      // 忽略父类dispose错误
    }
  }

  // 同步摄像头控制器与设备列表
  void syncControllersWithDeviceList() {
    for (int i = 0; i < cameraDeviceList.length; i++) {
      var camera = cameraDeviceList[i];
      // 确保控制器已初始化并填充数据
      if (camera.rtsp != null && camera.rtsp!.isNotEmpty) {
        camera.rtspController.text = camera.rtsp!;
      }
      if (camera.deviceNameController.text.isEmpty) {
        // 如果设备名称为空，可以设置默认名称或保持为空
      }
      if (camera.videoIdController.text.isEmpty) {
        // 如果视频ID为空，可以设置默认值或保持为空
      }
    }
    notifyListeners();
  }

  // 释放所有资源的方法
  void _disposeAllResources() {
    for (var camera in cameraDeviceList) {
      // 释放视频播放器
      try {
        if (camera.player.state.playing) {
          camera.player.pause();
        }
        camera.player.dispose();
      } catch (e) {
        // 忽略已经被释放的播放器
      }

      // 释放文本控制器
      try {
        camera.rtspController.dispose();
      } catch (e) {
        // 忽略已经被释放的控制器
      }
      try {
        camera.deviceNameController.dispose();
      } catch (e) {
        // 忽略已经被释放的控制器
      }
      try {
        camera.videoIdController.dispose();
      } catch (e) {
        // 忽略已经被释放的控制器
      }
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

    // 重置播放结果状态
    e.playResult = null;
    // 设置连接中状态
    e.connectionStatus = 1;
    notifyListeners();

    _saveCameraCache();

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
        e.connectionStatus = 2; // 连接成功
        cameraDeviceList[index] = e;
      } else {
        e.connectionStatus = 3; // 连接失败
        LoadingUtils.showError(data: "连接失败!");
      }
    } catch (e) {
      cameraDeviceList[index].connectionStatus = 3; // 连接失败
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

                  // 保存摄像头缓存数据
                  _saveCameraCache();
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
    HttpQuery.share.homePageService.restartAiDevicePython(
      // deviceCode: cameraDeviceEntity.code ?? "",
      // aiDeviceCode: cameraDeviceEntity.selectedAi?.deviceCode ?? "",
      ip: cameraDeviceEntity.ip ?? "",
      onSuccess: (a) {
        LoadingUtils.showToast(data: "重启识别成功!");
      },
    );
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
    // 保存摄像头缓存数据
    _saveCameraCache();
    notifyListeners();
  }

  // 编辑摄像头
  editCameraAction(CameraDeviceEntity e) {
    e.readOnly = false;
    e.isOpen = true;
    e.isAddEnd = false;
    // 保存摄像头缓存数据
    _saveCameraCache();
    notifyListeners();
  }

  // 注意：_getCameraTypeList 和 _getCameraStatusList 方法已移至 _loadInitialData 中内联实现

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

  // 更新播放结果状态的方法
  void updatePlayResult(int index, bool? playResult) {
    if (index >= 0 && index < cameraDeviceList.length) {
      // 只有当状态真正改变时才更新和通知
      if (cameraDeviceList[index].playResult != playResult) {
        cameraDeviceList[index].playResult = playResult;
        notifyListeners();
      }
    }
  }

  /// 保存摄像头缓存数据
  void _saveCameraCache() async {
    try {
      // 检查是否有缓存数据存在
      if (await _cacheService.hasCacheData()) {
        // 获取现有缓存数据
        final cacheData = await _cacheService.getCacheData();
        if (cacheData != null) {
          // 更新摄像头相关缓存数据
          cacheData.gateId = gateId;
          cacheData.instanceId = instanceId;
          cacheData.cameraInOutList = inOutList;
          cacheData.cameraTypeList = cameraTypeList;
          cacheData.regulationList = regulationList;
          cacheData.cameraDeviceList =
              InstallCacheService.cameraDeviceListToMapList(cameraDeviceList);

          // 保存更新后的缓存数据
          await _cacheService.saveCacheData(cacheData);
          print('摄像头缓存数据已更新保存');
        }
      }
    } catch (e) {
      print('保存摄像头缓存失败: $e');
    }
  }

  /// 从缓存恢复摄像头数据 -未用
  void restoreFromCache() async {
    try {
      if (await _cacheService.hasCacheData()) {
        final cacheData = await _cacheService.getCacheData();
        if (cacheData != null) {
          // 恢复基本信息
          if (cacheData.gateId != null) {
            gateId = cacheData.gateId!;
          }
          if (cacheData.instanceId != null &&
              cacheData.instanceId!.isNotEmpty) {
            instanceId = cacheData.instanceId!;
          }

          // 恢复列表数据
          if (cacheData.cameraInOutList != null &&
              cacheData.cameraInOutList!.isNotEmpty) {
            inOutList = cacheData.cameraInOutList!;
          }
          if (cacheData.cameraTypeList != null &&
              cacheData.cameraTypeList!.isNotEmpty) {
            cameraTypeList = cacheData.cameraTypeList!;
          }
          if (cacheData.regulationList != null &&
              cacheData.regulationList!.isNotEmpty) {
            regulationList = cacheData.regulationList!;
          }

          // 恢复摄像头设备列表
          if (cacheData.cameraDeviceList != null &&
              cacheData.cameraDeviceList!.isNotEmpty) {
            cameraDeviceList = InstallCacheService.cameraDeviceListFromMapList(
                cacheData.cameraDeviceList!);
          }

          print('摄像头缓存数据已恢复');
          notifyListeners();
        }
      }
    } catch (e) {
      print('恢复摄像头缓存失败: $e');
    }
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {
    // 摄像头设备的数据加载通过initState中的_loadInitialData完成
    // 这里可以触发成功回调
    if (onSuccess != null) {
      onSuccess(cameraDeviceList);
    }
  }
}
