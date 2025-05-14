import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';

import '../../../../utils/device_utils.dart';

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

  // ===== 路由相关设备相关属性 =====
  IdNameValue? selectedRouterType;
  List<IdNameValue> routerTypeList = [];
  TextEditingController routerIpController = TextEditingController();
  String? mac;

  // ===== 交换机设备相关属性 =====
  List<String> portNumber = ["5", "8"];
  List<String> supplyMethod = ["POE", "DC", "AC"];
  final List<ExchangeDeviceModel> exchangeDevices = [ExchangeDeviceModel()];
  IdNameValue? selectedInOut;

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

    if (isInstall) {
      // 获取当前子网的默认网关
      LoadingUtils.show(data: "获取路由中...");
      String? subnet = await DeviceUtils.getSubnet();
      if (null != subnet && subnet.isNotEmpty) {
        subnet = '$subnet.1';
        mac = await DeviceUtils.getMacAddressByIp(ip: subnet);
        LoadingUtils.dismiss();
        if (mac != null) {
          routerIpController.text = subnet;
        } else {
          LoadingUtils.showToast(data: "获取路由信息失败！");
        }
      }

      routerTypeList = [
        IdNameValue(id: 6, name: "无线"),
        IdNameValue(id: 7, name: "有线")
      ];
    }
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

  void addExchangeAction() {
    if ((exchangeDevices.last.selectedPortNumber?.isNotEmpty ?? false) &&
        (exchangeDevices.last.selectedSupplyMethod?.isNotEmpty ?? false)) {
      exchangeDevices.add(ExchangeDeviceModel());
      notifyListeners();
    } else {
      LoadingUtils.showInfo(data: "请完善上一个交换机信息！");
    }
  }

  void removeExchangeAction() {
    if (exchangeDevices.length > 1) {
      exchangeDevices.removeLast();
      notifyListeners();
    } else {
      LoadingUtils.showInfo(data: "至少要保留一个交换机！");
    }
  }

  // 安装电源信息
  installPower() {
    if (checkSelection() == false) {
      return;
    }

    // 执行电源安装
    HttpQuery.share.installService.powerInstall(
      pNodeCode: pNodeCode,
      hasBatteryMains: batteryMains,
      passId: selectedPowerInOut!.id!,
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

  //检查
  bool checkSelection() {
    if (selectedPowerInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return false;
    }
    if (batteryMains == false && battery == false) {
      LoadingUtils.showToast(data: '请选择接电方式');
      return false;
    }
    return true;
  }

  //检查
  bool checkNetworkSelection() {
    // 检查参数
    if (routerIpController.text.isEmpty) {
      LoadingUtils.showToast(data: '没有识别到路由器');
      return false;
    }

    // 路由器需要检查参数
    if (selectedRouterType?.id == null || selectedRouterType?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口/有线无线类型');
      return false;
    }
    return true;
  }

  //检查
  bool checkExchangeSelection() {
    for (ExchangeDeviceModel exchange in exchangeDevices) {
      if ((exchange.selectedSupplyMethod?.isEmpty ?? true) ||
          (exchange.selectedPortNumber?.isEmpty ?? true)) {
        LoadingUtils.showToast(data: '请完善各个交换机的信息');
        return false;
      }
    }
    return true;
  }

  static Map<String, dynamic> getPowersMap(AddPowerViewModel powerViewModel) {
    List<int> items = [];
    int? batteryCap = (powerViewModel.battery == false)
        ? null
        : (powerViewModel.isCapacity80 ? 80 : 160);

    if (powerViewModel.batteryMains) {
      items.add(1);
    }
    if (batteryCap != null) {
      items.add(2);
    }
    Map<String, dynamic> params = {
      "PowerType": items,
      "pass_id": powerViewModel.selectedPowerInOut!.id!,
    };
    if (batteryCap != null) {
      params["battery_capacity"] = batteryCap;
    }
    return params;
  }

  static Map<String, dynamic> getNetwork(AddPowerViewModel powerViewModel) {
    int passId = powerViewModel.selectedPowerInOut!.id!;
    int type = powerViewModel.selectedRouterType!.id!;
    String mac = powerViewModel.mac!;
    String ip = powerViewModel.routerIpController.text;

    Map<String, dynamic> params = {
      "ip": ip,
      "type": type,
      "mac": mac,
      "pass_id": passId,
    };
    return params;
  }

  static List<Map<String, dynamic>> getSwitches(AddPowerViewModel powerViewModel) {
    List<Map<String, dynamic>> paramsList = [];
    for (ExchangeDeviceModel exchange in powerViewModel.exchangeDevices) {
      Map<String, dynamic> params = {
        "interface_num": exchange.selectedPortNumber.toInt(),
        "power_method": exchange.selectedSupplyMethod,
        "pass_id": powerViewModel.selectedPowerInOut?.id,
      };
      paramsList.add(params);
    }

    return paramsList;
  }
}



class ExchangeDeviceModel extends ChangeNotifier {
  String? selectedPortNumber;
  String? selectedSupplyMethod;

  void updatePortNumber(String? value) {
    selectedPortNumber = value;
    notifyListeners();
  }

  void updateSupplyMethod(String? value) {
    selectedSupplyMethod = value;
    notifyListeners();
  }
}
