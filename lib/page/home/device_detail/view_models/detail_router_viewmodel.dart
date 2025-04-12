import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_router_entity_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailRouterViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  bool isChange = false;

  DetailRouterViewModel(this.nodeId);

  DeviceDetailRouterData deviceInfo = DeviceDetailRouterData();

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
    HttpQuery.share.homePageService.deviceDetailRouter(
        nodeId: nodeId,
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

  //修改
  editAction() {
    IntentUtils.share
        .push(context!, routeName: RouterPage.EditRouterDevicePage, data: {
      "data": deviceInfo,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        _requestData();
      }
    });
  }
}
