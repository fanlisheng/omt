import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';

class AddRouterViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;
  final bool isInstall; //是安装 默认否

  AddRouterViewModel(this.pNodeCode, {this.isInstall = false});

  // ===== 路由器相关属性 =====
  IdNameValue? selectedRouterType;
  IdNameValue? selectedRouterInOut;
  List<IdNameValue> inOutList = [];
  List<IdNameValue> routerTypeList = [];
  TextEditingController routerIpController = TextEditingController();
  String? mac;

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

    routerTypeList = [
      IdNameValue(id: 6, name: "无线"),
      IdNameValue(id: 7, name: "有线")
    ];

    // 获取当前子网的默认网关
    LoadingUtils.show(data: "获取路由中...");
    String? subnet = await DeviceUtils.getSubnet();
    if (null != subnet && subnet.isNotEmpty) {
      subnet = '$subnet.1';
      mac = await DeviceUtils.getMacAddressByIp(ip: subnet);
      LoadingUtils.dismiss();
      if (mac != null) {
        routerIpController.text = subnet;
      }else{
        LoadingUtils.showToast(data: "获取路由信息失败！");
      }

    }

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

  // 安装路由器
  void installRouter() {
    // 检查参数
    if (routerIpController.text.isEmpty) {
      LoadingUtils.showToast(data: '没有识别到路由器');
      return;
    }

    // 路由器需要检查参数
    if (selectedRouterInOut?.id == null || selectedRouterType?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口/有线无线类型');
      return;
    }

    // 执行路由器安装
    HttpQuery.share.installService.routerInstall(
      pNodeCode: pNodeCode,
      ip: routerIpController.text,
      mac: mac!,
      type: selectedRouterType!.id!,
      passId: selectedRouterInOut!.id!,
      onSuccess: (data) {
        LoadingUtils.showToast(data: '路由器安装成功');
        IntentUtils.share.popResultOk(context!);
      },
      onError: (error) {
        LoadingUtils.showToast(data: '路由器安装失败: $error');
      },
    );
  }
}
