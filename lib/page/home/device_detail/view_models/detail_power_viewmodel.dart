import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/intent_utils.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../remove/view_models/remove_viewmodel.dart';
import '../../../remove/widgets/remove_dialog_page.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailPowerViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  bool isChange = false;

  DetailPowerViewModel(this.nodeId);

  DeviceDetailPowerData deviceInfo = DeviceDetailPowerData();

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
    HttpQuery.share.homePageService.deviceDetailPower(
        nodeId: nodeId,
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

  //修改
  editAction() {
    IntentUtils.share
        .push(context!, routeName: RouterPage.EditPowerPage, data: {
      "data": deviceInfo,
    })?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        _requestData();
        isChange = true;
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
