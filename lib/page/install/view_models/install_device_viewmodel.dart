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
import 'package:omt/bean/install/install_cache_data.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../bean/home/home_page/camera_device_entity.dart';
import '../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../bean/home/home_page/device_entity.dart';
import '../../../http/service/install/install_cache_service.dart';
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

  // 缓存服务
  final InstallCacheService _cacheService = InstallCacheService.instance;

  // 是否正在从缓存恢复数据
  bool _isRestoringFromCache = false;

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
    // _saveCacheData(); // 保存缓存
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
        _saveCacheData(); // 保存缓存
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
    // 先尝试恢复缓存数据
    final cacheData = await _cacheService.getCacheData();
    IdNameValue? cachedSelectedDoor = cacheData?.selectedDoor;
    StrIdNameValue? cachedSelectedInstance = cacheData?.selectedInstance;

    bool success = false;
    while (!success) {
      try {
        // 使用状态服务初始化数据
        DeviceSearchInitData data = await _searchService.initSearchData();

        instanceList = data.instanceList;
        doorList = data.doorList;
        inOutList = data.inOutList;

        success = true; // 获取成功，退出循环

        // 智能恢复缓存的选择项
        _smartRestoreSelections(cachedSelectedInstance, cachedSelectedDoor);

        notifyListeners();

        // 在基础数据加载完成后恢复其他缓存数据
        _restoreCacheAfterDataLoaded();
      } catch (e) {
        // 可选：记录错误日志
        print('请求错误 $e');
        await Future.delayed(const Duration(seconds: 1)); // 延迟后重试，避免过于频繁请求
      }
    }
  }

  /// 智能恢复选择项，优先保持缓存的选择
  void _smartRestoreSelections(
      StrIdNameValue? cachedInstance, IdNameValue? cachedDoor) {
    // 恢复实例选择
    if (cachedInstance != null) {
      try {
        selectedInstance = instanceList.firstWhere(
          (instance) => instance.id == cachedInstance.id,
        );
      } catch (e) {
        // 如果在新列表中找不到，保持缓存的实例数据
        selectedInstance = cachedInstance;
      }
    }

    // 恢复大门选择
    if (cachedDoor != null) {
      try {
        selectedDoor = doorList.firstWhere(
          (door) => door.id == cachedDoor.id,
        );
      } catch (e) {
        // 如果在新列表中找不到，保持缓存的大门数据
        selectedDoor = cachedDoor;
      }
    }
  }

  /// 在基础数据加载完成后恢复缓存
  void _restoreCacheAfterDataLoaded() {
    HttpQuery.share.labelManagementService.getLabelList("", onSuccess: (data) {
      availableTags = data ?? [];
      notifyListeners();

      // 在所有基础数据加载完成后恢复缓存
      restoreFromCache();
    }, onError: (String value) {
      // 即使标签加载失败，也要尝试恢复缓存
      restoreFromCache();
    });
  }

  // 处理实例选择事件
  void onInstanceSelected(StrIdNameValue? instance) {
    selectedInstance = instance;
    selectedDoor = null;
    notifyListeners();
    _saveCacheData(); // 保存缓存
  }

  // 处理大门选择事件
  void onDoorSelected(IdNameValue? door) {
    selectedDoor = door;
    selectedInOut = null;
    notifyListeners();
    _saveCacheData(); // 保存缓存
  }

  // 处理标签选择事件
  void onTagsSelected(List<StrIdNameValue> tags) {
    selectedTags = tags;
    notifyListeners();
    _saveCacheData(); // 保存缓存
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
          LoadingUtils.showInfo(data: "至少添加1个摄像头!");
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
      Map<String, dynamic>? powerBoxes =
          AddPowerBoxViewModel.getPowerBoxes(powerBoxViewModel);
      Map<String, dynamic> network =
          AddPowerViewModel.getNetwork(powerViewModel);
      Map<String, dynamic>? nvr = AddNvrViewModel.getNvr(nvrViewModel);
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
          powerBoxes: powerBoxes != null ? [powerBoxes] : [],
          routers: routers,
          wiredNetworks: wiredNetworks,
          nvrs: nvr != null ? [nvr] : [],
          switches: AddPowerViewModel.getSwitches(powerViewModel),
          onSuccess: (data) {
            // 显示成功信息
            LoadingUtils.showInfo(data: "安装成功！");

            // 清除缓存数据
            _clearCacheData();

            ResetUtils.resetInstallDeviceScreen();
          });
    } catch (e) {
      print("Error building OnePictureDataData: $e");
    }
  }

  /// 保存缓存数据
  void _saveCacheData() {
    if (_isRestoringFromCache) return; // 避免在恢复数据时保存

    try {
      final cacheData = InstallCacheData(
        currentStep: currentStep,
        selectedInstance: selectedInstance,
        selectedDoor: selectedDoor,
        selectedInOut: selectedInOut,
        selectedTags: selectedTags,
        aiDeviceList: _aiViewModel.aiDeviceList,
        cameraDeviceList: InstallCacheService.cameraDeviceListToMapList(
            _cameraViewModel.cameraDeviceList),
        // 从各个ViewModel获取最新的缓存数据
        gateId: _aiViewModel.gateId,
        instanceId: _aiViewModel.instanceId,
        cameraInOutList: _cameraViewModel.inOutList,
        cameraTypeList: _cameraViewModel.cameraTypeList,
        regulationList: _cameraViewModel.regulationList,
        isNvrNeeded: _nvrViewModel.isNvrNeeded,
        selectedNarInOut: _nvrViewModel.selectedNarInOut,
        nvrInOutList: _nvrViewModel.inOutList,
        selectedNvr: _nvrViewModel.selectedNvr?.toJson(),
        nvrDeviceData: _nvrViewModel.nvrData?.toJson(),
        isPowerBoxNeeded: _powerBoxViewModel.isPowerBoxNeeded,
        selectedPowerBoxInOut: _powerBoxViewModel.selectedPowerBoxInOut,
        powerBoxInOutList: _powerBoxViewModel.inOutList,
        selectedDeviceDetailPowerBox:
            _powerBoxViewModel.selectedDeviceDetailPowerBox?.toJson(),
        powerBoxList:
            _powerBoxViewModel.powerBoxList.map((e) => e.toJson()).toList(),
        portType: _powerViewModel.portType,
        batteryMains: _powerViewModel.batteryMains,
        battery: _powerViewModel.battery,
        isCapacity80: _powerViewModel.isCapacity80,
        selectedPowerInOut: _powerViewModel.selectedPowerInOut,
        powerInOutList: _powerViewModel.inOutList,
        selectedRouterType: _powerViewModel.selectedRouterType,
        routerTypeList: _powerViewModel.routerTypeList,
        routerIp: _powerViewModel.routerIpController.text,
        mac: _powerViewModel.mac,
        exchangeDevices: _powerViewModel.exchangeDevices
            .map((e) => {
                  'selectedPortNumber': e.selectedPortNumber,
                  'selectedSupplyMethod': e.selectedSupplyMethod,
                })
            .toList(),
        selectedExchangeInOut: _powerViewModel.selectedInOut,
      );

      _cacheService.saveCacheData(cacheData);
    } catch (e) {
      print('保存缓存数据失败: $e');
    }
  }

  /// 从缓存恢复数据
  Future<void> restoreFromCache() async {
    try {
      _isRestoringFromCache = true;
      final cacheData = await _cacheService.getCacheData();

      if (cacheData != null) {
        currentStep = cacheData.currentStep;

        // selectedInstance 和 selectedDoor 已在 _smartRestoreSelections 中处理
        // 这里只恢复其他数据
        selectedInOut = cacheData.selectedInOut;
        selectedTags = cacheData.selectedTags;

        // 恢复AI设备数据
        _aiViewModel.aiDeviceList.clear();
        _aiViewModel.aiDeviceList.addAll(cacheData.aiDeviceList);
        // 同步AI控制器与设备列表
        _aiViewModel.syncControllersWithDeviceList();

        // 恢复摄像头设备数据
        _cameraViewModel.aiDeviceList.clear();
        _cameraViewModel..aiDeviceList.addAll(cacheData.aiDeviceList);
        _cameraViewModel.cameraDeviceList.clear();
        _cameraViewModel.cameraDeviceList.addAll(
            InstallCacheService.cameraDeviceListFromMapList(
                cacheData.cameraDeviceList));
        // 同步摄像头控制器与设备列表
        _cameraViewModel.syncControllersWithDeviceList();

        // 恢复AI ViewModel的缓存数据
        if (cacheData.gateId != null) {
          _aiViewModel.gateId = cacheData.gateId!;
        }
        if (cacheData.instanceId != null) {
          _aiViewModel.instanceId = cacheData.instanceId!;
        }

        // 恢复Camera ViewModel的缓存数据
        if (cacheData.cameraInOutList != null) {
          _cameraViewModel.inOutList = cacheData.cameraInOutList!;
        }
        if (cacheData.cameraTypeList != null) {
          _cameraViewModel.cameraTypeList = cacheData.cameraTypeList!;
        }
        if (cacheData.regulationList != null) {
          _cameraViewModel.regulationList = cacheData.regulationList!;
        }

        // 调用智能缓存恢复，确保选中项在列表中存在
        _cameraViewModel.smartRestoreCacheSelections();

        // 恢复NVR ViewModel的缓存数据
        if (cacheData.isNvrNeeded != null) {
          _nvrViewModel.isNvrNeeded = cacheData.isNvrNeeded;
        }
        if (cacheData.selectedNarInOut != null) {
          _nvrViewModel.selectedNarInOut = cacheData.selectedNarInOut;
        }
        if (cacheData.nvrInOutList != null) {
          _nvrViewModel.inOutList = cacheData.nvrInOutList!;
        }
        // 注意：这里需要根据实际的类型进行转换，暂时注释掉
        if (cacheData.selectedNvr != null) {
          _nvrViewModel.selectedNvr =
              DeviceEntity.fromJson(cacheData.selectedNvr!);
        }
        if (cacheData.nvrDeviceData != null) {
          _nvrViewModel.nvrData =
              DeviceDetailNvrData.fromJson(cacheData.nvrDeviceData!);
        }
        _nvrViewModel.smartRestoreCacheSelections();

        // 恢复PowerBox ViewModel的缓存数据
        if (cacheData.isPowerBoxNeeded != null) {
          _powerBoxViewModel.isPowerBoxNeeded = cacheData.isPowerBoxNeeded;
        }
        if (cacheData.selectedPowerBoxInOut != null) {
          _powerBoxViewModel.selectedPowerBoxInOut =
              cacheData.selectedPowerBoxInOut;
        }
        if (cacheData.powerBoxInOutList != null) {
          _powerBoxViewModel.inOutList = cacheData.powerBoxInOutList!;
        }
        // 注意：这里需要根据实际的类型进行转换，暂时注释掉
        if (cacheData.selectedDeviceDetailPowerBox != null) {
          _powerBoxViewModel.selectedDeviceDetailPowerBox =
              DeviceDetailPowerBoxData.fromJson(
                  cacheData.selectedDeviceDetailPowerBox!);
        }
        if (cacheData.powerBoxList != null) {
          _powerBoxViewModel.powerBoxList = cacheData.powerBoxList!
              .map((e) => DeviceDetailPowerBoxData.fromJson(e))
              .toList();
        }

        _powerBoxViewModel.smartRestoreCacheSelections();

        // 恢复Power ViewModel的缓存数据
        if (cacheData.portType != null) {
          _powerViewModel.portType = cacheData.portType!;
        }
        if (cacheData.batteryMains != null) {
          _powerViewModel.batteryMains = cacheData.batteryMains!;
        }
        if (cacheData.battery != null) {
          _powerViewModel.battery = cacheData.battery!;
        }
        if (cacheData.isCapacity80 != null) {
          _powerViewModel.isCapacity80 = cacheData.isCapacity80!;
        }
        if (cacheData.selectedPowerInOut != null) {
          _powerViewModel.selectedPowerInOut = cacheData.selectedPowerInOut;
        }
        if (cacheData.powerInOutList != null) {
          _powerViewModel.inOutList = cacheData.powerInOutList!;
        }
        if (cacheData.selectedRouterType != null) {
          _powerViewModel.selectedRouterType = cacheData.selectedRouterType;
        }
        if (cacheData.routerTypeList != null) {
          _powerViewModel.routerTypeList = cacheData.routerTypeList!;
        }
        if (cacheData.routerIp != null) {
          _powerViewModel.routerIpController.text = cacheData.routerIp!;
        }
        if (cacheData.mac != null) {
          _powerViewModel.mac = cacheData.mac;
        }
        if (cacheData.exchangeDevices != null) {
          _powerViewModel.exchangeDevices.clear();
          for (var deviceData in cacheData.exchangeDevices!) {
            final device = ExchangeDeviceModel();
            device.selectedPortNumber = deviceData['selectedPortNumber'];
            device.selectedSupplyMethod = deviceData['selectedSupplyMethod'];
            _powerViewModel.exchangeDevices.add(device);
          }
        }
        if (cacheData.selectedExchangeInOut != null) {
          _powerViewModel.selectedInOut = cacheData.selectedExchangeInOut;
        }

        // 同步其他设备的控制器
        _powerViewModel.smartRestoreCacheSelections();
        // _powerViewModel.syncControllersWithData();

        // 跳转到对应步骤
        if(currentStep > 7){
          currentStep = 6;
        }
        pageController.jumpToPage(currentStep - 1);

        notifyListeners();
      }
    } catch (e) {
      print('恢复缓存数据失败: $e');
    } finally {
      _isRestoringFromCache = false;
    }
  }

  /// 清除缓存数据
  void _clearCacheData() {
    _cacheService.clearCacheData();
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
