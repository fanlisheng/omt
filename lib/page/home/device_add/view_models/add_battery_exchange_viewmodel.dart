import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';

class AddBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;
  final bool isInstall;
  final bool isBattery;

  AddBatteryExchangeViewModel(this.pNodeCode,
      {this.isInstall = false, this.isBattery = false});

  // ===== 电池/交换机相关属性 =====
  bool isCapacity80 = true;
  List<String> portNumber = ["5", "8"];
  String? selectedPortNumber;
  List<String> supplyMethod = ["POE", "DC", "AC"];
  String? selectedSupplyMethod;
  IdNameValue? selectedInOut;
  List<IdNameValue> inOutList = [];

  @override
  void initState() {
    super.initState();
    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  // 安装交换机
  installSwitch() {
    // 检查参数
    if (selectedInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }
    if (selectedPortNumber == null || selectedSupplyMethod == null) {
      LoadingUtils.showToast(data: '请选择交换机接口数量和供电方式');
      return;
    }

    // 执行交换机安装
    HttpQuery.share.installService.switchInstall(
        pNodeCode: pNodeCode,
        interfaceNum: int.parse(selectedPortNumber!),
        powerMethod: selectedSupplyMethod!,
        passId: selectedInOut!.id!,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '交换机安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '交换机安装失败: $error');
        });
  }

  // 安装电池
  void installBattery() {
    // 检查参数
    // if (selectedInOut?.id == null) {
    //   LoadingUtils.showToast(data: '请选择进出口');
    //   return;
    // }
    //
    // // 执行电池安装
    // HttpQuery.share.installService.batteryInstall(
    //   pNodeCode: pNodeCode,
    //   type: selectedInOut!.id!,
    //   memo: memoController.text,
    //   onSuccess: (data) {
    //     LoadingUtils.showToast(data: '电池安装成功');
    //     IntentUtils.share.popResultOk(context!);
    //   },
    //   onError: (error) {
    //     LoadingUtils.showToast(data: '电池安装失败: $error');
    //   },
    // );
  }
}
