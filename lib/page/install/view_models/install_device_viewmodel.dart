import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/page/home/device_add/view_models/add_ai_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_camera_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_nvr_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_power_box_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_power_viewmodel.dart';
import 'package:omt/page/install/view_models/preview_viewmodel.dart';
import 'package:omt/utils/reset_utils.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../bean/home/home_page/camera_device_entity.dart';
import '../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../home/device_add/view_models/add_ai_viewmodel.dart';
import '../../home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import '../../home/device_add/view_models/add_camera_viewmodel.dart';
import '../../home/device_add/view_models/add_nvr_viewmodel.dart';
import '../../home/device_add/view_models/add_power_box_viewmodel.dart';
import '../../home/device_add/view_models/add_power_viewmodel.dart';
import '../../home/search_device/services/device_search_service.dart';
import '../view_models/preview_viewmodel.dart';

class InstallDeviceViewModel extends BaseViewModelRefresh<dynamic> {
  Key contentKey = UniqueKey();
  int currentStep = 1;
  PageController pageController = PageController(initialPage: 0);

  final DeviceSearchService _searchService = DeviceSearchService();

  List<String> stepTitles = [];
  List<StrIdNameValue> instanceList = [];
  StrIdNameValue? selectedInstance;
  List<IdNameValue> doorList = [];
  IdNameValue? selectedDoor;
  List<IdNameValue> inOutList = [];
  IdNameValue? selectedInOut;

  List<StrIdNameValue> availableTags = [];
  List<StrIdNameValue> selectedTags = [];

  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool isClear = false;
  final asgbKey = GlobalKey<AutoSuggestBoxState>();

  // 创建 ViewModels，立即初始化以确保状态持久
  AddAiViewModel _aiViewModel = AddAiViewModel("");
  AddCameraViewModel _cameraViewModel = AddCameraViewModel("", []);
  AddNvrViewModel _nvrViewModel = AddNvrViewModel("");
  AddPowerBoxViewModel _powerBoxViewModel =
      AddPowerBoxViewModel("", isInstall: true);
  AddPowerViewModel _powerViewModel = AddPowerViewModel("", isInstall: true);

  // 添加 PreviewViewModel 实例
  PreviewViewModel _previewViewModel = PreviewViewModel();

  // 使用 getter 直接返回已初始化的ViewModel
  AddAiViewModel get aiViewModel => _aiViewModel;

  AddCameraViewModel get cameraViewModel => _cameraViewModel;

  AddNvrViewModel get nvrViewModel => _nvrViewModel;

  AddPowerBoxViewModel get powerBoxViewModel => _powerBoxViewModel;

  AddPowerViewModel get powerViewModel => _powerViewModel;

  // 添加 PreviewViewModel 的 getter
  PreviewViewModel get previewViewModel => _previewViewModel;

  @override
  void initState() async {
    super.initState();

    _loadInitialData();

    stepTitles = [
      "绑定实例",
      "添加AI设备",
      "添加摄像头",
      "添加NVR（选填）",
      "添加电源箱（选填）",
      "添加电源及其它"
    ];
  }

  @override
  void dispose() {
    // 在父ViewModel销毁时同时清理所有子ViewModel
    _aiViewModel.dispose();
    _cameraViewModel.dispose();
    _nvrViewModel.dispose();
    _powerBoxViewModel.dispose();
    _powerViewModel.dispose();
    _previewViewModel.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    /// 网络请求
  }

  // 上一步
  void backStepEventAction() {
    if (currentStep <= 1) return;
    currentStep = currentStep - 1;
    pageController.jumpToPage(currentStep - 1);
    notifyListeners();
  }

  // 下一步
  void nextStepEventAction() {
    if (currentStep < 7) {
      bool canProceed = _checkCondition();
      // bool canProceed = true;
      if (canProceed) {
        currentStep = currentStep + 1;
        pageController.jumpToPage(currentStep - 1);

        // 如果是最后一步，构建预览数据
        if (currentStep == 7) {
          _buildPreviewData();
        }
      }
    } else {
      _addingFinished();
    }
    notifyListeners();
  }

  // 构建预览数据方法
  void _buildPreviewData() {
    _previewViewModel.buildPreviewData(
      selectedInstance: selectedInstance,
      selectedDoor: selectedDoor,
      // selectedInOut: selectedInOut ?? selectedDoor,
      aiViewModel: _aiViewModel,
      cameraViewModel: _cameraViewModel,
      nvrViewModel: _nvrViewModel,
      powerBoxViewModel: _powerBoxViewModel,
      powerViewModel: _powerViewModel,
    );
  }

  ///私有方法
  void _loadInitialData() async {
    bool success = false;
    while (!success) {
      try {
        // 使用状态服务初始化数据
        DeviceSearchInitData data = await _searchService.initSearchData();

        instanceList = data.instanceList;
        doorList = data.doorList;
        inOutList = data.inOutList;

        success = true; // 获取成功，退出循环
        notifyListeners();
      } catch (e) {
        // 可选：记录错误日志
        print('请求错误 $e');
        await Future.delayed(const Duration(seconds: 1)); // 延迟后重试，避免过于频繁请求
      }
    }

    HttpQuery.share.labelManagementService.getLabelList("", onSuccess: (data) {
      availableTags = data ?? [];
      notifyListeners();
    }, onError: (String value) {});
  }

  //检查某些条件
  bool _checkCondition() {
    switch (currentStep) {
      case 1: //绑定实例
        if (selectedInstance == null || selectedDoor == null) {
          LoadingUtils.showInfo(data: "请完善实例或大门选择！");
          return false;
        }
        return true;
      case 2: //添加AI设备
        // return true;
        //如果只有一个
        if (aiViewModel.aiDeviceList.length == 1 &&
            (aiViewModel.aiDeviceList.first.mac?.isEmpty ?? true)) {
          LoadingUtils.showInfo(data: "至少添加1个AI设备!");
          return false;
        }

        //去除空的
        for (DeviceDetailAiData ai in aiViewModel.aiDeviceList.toList()) {
          if ((ai.ip?.isEmpty ?? true) || (ai.mac?.isEmpty ?? true)) {
            aiViewModel.aiDeviceList.remove(ai); // 修改原始列表是安全的
          }
        }
        cameraViewModel.aiDeviceList = aiViewModel.aiDeviceList;
        cameraViewModel.instanceId = selectedInstance?.id ?? "";
        cameraViewModel.gateId = selectedDoor?.id ?? 0;
        return true;
      case 3: //摄像头
        // return true;
        //如果只有一个
        if (cameraViewModel.cameraDeviceList.length == 1 &&
            (!cameraViewModel.cameraDeviceList.first.isAddEnd)) {
          LoadingUtils.showInfo(data: "至少添加1个AI设备!");
          return false;
        }

        //去除空的
        for (CameraDeviceEntity camera
            in cameraViewModel.cameraDeviceList.toList()) {
          if ((camera.ip?.isEmpty ?? true) || (camera.rtsp?.isEmpty ?? true)) {
            cameraViewModel.cameraDeviceList.remove(camera); // 修改原始列表是安全的
          }
        }
        return true;
      case 4:
        // return true;
        if (nvrViewModel.checkNvrSelection()) {
          return true;
        }
        return false;
      case 5:
        // return true;
        if (powerBoxViewModel.checkSelection()) {
          return true;
        }
        return false;
      case 6:
        if (powerViewModel.checkSelection()) {
          if (powerViewModel.checkNetworkSelection()) {
            if (powerViewModel.checkExchangeSelection()) {
              return true;
            }
          }
        }
        return false;
      default:
        return false;
    }
  }

  //添加完成
  void _addingFinished() {
    // 完成
    //请求接口  跳转页面
    if (selectedInstance == null || selectedDoor == null) {
      return;
    }

    try {
      Map<String, dynamic> powersMap =
          AddPowerViewModel.getPowersMap(powerViewModel);
      Map<String, dynamic> powerBoxes =
          AddPowerBoxViewModel.getPowerBoxes(powerBoxViewModel);
      Map<String, dynamic> network =
          AddPowerViewModel.getNetwork(powerViewModel);
      Map<String, dynamic> nvr = AddNvrViewModel.getNvr(nvrViewModel);
      List<Map<String, dynamic>> routers = [];
      List<Map<String, dynamic>> wiredNetworks = [];
      if (network["type"] == 6) {
        routers.add(network);
      } else {
        wiredNetworks.add(network);
      }

      HttpQuery.share.installService.installStep2(
          instanceId: selectedInstance?.id ?? "",
          gateId: selectedDoor?.id ?? 0,
          powers: [powersMap],
          powerBoxes: [powerBoxes],
          routers: routers,
          wiredNetworks: wiredNetworks,
          nvrs: [nvr],
          switches: AddPowerViewModel.getSwitches(powerViewModel),
          onSuccess: (data) {
            // 显示成功信息
            LoadingUtils.showInfo(data: "安装成功！");
            
            // 重置所有数据 (内部会调用_previewViewModel.clearPreviewData())
            ResetUtils.resetInstallDeviceScreen();

          });
    } catch (e) {
      print("Error building OnePictureDataData: $e");
    }
  }


// // 添加一个可以从外部调用的重生成预览数据的方法
// void rebuildPreviewData() {
//   // 验证必要数据是否存在
//   if (selectedInstance == null || selectedDoor == null) {
//     LoadingUtils.showInfo(data: "缺少必要的实例或大门信息！");
//     return;
//   }
//
//   // 重新生成预览数据
//   _buildPreviewData();
//
//   // 显示生成中提示
//   LoadingUtils.show(data: "正在重新生成预览数据...");
//
//   // 3秒后关闭加载提示
//   Future.delayed(const Duration(seconds: 3), () {
//     LoadingUtils.dismiss();
//   });
// }
}
