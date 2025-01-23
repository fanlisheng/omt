import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import 'device_add_viewmodel.dart';

class ThirdFourStepViewModel extends BaseViewModelRefresh<dynamic> {

  final DeviceType deviceType;
  StepNumber stepNumber;

  ThirdFourStepViewModel(
      {required this.deviceType, required this.stepNumber});

  List<DeviceEntity> deviceList = [DeviceEntity()];

  String selectedNetworkEnv = "";
  List networkEnvList = [];
  @override
  void initState() async {
    super.initState();
    networkEnvList = [
      IdNameValue(id: 1, name: "环境1"),
      IdNameValue(id: 2, name: "环境2"),
      IdNameValue(id: 3, name: "环境3")
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
