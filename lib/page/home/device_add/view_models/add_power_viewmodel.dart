import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';

class AddPowerViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;
  final bool isInstall; //是安装 默认否

  AddPowerViewModel(this.pNodeCode, {this.isInstall = false});

  // ===== 电源设备相关属性 =====
  String portType = "";
  bool batteryMains = false; //市电
  bool battery = false; //电池
  bool isCapacity80 = true; // 电池容量是否为80
  IdNameValue? selectedPowerInOut;
  List<IdNameValue> inOutList = [];

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  // 确认电源类型
  confirmPowerEventAction() {
    if (portType.isNotEmpty && (battery || batteryMains)) {
      // 执行操作
    }
  }

  // 安装电源信息
  installPower() {
    // 电源需要检查参数
    if (selectedPowerInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }
    if (batteryMains == false && battery == false) {
      LoadingUtils.showToast(data: '请选择电源类型');
      return;
    }

    // 执行电源安装
    HttpQuery.share.installService.powerInstall(
      pNodeCode: pNodeCode,
      hasBatteryMains: batteryMains,
      type: selectedPowerInOut!.id!,
      batteryCap: battery == false ? null : (isCapacity80 ? 80 : 160),
      onSuccess: (data) {
        LoadingUtils.showToast(data: '电源信息安装成功');
        IntentUtils.share.popResultOk(context!);
      },
      onError: (error) {
        LoadingUtils.showToast(data: '电源信息安装失败: $error');
      },
    );
  }
} 