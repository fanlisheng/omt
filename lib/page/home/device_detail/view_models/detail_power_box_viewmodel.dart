import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeCode;

  DetailPowerBoxViewModel(this.nodeCode);

  String selectedPowerBoxCoding = "";
  List powerBoxCodingList = ["1", "2"];

  bool isPowerBoxNeeded = false;

  DeviceDetailPowerBoxData deviceInfo = DeviceDetailPowerBoxData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailPowerBox(
        nodeCode: nodeCode,
        onSuccess: (DeviceDetailPowerBoxData? a) {
          deviceInfo = a ?? DeviceDetailPowerBoxData();
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

  //
  changeDeviceStateAction(info) {
    notifyListeners();
  }

  recordDeviceAction(info) {
    notifyListeners();
  }
}
