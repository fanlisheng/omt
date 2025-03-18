import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/http/service/home/home_page/home_page_service.dart';
import 'package:omt/page/home/device_add/view_models/device_add_viewmodel.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/routing/routes.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/log_utils.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_unbound_entity.dart';
import '../../../../bean/one_picture/one_picture/one_picture_data_entity.dart';
import '../../../one_picture/one_picture/one_picture_page.dart';
import '../../device_detail/view_models/device_detail_viewmodel.dart';

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

    HttpQuery.share.homePageService.getInstanceList("5101",
        onSuccess: (List<StrIdNameValue>? a) {
      instanceList = a ?? [];
      notifyListeners();
    });

    HttpQuery.share.homePageService.getGateList(
        onSuccess: (List<IdNameValue>? a) {
      doorList = a ?? [];
      notifyListeners();
    });

    HttpQuery.share.homePageService.getInOutList(
        onSuccess: (List<IdNameValue>? a) {
      inOutList = a ?? [];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  ///点击事件
  //
  resetEventAction() {
    //清空数据
    deviceStatistics = "";
    deviceScanData = [];
    deviceNoBindingData = [];
    deviceScanTemporaryData = [];
    selectedInstance = null;
    selectedDoor = null;
    selectedInOut = null;
    controller.text = "";
    //改变状态
    searchState = DeviceSearchState.notSearched;
    notifyListeners();
  }

  //搜索事件
  searchEventAction() async {
    // final result =
    //     await hikvisionDeviceInfo(ipAddress: "192.168.101.22");
    // LogUtils.info(msg: result);
    // discoverService();

    // scanDevice();
    _requestUnboundDevices();
  }

  //开始扫描
  scanStartEventAction() async {
    deviceStatistics = "";
    deviceScanData = [];
    deviceNoBindingData = [];
    searchState = DeviceSearchState.searching;
    stopScanning = false;
    notifyListeners();

    deviceScanData =
        await DeviceUtils.scanAndFetchDevicesInfo(shouldStop: _shouldStop);

    if (stopScanning == true) {
      searchState = DeviceSearchState.notSearched;
      deviceScanData = [];
      deviceScanTemporaryData = deviceScanData;
    } else {
      //扫描完成,上传请求
      _requestDeviceScanData(deviceScanData);
    }
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
        //   scanAnewEventAction();
      }
    });
  }

  _requestDeviceScanData(List<DeviceEntity> deviceList) {
    HttpQuery.share.homePageService.deviceScan(
        instanceId: selectedInstance?.id ?? "",
        // instanceId: "562#6175",
        deviceList: deviceList,
        onSuccess: (DeviceScanEntity? scanData) {
          searchState = DeviceSearchState.completed;
          deviceStatistics = _generateDeviceStatistics(scanData?.devices ?? []);
          deviceScanData = scanData?.devices ?? [];
          deviceScanTemporaryData = scanData?.devices ?? [];
          deviceNoBindingData = scanData?.unboundDevices ?? [];
          notifyListeners();
        },
        onError: (e) {
          searchState = DeviceSearchState.completed;
          deviceStatistics = "";
          deviceScanData = [];
          deviceNoBindingData = [];
          notifyListeners();
        });
  }

  _requestUnboundDevices() {
    if (selectedInstance == null || (selectedInstance?.id ?? "").isEmpty) {
      return;
    }
    HttpQuery.share.homePageService.getUnboundDevices(
      instanceId: selectedInstance!.id!,
      onSuccess: (DeviceUnboundEntity? a) {
        deviceNoBindingData = a?.unboundDevices ?? [];
        searchState = DeviceSearchState.onePicturePage;
        //记录统计数据
        StringBuffer countStr = StringBuffer();
        for (DeviceUnboundAllCount item in a?.allCount ?? []) {
          countStr.write("${item.count}个${item.deviceTypeText} / ");
        }
        String result = countStr.toString();
        if (result.length > 2) {
          deviceStatistics = result.substring(0, result.length - 2);
        } else {
          deviceStatistics = result;
        }
        //重新请求一张图的数据
        picturePageKey.currentState?.refresh();
        notifyListeners();
      },
    );
  }

  // 定义一个停止条件的回调函数
  bool _shouldStop() {
    return stopScanning; // 当 stopScanning 为 true 时停止
  }


  String _generateDeviceStatistics(List<DeviceEntity>? deviceList) {
    if (deviceList == null || deviceList.isEmpty) return "暂无设备";

    // 定义设备类型对应关系
    final deviceTypeMap = {
      5: "电源箱",
      6: "路由器",
      8: "NVR",
      9: "交换机",
      10: "AI设备",
      11: "摄像头",
    };

    // 统计设备数量
    Map<int, int> deviceCount = {};
    for (var device in deviceList) {
      if (deviceTypeMap.containsKey(device.deviceType)) {
        deviceCount[device.deviceType!] =
            (deviceCount[device.deviceType] ?? 0) + 1;
      }
    }

    // 生成统计字符串
    List<String> stats = deviceCount.entries.map((entry) {
      String deviceName = deviceTypeMap[entry.key]!;
      return "${entry.value}个$deviceName";
    }).toList();

    return stats.join(" / ");
  }
}
