import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../remove/widgets/remove_dialog_page.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailNvrViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  final Function(bool) onChange;
  bool isChange = false;

  DetailNvrViewModel(this.nodeId, {required this.onChange});

  DeviceDetailNvrData deviceInfo = DeviceDetailNvrData();

  @override
  void initState() async {
    super.initState();
    requestData();
  }

  void requestData() {
    HttpQuery.share.homePageService.deviceDetailNvr(
        nodeId: nodeId,
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
  //修改
  editAction() {
    IntentUtils.share.push(context!, routeName: RouterPage.EditNvrPage, data: {
      "data": deviceInfo,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        isChange = true;
        onChange(isChange);
        requestData();
      }
    });
  }

  //替换
  replaceAction() {
    IntentUtils.share.push(context!, routeName: RouterPage.EditNvrPage, data: {
      "data": deviceInfo,
      "isReplace": true,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        isChange = true;
        onChange(isChange);
        requestData();
      }
    });
  }

  //删除
  removeAction() {
    RemoveDialogPage.showAndSubmit(
      context: context!,
      instanceId: deviceInfo.instanceId ?? "",
      removeIds: [(deviceInfo.nodeId ?? "0").toInt()],
      onSuccess: () {
        IntentUtils.share.popResultOk(context!);
      },
    );
  }
}
