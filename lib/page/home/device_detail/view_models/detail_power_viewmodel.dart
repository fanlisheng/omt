import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailPowerViewModel extends BaseViewModelRefresh<dynamic> {
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});


  DeviceDetailPowerData deviceInfo = DeviceDetailPowerData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailPower(
        nodeCode: "562#6175-2#2-4#1",
        onSuccess: (DeviceDetailPowerData? a) {
          deviceInfo = a ?? DeviceDetailPowerData();
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
}
