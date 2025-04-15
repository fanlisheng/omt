import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../remove/widgets/remove_dialog_page.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../../device_add/widgets/power_box_bind_device_dialog_page.dart';

class DetailPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;
  final Function(bool) onChange;
  bool isChange = false;

  DetailPowerBoxViewModel(this.nodeId, {required this.onChange});

  bool isPowerBoxNeeded = false;

  DeviceDetailPowerBoxData deviceInfo = DeviceDetailPowerBoxData();

  bool isCloseAllDc = true; //关闭全部dc

  @override
  void initState() async {
    super.initState();
    requestData();
  }

  void requestData() {
    HttpQuery.share.homePageService.deviceDetailPowerBox(
        nodeId: nodeId,
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

  restartAction() {
    HttpQuery.share.homePageService.restartPowerBox(
        deviceCode: deviceInfo.deviceCode ?? "",
        onSuccess: (a) {
          LoadingUtils.show(data: "重启成功!");
        });
  }

  //打开所有DC
  openDcAllAction() {
    List<int> ids = [];
    for (DeviceDetailPowerBoxDataDcInterfaces a
        in deviceInfo.dcInterfaces ?? []) {
      ids.add(a.id ?? 0);
    }
    HttpQuery.share.homePageService.dcInterfaceControl(
        deviceCode: deviceInfo.deviceCode ?? "",
        ids: ids,
        status: isCloseAllDc ? 1 : 2,
        onSuccess: (data) {
          isCloseAllDc = false;
          LoadingUtils.show(data: "${isCloseAllDc ? "关闭" : "打开"}成功!");
          requestData();
        });
  }

  // openDcAction(DeviceDetailPowerBoxDataDcInterfaces a) {
  //   HttpQuery.share.homePageService.dcInterfaceControl(
  //       deviceCode: deviceInfo.deviceCode ?? "",
  //       ids: [a.id ?? 0],
  //       status: a.statusText == "打开" ? 1 : 2,
  //       onSuccess: (data) {
  //         LoadingUtils.show(data: "${(a.statusText == "打开") ? "关闭" : "打开"}成功!");
  //         _requestData();
  //       });
  // }

  //记录 （绑定设备）
  // void recordDeviceAction(DeviceDetailPowerBoxDataDcInterfaces a) {
  //   PowerBoxBindDeviceDialogPage.showAndSubmit(
  //       context: context!,
  //       deviceCode: deviceInfo.deviceCode ?? "",
  //       dcId: a.id ?? 0,
  //       onSuccess: () {
  //         LoadingUtils.show(data: "记录成功!");
  //         requestData();
  //       });
  // }

  //修改
  editAction() {
    // IntentUtils.share
    //     .push(context!, routeName: RouterPage.EditPowerBoxPage, data: {
    //   "data": deviceInfo,
    // })?.then((value) {
    //   if (IntentUtils.share.isResultOk(value)) {
    //     isChange = true;
    //     onChange(isChange);
    //     _requestData();
    //   }
    // });
  }

  //替换
  replaceAction() {
    IntentUtils.share
        .push(context!, routeName: RouterPage.EditPowerBoxPage, data: {
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
