import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_router_entity_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailRouterViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeCode;
  DetailRouterViewModel(this.nodeCode);

  DeviceDetailRouterData deviceInfo = DeviceDetailRouterData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailRouter(
        nodeCode: nodeCode,
        onSuccess: (DeviceDetailRouterData? a) {
          deviceInfo = a ?? DeviceDetailRouterData();
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
