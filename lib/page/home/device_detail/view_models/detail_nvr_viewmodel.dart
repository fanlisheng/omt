import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailNvrViewModel extends BaseViewModelRefresh<dynamic> {
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});

  DeviceDetailNvrData deviceInfo = DeviceDetailNvrData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailNvr(
        nodeCode: "562#6175-2#2-4#1",
        onSuccess: (DeviceDetailNvrData? a) {
          deviceInfo = a ?? DeviceDetailNvrData();

          // for (DeviceDetailNvrDataChannels channel in deviceInfo.channels ?? []) {
          //   nvrInfo.add({})
          // }
          deviceInfo.channels = [
            DeviceDetailNvrDataChannels(
                channelNum: 1,
                recordStatus: "正在录像",
                signalStatus: "正常",
                updatedAt: "2024-09-25 10:22:34"),
            DeviceDetailNvrDataChannels(
                channelNum: 2,
                recordStatus: "录像异常",
                signalStatus: "正常",
                updatedAt: "2024-09-25 10:22:34"),
            DeviceDetailNvrDataChannels(
                channelNum: 3,
                recordStatus: "未录像",
                signalStatus: "正常",
                updatedAt: "2024-09-25 10:22:34"),
            DeviceDetailNvrDataChannels(
                channelNum: 4,
                recordStatus: "未录像",
                signalStatus: "正常",
                updatedAt: "2024-09-25 10:22:34"),
          ];
          notifyListeners();
        });
  }

  @override
  void dispose() {}

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///点击事件
  //移除通道
  removeChannelAction(DeviceDetailNvrDataChannels info) {
    notifyListeners();
  }
}
