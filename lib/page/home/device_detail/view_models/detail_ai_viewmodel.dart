import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../upgrade/upgrade_viewmodel.dart';

class DetailAiViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  final Function(bool) onChange;
  bool isChange = false;
  final UpgradeViewModel _upgradeViewModel = UpgradeViewModel();

  DetailAiViewModel(this.nodeId, {required this.onChange});

  DeviceDetailAiData deviceInfo = DeviceDetailAiData();

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
    HttpQuery.share.homePageService.deviceDetailAi(
        nodeId: nodeId,
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
  restartAction() async{
    final result = await DialogUtils.showContentDialog(
        context: context!,
        title: "重启主程",
        content: "您确定重启主程?",
        deleteText: "确定");
    if (result == '取消') return;
    HttpQuery.share.homePageService.restartAiDevice(
        ip: deviceInfo.ip ?? "",
        onSuccess: (a) {
          LoadingUtils.showToast(data: "重启成功!");
        });
  }

  //替换
  replaceAction() {
    IntentUtils.share.push(context!, routeName: RouterPage.EditAiPage, data: {
      "data": deviceInfo,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        isChange = true;
        onChange(isChange);
        _requestData();
      }
    });
  }

  //下载主程版本
  downloadProgramAction() async {
    if (deviceInfo.deviceCode != null && deviceInfo.ip != null) {
      _upgradeViewModel.setDeviceInfo(deviceInfo.deviceCode!, deviceInfo.ip!);
      _upgradeViewModel.startDownload(context!, 'program');
    } else {
      LoadingUtils.showToast(data: "设备信息不完整");
    }
  }

  //下载识别版本
  downloadIdentityAction() async {
    if (deviceInfo.deviceCode != null && deviceInfo.ip != null) {
      _upgradeViewModel.setDeviceInfo(deviceInfo.deviceCode!, deviceInfo.ip!);
      _upgradeViewModel.startDownload(context!, 'identity');
    } else {
      LoadingUtils.showToast(data: "设备信息不完整");
    }
  }

  //升级主程版本
  upgradeProgramAction() async {
    if (deviceInfo.deviceCode != null && deviceInfo.ip != null) {
      _upgradeViewModel.setDeviceInfo(deviceInfo.deviceCode!, deviceInfo.ip!);
      _upgradeViewModel.startUpgrade(context!, 'program');
    } else {
      LoadingUtils.showToast(data: "设备信息不完整");
    }
  }

  //升级识别版本
  upgradeIdentityAction() async {
    if (deviceInfo.deviceCode != null && deviceInfo.ip != null) {
      _upgradeViewModel.setDeviceInfo(deviceInfo.deviceCode!, deviceInfo.ip!);
      _upgradeViewModel.startUpgrade(context!, 'identity');
    } else {
      LoadingUtils.showToast(data: "设备信息不完整");
    }
  }
}
