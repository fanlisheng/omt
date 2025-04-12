import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';

import '../../../../bean/home/home_page/device_detail_router_entity_entity.dart';

class EditRouterViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceDetailRouterData deviceInfo;

  EditRouterViewModel(this.deviceInfo);

  // ===== 路由器相关属性 =====
  IdNameValue? selectedRouterType;
  IdNameValue? selectedRouterInOut;
  List<IdNameValue> inOutList = [];
  List<IdNameValue> routerTypeList = [];
  TextEditingController routerIpController = TextEditingController();

  @override
  void initState() async {
    super.initState();
    // 初始化数据
    routerIpController.text = deviceInfo.ip ?? "";

    routerTypeList = [
      IdNameValue(id: 6, name: "无线"),
      IdNameValue(id: 7, name: "有线")
    ];
    if (deviceInfo.typeText == "有线网络") {
      selectedRouterType =
          routerTypeList.firstWhere((entry) => entry.name == "有线");
    } else if (deviceInfo.typeText == "路由器") {
      selectedRouterType =
          routerTypeList.firstWhere((entry) => entry.name == "无线");
    }

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        // 设置当前选中的进出口
        for (var entry in inOutList) {
          if (entry.name == deviceInfo.passName) {
            selectedRouterInOut = entry;
            break;
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    routerIpController.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  // 保存路由器编辑
  void saveRouterEdit() {
    // 检查参数
    // 路由器需要检查参数
    if (selectedRouterInOut?.id == null || selectedRouterType?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口/有线无线类型');
      return;
    }
    if (routerIpController.text.isEmpty) {
      LoadingUtils.showToast(data: '没有识别到路由器');
      return;
    }

    HttpQuery.share.homePageService.editRouter(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        passId: selectedRouterInOut!.id ?? 0,
        onSuccess: (result) {
          LoadingUtils.showToast(data: "修改信息成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }
}
