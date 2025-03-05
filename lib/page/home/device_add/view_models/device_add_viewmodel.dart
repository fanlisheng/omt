import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/device_add/view_models/second_step_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/third_step_viewmodel.dart';
import 'package:omt/utils/log_utils.dart';

enum DeviceType {
  power, // 电源
  ai, // ai
  camera, //摄像头
  nvr,
  battery, // 电池
  powerBox, //电源箱
  exchange, //交互机
  router, //路由器
}

//
enum StepNumber {
  first,
  second,
  third,
  four,
}

class DeviceAddViewModel extends BaseViewModelRefresh<dynamic> {
  final int id;
   DeviceType deviceType;
  DeviceAddViewModel(this.id, this.deviceType);

  //第几步
  StepNumber stepNumber = StepNumber.first;

  //电源类型
  String portType = "";
  List portTypes = ["显示进口", "出口", "共用进出口"];
  bool batteryMains = false; //市电
  bool battery = false; //电池

  IdNameValue? deviceTypeSelected;
  List deviceTypes = [];

  @override
  void initState() async {
    super.initState();
    deviceTypes = [
      IdNameValue(id: 1, name: "AI设备"),
      IdNameValue(id: 2, name: "摄像头"),
      IdNameValue(id: 3, name: "NVR"),
      IdNameValue(id: 4, name: "电源箱"),
      IdNameValue(id: 5, name: "交换机"),
      IdNameValue(id: 6, name: "电池"),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///确定电源类型
  confirmPowerEventAction() {
    if (portType.isNotEmpty && (battery || batteryMains)) {
      LogUtils.info(msg: "confirmPowerEventAction");
    }
  }

  //选择设备类型
  selectedDeviceType(a) {
    deviceTypeSelected = a!;
    switch (deviceTypeSelected?.id) {
      case 1:
        deviceType = DeviceType.ai;
        break;
      case 2:
        deviceType = DeviceType.camera;
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
        deviceType = DeviceType.battery;
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
      case StepNumber.third:
        stepNumber = StepNumber.second;
      case StepNumber.four:
        stepNumber = StepNumber.third;
    }
    notifyListeners();
  }

  //下一步
  nextStepEventAction() {
    switch (stepNumber) {
      case StepNumber.first:
        if ((deviceTypeSelected?.name ?? "").isEmpty) {
          return;
        }
        stepNumber = StepNumber.second;
      case StepNumber.second:
        stepNumber = StepNumber.third;
      case StepNumber.third:
        if (deviceType == DeviceType.ai || deviceType == DeviceType.camera) {
          stepNumber = StepNumber.four;
        }
      //完成
      case StepNumber.four:
      //完成
    }
    notifyListeners();
  }
}
