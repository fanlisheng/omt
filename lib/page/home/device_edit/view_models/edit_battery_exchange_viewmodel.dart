import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';

import '../../../../bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../http/http_query.dart';

class EditBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;
  final DeviceDetailExchangeData deviceInfo;
  final bool isBattery;

  EditBatteryExchangeViewModel(this.pNodeCode, this.deviceInfo,
      {this.isBattery = false});

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
    // 初始化数据
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  // 保存编辑的交换机信息
  void saveExchangeEdit() {
    // 检查参数
    if (selectedInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }
    if (selectedPortNumber == null || selectedSupplyMethod == null) {
      LoadingUtils.showToast(data: '请选择交换机接口数量和供电方式');
      return;
    }

    LoadingUtils.show(data: "保存中...");

    HttpQuery.share.homePageService.editSwitch(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        passId: selectedInOut!.id ?? 0,
        interfaceNum: int.parse(selectedPortNumber!),
        powerMethod: selectedSupplyMethod!,
        onSuccess: (result) {
          LoadingUtils.dismiss();
          LoadingUtils.showToast(data: "编辑保存成功");

          // 更新后退出
          if (context != null) {
            Navigator.of(context!).pop(true);
          }
        },
        onError: (error) {
          LoadingUtils.dismiss();
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }

  // 保存电池编辑
  void saveBatteryEdit() {
    // 检查参数
    if (selectedInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }

    // TODO: 实现保存编辑后的电池信息的API调用
    LoadingUtils.show(data: "保存中...");

    // 这里添加保存电池编辑的API调用
    // 例如：HttpQuery.share.editService.editBattery(...)

    LoadingUtils.dismiss();
    LoadingUtils.showToast(data: "编辑保存成功");
  }
}
