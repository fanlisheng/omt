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

  //没有绑定的数据
  List<DeviceEntity> deviceNoBindingData = [];

  //扫描进度

  //停止扫描
  bool stopScanning = false;

  // 创建 FocusNode 来监听焦点事件
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool isClear = false;
  final asgbKey = GlobalKey<AutoSuggestBoxState>();

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
  //搜索事件
  searchEventAction() async {
    DeviceDetailViewModel model = DeviceDetailViewModel(
      deviceType: DeviceType.power,
      // nodeCode: '124#12812-2#2-3#1-11#0',
      nodeCode: '124#12812-2#7-4#1',
    );

    // GoRouter.of(context!).push(Routes.deviceDetail, extra: model);
    // GoRouter.of(context!).push('/navigation/navigation_view');

    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceDetailScreen, data: {"data": model});

    // final result =
    //     await hikvisionDeviceInfo(ipAddress: "192.168.101.22");
    // LogUtils.info(msg: result);
    // discoverService();

    // IntentUtils.share.push(context,
    //     routeName: RouterPage.DeviceAddPage, data: {"id": 0, "type": DeviceType.ai});

    // scanDevice();
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
    } else {
      //扫描完成,上传请求
      HttpQuery.share.homePageService.deviceScan(
          instanceId: selectedInstance?.id ?? "",
          // instanceId: "562#6175",
          deviceList: deviceScanData,
          onSuccess: (DeviceScanEntity? scanData) {
            searchState = DeviceSearchState.completed;
            deviceStatistics =
                _generateDeviceStatistics(scanData?.devices ?? []);
            deviceScanData = scanData?.devices ?? [];
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
    notifyListeners();
  }

  // 定义一个停止条件的回调函数
  bool _shouldStop() {
    return stopScanning; // 当 stopScanning 为 true 时停止
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
        scanAnewEventAction();
      }
    });
  }

  //所有服务
  discoverService() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    // 扫描所有服务
    await for (final PtrResourceRecord ptrA in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_services._dns-sd._udp.local'))) {
      await for (final PtrResourceRecord ptr
          in client.lookup<PtrResourceRecord>(
              ResourceRecordQuery.serverPointer(ptrA.domainName))) {
        print('开始扫描 service: ${ptrA.domainName}');

        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
                ResourceRecordQuery.service(ptr.domainName))) {
          print('设备名字: ${srv.target}');

          await for (final IPAddressResourceRecord ip
              in client.lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv4(srv.target))) {
            if (ip.address.address == "192.168.101.22") {
              print('设备IP是对的');
              client.stop();
              return;
            }
          }
        }
      }
    }

    client.stop();
  }

// LocalDeviceEntity getDeviceTypeInfo(LocalDeviceEntity info) {
//   if (info.domainName == null) return info;
//   if (info.domainName!.contains('DS-2CD') ||
//       info.domainName!.contains('DS-2DE')) {
//     info.type = "摄像头";
//   } else if (info.domainName!.contains('DS-76') ||
//       info.domainName!.contains('DS-77')) {
//     info.type = "DVR";
//   } else if (info.domainName!.contains('AI')) {
//     info.type = "AI 设备";
//   } else {
//     info.type = "未知设备";
//     return info;
//   }
//   return info;
// }

  String _generateDeviceStatistics(List<DeviceEntity>? deviceList) {
    if (deviceList == null || deviceList.isEmpty) return "无设备";

    // 定义设备类型对应关系
    final deviceTypeMap = {
      6: "路由器",
      8: "NVR",
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
