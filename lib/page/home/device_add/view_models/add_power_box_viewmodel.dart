import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_power_box_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';

class AddPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  // 父节点code
  final String pNodeCode;
  final bool isInstall; //是安装 默认否

  AddPowerBoxViewModel(this.pNodeCode, {this.isInstall = false});

  // ===== 电源箱相关属性 =====
  IdNameValue? selectedPowerBoxInOut;
  DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox;
  bool isPowerBoxNeeded = true;
  List<DeviceDetailPowerBoxData> powerBoxList = [];
  List<IdNameValue> inOutList = [];
  // String powerBoxMemo = "";
  // final TextEditingController powerBoxMemoController = TextEditingController();

  @override
  void initState() async {
    super.initState();
    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        notifyListeners();
      },
    );
    // 初始化电源箱列表
    HttpQuery.share.installService.getUnboundPowerBox(
      onSuccess: (List<DeviceDetailPowerBoxData>? data) {
        powerBoxList = data ?? [];
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    // powerBoxMemoController.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  //选择电源箱code
  selectedPowerBoxCode(DeviceDetailPowerBoxData? a) {
    if (a == null) return;
    
    HttpQuery.share.homePageService.deviceDetailPowerBox(
        deviceCode: a.deviceCode ?? "",
        onSuccess: (data) {
          selectedDeviceDetailPowerBox = a;
          selectedDeviceDetailPowerBox?.dcInterfaces = data?.dcInterfaces ?? [];
          notifyListeners();
        });
  }

  // 安装电源箱
  void installPowerBox() {
    // 检查是否已选择电源箱
    if (selectedPowerBoxInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }
    if (selectedDeviceDetailPowerBox?.deviceCode == null) {
      LoadingUtils.showToast(data: '请先选择电源箱');
      return;
    }

    HttpQuery.share.installService.powerBoxInstall(
        pNodeCode: pNodeCode,
        deviceCode: selectedDeviceDetailPowerBox!.deviceCode!,
        passId: selectedPowerBoxInOut!.id!,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '电源箱安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '电源箱安装失败: $error');
        });

  }
}
