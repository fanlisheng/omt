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
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});

  DeviceDetailAiData deviceInfo = DeviceDetailAiData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailAi(
        nodeCode: "562#6175-2#2-4#1",
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
}
