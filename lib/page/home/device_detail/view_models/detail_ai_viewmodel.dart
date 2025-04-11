import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailAiViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeCode;

  DetailAiViewModel(this.nodeCode);

  DeviceDetailAiData deviceInfo = DeviceDetailAiData();

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
    HttpQuery.share.homePageService.deviceDetailAi(
        nodeCode: nodeCode,
        onSuccess: (DeviceDetailAiData? a) {
          deviceInfo = a ?? DeviceDetailAiData();
          notifyListeners();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///点击事件
  //连接
  connectEventAction(int index) async {}

  //重起
  restartAction() {
    HttpQuery.share.homePageService.restartAiDevice(
        deviceCode: deviceInfo.deviceCode ?? "",
        onSuccess: (a) {
          LoadingUtils.show(data: "重启成功!");
        });
  }

  //升级主程版本
  upgradeProgramAction() {
    HttpQuery.share.homePageService.upgradeAiDeviceProgram(
        deviceCode: deviceInfo.deviceCode ?? "",
        onSuccess: (a) {
          _requestData();
        });
  }

  //升级识别版本
  upgradeIdentityAction() {
    HttpQuery.share.homePageService.upgradeAiDeviceIdentity(
        deviceCode: deviceInfo.deviceCode ?? "",
        onSuccess: (a) {
          _requestData();
        });
  }
}
