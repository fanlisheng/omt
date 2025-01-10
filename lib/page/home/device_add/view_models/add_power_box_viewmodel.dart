import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../../bean/home/home_page/local_device_entity.dart';
import 'device_add_viewmodel.dart';

class AddPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});

  final DeviceType deviceType;
  final StepNumber stepNumber;

  AddPowerBoxViewModel(this.deviceType, this.stepNumber);

  List<LocalDeviceEntity> deviceList = [LocalDeviceEntity()];

  // 进/出口选项
  String selectedEntryExit = "";
  List entryExitList = ["显示进口", "出口", "共用进出口"];

  String selectedPowerBoxCoding = "";
  List powerBoxCodingList = ["1", "2"];

  bool isPowerBoxNeeded = false;

  // ed接口信息
  List<Map<String, String>> edPortInfo = [];

  @override
  void initState() async {
    super.initState();
    edPortInfo = [
      {
        "DC": "1",
        "状态": "正在录像",
        "电压": "正常",
        "电流": "2024-09-25 10:22:34",
        "运行设备": "未知"

      },
      {
        "DC": "1",
        "状态": "正在录像",
        "电压": "正常",
        "电流": "2024-09-25 10:22:34",
        "运行设备": "未知"
      },
      {
        "DC": "1",
        "状态": "正在录像",
        "电压": "正常",
        "电流": "2024-09-25 10:22:34",
        "运行设备": "未知"
      }
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
}
