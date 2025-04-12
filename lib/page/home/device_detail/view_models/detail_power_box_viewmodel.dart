import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/intent_utils.dart';
import '../../../remove/widgets/remove_dialog_page.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DetailPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;

  DetailPowerBoxViewModel(this.nodeId);

  String selectedPowerBoxCoding = "";
  List powerBoxCodingList = ["1", "2"];

  bool isPowerBoxNeeded = false;

  DeviceDetailPowerBoxData deviceInfo = DeviceDetailPowerBoxData();

  bool isCloseAllDc = true; //关闭全部dc

  @override
  void initState() async {
    super.initState();
    _requestData();
  }

  void _requestData() {
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
  changeDeviceStateAction(info) {
    notifyListeners();
  }

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
          _requestData();
        });
  }

  openDcAction(DeviceDetailPowerBoxDataDcInterfaces a) {
    HttpQuery.share.homePageService.dcInterfaceControl(
        deviceCode: deviceInfo.deviceCode ?? "",
        ids: [a.id ?? 0],
        status: a.statusText == "打开" ? 1 : 2,
        onSuccess: (data) {
          LoadingUtils.show(data: "${(a.statusText == "打开") ? "关闭" : "打开"}成功!");
          _requestData();
        });
  }

  //修改
  editAction(){

  }

  //替换
  replaceAction(){

  }

  //删除
  removeAction(){
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
