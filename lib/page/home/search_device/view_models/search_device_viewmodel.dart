import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/routing/routes.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/log_utils.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_unbound_entity.dart';
import '../../../../bean/one_picture/one_picture/one_picture_data_entity.dart';
import '../../../one_picture/one_picture/one_picture_page.dart';
import '../../device_detail/view_models/device_detail_viewmodel.dart';
import '../services/device_search_service.dart';

///
///  omt
///  label_me_view_model.dart
///  数据标注
///
///  Created by kayoxu on 2024-04-15 at 16:39:19
///  Copyright © 2024 .. All rights reserved.
///
enum DeviceSearchState {
  notSearched, // 没搜索过
  searching, // 搜索中
  completed, // 搜索完成
  onePicturePage, // 搜索完成
}

class SearchDeviceViewModel extends BaseViewModel {
  // 注入服务
  final DeviceSearchService _searchService = DeviceSearchService();

  //设备搜索状态
  DeviceSearchState searchState = DeviceSearchState.notSearched;

  List<StrIdNameValue> instanceList = [];
  List<IdNameValue> doorList = [];
  List<IdNameValue> inOutList = [];
  StrIdNameValue? selectedInstance;
  IdNameValue? selectedDoor;
  IdNameValue? selectedInOut;

  //设备统计字段
  String deviceStatistics = "";

  //扫描出的设备数据
  List<DeviceEntity> deviceScanData = [];
  List<DeviceEntity> deviceScanTemporaryData = [];

  //没有绑定的数据
  List<DeviceEntity> deviceNoBindingData = [];

  //停止扫描
  bool stopScanning = false;

  //

  // 创建 FocusNode 来监听焦点事件
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool isClear = false;
  final asgbKey = GlobalKey<AutoSuggestBoxState>();

  OnePictureDataData? onePictureHttpData;

  final GlobalKey<OnePicturePageState> picturePageKey = GlobalKey();

  @override
  void initState() async {
    super.initState();
    _setupFocusListener();
    _loadInitialData();
  }

  void _setupFocusListener() {
    focusNode.addListener(() {
      final asgbState = asgbKey.currentState;
      if (asgbState == null) return;
      if (focusNode.hasFocus) {
        // 当获取到焦点时
        asgbState.showOverlay();
        isClear = false;
      } else {
        // 当失去焦点时
        if (asgbState.isOverlayVisible) {
          asgbState.dismissOverlay();
        }
        controller.text = selectedInstance?.name ?? "";
      }
      notifyListeners();
    });
  }

  void _loadInitialData() async {
    // 使用状态服务初始化数据
    DeviceSearchInitData data = await _searchService.initSearchData();

    instanceList = data.instanceList;
    doorList = data.doorList;
    inOutList = data.inOutList;

    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  ///点击事件
  //点击重置-由一张图界面->带‘扫描界面’
  resetEventAction() {
    //清空数据
    deviceStatistics = "";
    deviceScanData = [];
    deviceNoBindingData = [];
    deviceScanTemporaryData = [];
    selectedDoor = null;
    selectedInOut = null;
    //改变状态
    searchState = DeviceSearchState.notSearched;
    notifyListeners();
  }

  //搜索事件
  searchEventAction() async {
    _requestUnboundDevices();
  }

  //开始扫描
  scanStartEventAction() async {
    // 重置数据
    deviceStatistics = "";
    deviceScanData = [];
    deviceNoBindingData = [];
    searchState = DeviceSearchState.searching;
    stopScanning = false;
    notifyListeners();

    // 使用状态服务扫描设备
    DeviceSearchResult result = await _searchService.scanAndProcessDevices(
      instanceId: selectedInstance?.id,
      shouldStop: _shouldStop,
    );

    // 更新视图状态
    searchState = result.state;
    deviceStatistics = result.statistics;
    deviceScanData = result.devices;
    deviceScanTemporaryData = result.devices;
    deviceNoBindingData = result.unboundDevices;

    notifyListeners();
  }

  //扫描停止事件
  scanStopEventAction() async {
    stopScanning = true;
  }

  //重新扫描
  scanAnewEventAction() {
    scanStopEventAction();
    scanStartEventAction();
  }

  //绑定
  bindEventAction() {
    IntentUtils.share
        .push(context, routeName: RouterPage.DeviceBindPage, data: {
      "deviceData": deviceNoBindingData,
      "doorList": doorList,
      "instance": selectedInstance
    })?.then((a) {
      if (IntentUtils.share.isResultOk(a)) {
        if (searchState == DeviceSearchState.completed) {
          _requestDeviceScanData(deviceScanTemporaryData);
        } else if (searchState == DeviceSearchState.onePicturePage) {
          _requestUnboundDevices();
        }
      }
    });
  }

  _requestDeviceScanData(List<DeviceEntity> deviceList) async {
    if (selectedInstance?.id == null || selectedInstance!.id!.isEmpty) {
      return;
    }

    // 使用状态服务扫描设备
    DeviceSearchResult result = await _searchService.scanAndProcessDevices(
      instanceId: selectedInstance?.id,
      shouldStop: _shouldStop,
    );

    // 更新视图状态
    searchState = result.state;
    deviceStatistics = result.statistics;
    deviceScanData = result.devices;
    deviceScanTemporaryData = result.devices;
    deviceNoBindingData = result.unboundDevices;

    notifyListeners();
  }

  _requestUnboundDevices() async {
    if (selectedInstance == null || (selectedInstance?.id ?? "").isEmpty) {
      return;
    }

    // 使用状态服务获取未绑定设备
    DeviceSearchResult result = await _searchService.getUnboundDevicesWithState(
      instanceId: selectedInstance?.id,
      instanceName: selectedInstance?.name,
      gateId: selectedDoor?.id,
      passId: selectedInOut?.id,
      picturePageKey: picturePageKey,
    );

    // 更新视图状态
    searchState = result.state;
    deviceStatistics = result.statistics;
    deviceNoBindingData = result.unboundDevices;

    notifyListeners();
  }

  // 定义一个停止条件的回调函数
  bool _shouldStop() {
    return stopScanning; // 当 stopScanning 为 true 时停止
  }
}
