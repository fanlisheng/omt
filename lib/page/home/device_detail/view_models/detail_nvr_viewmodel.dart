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
  final String nodeCode;

  DetailNvrViewModel(this.nodeCode);

  DeviceDetailNvrData deviceInfo = DeviceDetailNvrData();

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
    HttpQuery.share.homePageService.deviceDetailNvr(
        nodeCode: nodeCode,
        onSuccess: (DeviceDetailNvrData? a) {
          deviceInfo = a ?? DeviceDetailNvrData();
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
  removeChannelAction(DeviceDetailNvrDataChannels info) {
    HttpQuery.share.homePageService.deleteNvrChannel(
        deviceCode: deviceInfo.deviceCode ?? "",
        channelIds: [info.id ?? 0],
        onSuccess: (data) {
          LoadingUtils.show(data: "移除成功!");
          _requestData();
        });
  }
}
