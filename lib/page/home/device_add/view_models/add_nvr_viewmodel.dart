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

class AddNvrViewModel extends BaseViewModelRefresh<dynamic> {
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});

  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool showInstall;
  AddNvrViewModel(this.deviceType, this.stepNumber, this.showInstall);

  List<LocalDeviceEntity> deviceList = [LocalDeviceEntity()];

  ///nvr
  // 是否需要安装NVR
  bool isNvrNeeded = true;

  // 当前选择的NVR IP地址
  String? selectedNvrIp;
  // NVR IP地址列表
  List<String> nvrIpList = [];

  // 进/出口选项
  String selectedEntryExit = "共用进出口";

  // NVR通道信息
  List<Map<String, String>> nvrInfo = [];

  @override
  void initState() async {
    super.initState();
    nvrInfo = [
      {
        "通道号": "1",
        "是否在录像": "正在录像",
        "信号状态": "正常",
        "更新时间": "2024-09-25 10:22:34"
      },
      {"通道号": "2", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
      {"通道号": "3", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
      {"通道号": "4", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
      {"通道号": "5", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
      {"通道号": "6", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
      {"通道号": "7", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
    ];
    nvrIpList = ["192.168.101.252", "192.168.101.253", "192.168.101.254", "192.168.101.255"];
  }

  @override
  void dispose() {
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///点击事件
  refreshEventAction(){

  }
}
