import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';

import 'add_ai_viewmodel.dart';
import 'add_battery_exchange_viewmodel.dart';
import 'add_camera_viewmodel.dart';
import 'add_nvr_viewmodel.dart';
import 'add_power_box_viewmodel.dart';
import 'add_power_viewmodel.dart';
import 'add_router_viewmodel.dart';

enum DeviceType {
  power, // 电源
  ai, // ai
  camera, //摄像头
  nvr,
  battery, // 电池
  powerBox, //电源箱
  exchange, //交互机
  router, //路由器
  aiAndCamera,
}

//
enum StepNumber {
  first,
  second,
  third,
  four,
}

class DeviceAddViewModel extends BaseViewModelRefresh<dynamic> {
  // 父节点code
  final String pNodeCode;

  DeviceAddViewModel(this.pNodeCode);

  StepNumber stepNumber = StepNumber.first; //第几步
  DeviceType? deviceType; //设备类型
  bool isInstall = false; //是安装 默认否

  IdNameValue? deviceTypeSelected;
  List deviceTypes = [];

  // ===== 共用 进出口 =====
  // List<IdNameValue> inOutList = [];

  // ===== 网络环境相关属性 =====
  String selectedNetworkEnv = "";
  List<IdNameValue> networkEnvList = [];

  // ===== 各个子ViewModel =====
  AddAiViewModel? aiViewModel;
  AddCameraViewModel? cameraViewModel;
  AddNvrViewModel? nvrViewModel;
  AddPowerBoxViewModel? powerBoxViewModel;
  AddBatteryExchangeViewModel? batteryExchangeViewModel;
  AddPowerViewModel? powerViewModel;
  AddRouterViewModel? routerViewModel;

  @override
  void initState() async {
    super.initState();
    deviceTypes = [
      IdNameValue(id: 1, name: "AI设备与摄像头"),
      // IdNameValue(id: 2, name: "摄像头"),
      IdNameValue(id: 3, name: "NVR"),
      IdNameValue(id: 4, name: "电源箱"),
      IdNameValue(id: 5, name: "交换机"),
      IdNameValue(id: 6, name: "电源"),
      IdNameValue(id: 7, name: "路由器"),
    ];

    // 初始化进/出口列表
    // HttpQuery.share.homePageService.getInOutList(
    //   onSuccess: (List<IdNameValue>? data) {
    //     inOutList = data ?? [];
    //     notifyListeners();
    //   },
    // );

    // 初始化网络环境列表
    networkEnvList = [
      IdNameValue(id: 1, name: "环境1"),
      IdNameValue(id: 2, name: "环境2"),
      IdNameValue(id: 3, name: "环境3")
    ];
  }

  @override
  void dispose() {
    // 销毁所有控制器
    aiViewModel?.dispose();
    cameraViewModel?.dispose();
    nvrViewModel?.dispose();
    powerBoxViewModel?.dispose();
    batteryExchangeViewModel?.dispose();
    powerViewModel?.dispose();
    routerViewModel?.dispose();
    LoadingUtils.dismiss();
    try {
      super.dispose();
    } catch (e) {
      // 忽略父类dispose错误
    }
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///确定电源类型
  confirmPowerEventAction() {
    // if (portType.isNotEmpty && (battery || batteryMains)) {
    //   LogUtils.info(msg: "confirmPowerEventAction");
    // }
  }

  //选择设备类型
  selectedDeviceType(a) {
    deviceTypeSelected = a!;
    switch (deviceTypeSelected?.id) {
      case 1:
        deviceType = DeviceType.aiAndCamera;
        // deviceType = DeviceType.ai;
        break;
      case 2:
      // deviceType = DeviceType.camera;
        break;
      case 3:
        deviceType = DeviceType.nvr;
        break;
      case 4:
        deviceType = DeviceType.powerBox;
        break;
      case 5:
        deviceType = DeviceType.exchange;
        break;
      case 6:
        deviceType = DeviceType.power;
        break;
      case 7:
        deviceType = DeviceType.router;
        break;
    }
    notifyListeners();
  }

  //上一步
  backStepEventAction() {
    switch (stepNumber) {
      case StepNumber.first:
        return;
      case StepNumber.second:
        stepNumber = StepNumber.first;
        break;
      case StepNumber.third:
        stepNumber = StepNumber.second;
        // 从第三步返回第二步时，保持aiViewModel不销毁，直接复用
        // 不需要重新创建，保持原有的ViewModel状态
        break;
      case StepNumber.four:
        stepNumber = StepNumber.third;
        break;
    }
    notifyListeners();
  }

  //下一步
  //下一步
  nextStepEventAction() async {
    switch (stepNumber) {
      case StepNumber.first:
        if ((deviceTypeSelected?.name ?? "").isEmpty) {
          return;
        }
        // 根据选择的设备类型创建对应的 ViewModel
        switch (deviceType) {
          case DeviceType.ai:
          case DeviceType.camera:
          case DeviceType.aiAndCamera:
            aiViewModel ??= AddAiViewModel(pNodeCode);
            break;
          case DeviceType.nvr:
            nvrViewModel = AddNvrViewModel(pNodeCode);
            break;
          case DeviceType.powerBox:
            powerBoxViewModel =
                AddPowerBoxViewModel(pNodeCode, isInstall: isInstall);
            break;
          case DeviceType.exchange:
            batteryExchangeViewModel = AddBatteryExchangeViewModel(pNodeCode,
                isInstall: isInstall, isBattery: false);
            break;
          case DeviceType.battery:
            batteryExchangeViewModel = AddBatteryExchangeViewModel(pNodeCode,
                isInstall: isInstall, isBattery: true);
            break;
          case DeviceType.power:
            powerViewModel = AddPowerViewModel(pNodeCode, isInstall: isInstall);
            break;
          case DeviceType.router:
            routerViewModel =
                AddRouterViewModel(pNodeCode, isInstall: isInstall);
            break;
          default:
            break;
        }
        stepNumber = StepNumber.second;
      case StepNumber.second:
      // 处理不同设备类型的下一步操作
        switch (deviceType) {
          case DeviceType.ai:
          case DeviceType.camera:
          case DeviceType.aiAndCamera:
          // AI设备
            if (aiViewModel != null &&
                aiViewModel!.aiDeviceList.isNotEmpty &&
                aiViewModel!.aiDeviceList.first.mac != null) {
              cameraViewModel = AddCameraViewModel(
                  pNodeCode, aiViewModel?.aiDeviceList ?? []);
              stepNumber = StepNumber.third;
            } else {
              LoadingUtils.showToast(data: '请先连接AI设备');
              return;
            }
            break;
          case DeviceType.nvr:
          // NVR设备
            if (nvrViewModel != null) {
              nvrViewModel!.installNvrAction();
            }
            return;
          case DeviceType.powerBox:
          // 电源箱
            if (powerBoxViewModel != null) {
              powerBoxViewModel!.installPowerBox();
            }
            return;
          case DeviceType.exchange:
          // 交换机
            if (batteryExchangeViewModel != null &&
                !batteryExchangeViewModel!.isBattery) {
              batteryExchangeViewModel!.installSwitch();
            }
            return;
          case DeviceType.battery:
          // 电池
          // if (batteryExchangeViewModel != null && batteryExchangeViewModel!.isBattery) {
          //   batteryExchangeViewModel!.installBattery();
          // }
            return;
          case DeviceType.power:
          // 电源
            if (powerViewModel != null) {
              powerViewModel!.installPower();
            }
            return;
          case DeviceType.router:
          // 路由器
            if (routerViewModel != null) {
              routerViewModel!.installRouter();
            }
            return;
          default:
            return;
        }
        break;
      case StepNumber.third:
        switch (deviceType) {
          case DeviceType.ai:
          case DeviceType.camera:
          case DeviceType.aiAndCamera:
            cameraViewModel!.addComplete();
          default:
            return;
        }
        break;
      case StepNumber.four:
        break;
    }
    notifyListeners();
  }

  nextStepEventAction2() async {
    switch (stepNumber) {
      case StepNumber.first:
        if ((deviceTypeSelected?.name ?? "").isEmpty) {
          return;
        }
        stepNumber = StepNumber.second;
        notifyListeners();
        break;
      case StepNumber.second:
      // 根据设备类型执行不同的操作
        switch (deviceType) {
          case DeviceType.ai:
          // AI设备
            if (aiViewModel != null &&
                aiViewModel!.aiDeviceList.isNotEmpty &&
                aiViewModel!.aiDeviceList.first.mac != null &&
                aiViewModel?.aiDeviceList.first.ip != null) {
              cameraViewModel = AddCameraViewModel(
                  pNodeCode, aiViewModel?.aiDeviceList ?? []);
              stepNumber = StepNumber.third;
            } else {
              LoadingUtils.showToast(data: '请先连接AI设备');
              return;
            }
            break;
          case DeviceType.camera:
          // 摄像头
            if (cameraViewModel != null) {
              stepNumber = StepNumber.third;
            } else {
              return;
            }
            break;
          case DeviceType.nvr:
          // NVR设备
            if (nvrViewModel != null) {
              nvrViewModel!.installNvrAction();
            }
            return;
          case DeviceType.powerBox:
          // 电源箱
            if (powerBoxViewModel != null) {
              powerBoxViewModel!.installPowerBox();
            }
            return;
          case DeviceType.exchange:
          // 交换机
            if (batteryExchangeViewModel != null &&
                !batteryExchangeViewModel!.isBattery) {
              batteryExchangeViewModel!.installSwitch();
            }
            return;
          case DeviceType.battery:
          // 电池
            return;
          case DeviceType.power:
          // 电源
            if (powerViewModel != null) {
              powerViewModel!.installPower();
            }
            return;
          case DeviceType.router:
          // 路由器
            if (routerViewModel != null) {
              routerViewModel!.installRouter();
            }
            return;
          default:
            break;
        }
        stepNumber = StepNumber.third;
        notifyListeners();
        break;
      case StepNumber.third:
        stepNumber = StepNumber.four;
        notifyListeners();
        break;
      case StepNumber.four:
      // 完成
        break;
    }
  }
}
