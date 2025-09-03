import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/page/home/device_add/view_models/add_power_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_router_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';

class MissingDeviceAddViewModel extends BaseViewModelRefresh<dynamic> {
  final List<String> missingDevices;
  final String pNodeCode;
  final int gateId;
  final String instanceId;

  MissingDeviceAddViewModel({
    required this.missingDevices,
    required this.pNodeCode,
    required this.gateId,
    required this.instanceId,
  });

  // 判断需要添加的设备类型
  bool get needsPowerDevice => missingDevices.contains("电源信息");
  bool get needsNetworkDevice => missingDevices.contains("网络信息");
  bool get needsSwitchDevice => missingDevices.contains("交换机信息");

  bool isLoading = false;

  // 子ViewModels引用
  AddPowerViewModel? _powerViewModel;
  AddRouterViewModel? _routerViewModel;
  AddBatteryExchangeViewModel? _exchangeViewModel;

  // Setter方法
  void setPowerViewModel(AddPowerViewModel? viewModel) {
    _powerViewModel = viewModel;
  }

  void setRouterViewModel(AddRouterViewModel? viewModel) {
    _routerViewModel = viewModel;
  }

  void setExchangeViewModel(AddBatteryExchangeViewModel? viewModel) {
    _exchangeViewModel = viewModel;
  }

  @override
  void initState() async {
    super.initState();
    // 子ViewModels会自己初始化数据
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    // 网络请求
  }


  // 返回上一页
  void goBackEventAction() {
    LoadingUtils.dismiss();
    IntentUtils.share.pop(context!);
  }

  // 提交设备信息
  void submitDeviceInfo() {
    if (!_validateInputs()) {
      return;
    }

    isLoading = true;
    notifyListeners();
    _callInstallStep2();
  }

  // 验证输入
  bool _validateInputs() {
    if (needsPowerDevice && _powerViewModel != null) {
      if (_powerViewModel!.selectedPowerInOut?.id == null) {
        LoadingUtils.showToast(data: '请选择电源设备的进出口');
        return false;
      }
      if (!_powerViewModel!.batteryMains && !_powerViewModel!.battery) {
        LoadingUtils.showToast(data: '请选择接电方式');
        return false;
      }
    }

    if (needsNetworkDevice && _routerViewModel != null) {
      if (_routerViewModel!.routerIpController.text.isEmpty) {
        LoadingUtils.showToast(data: '没有识别到路由器');
        return false;
      }
      if (_routerViewModel!.selectedRouterInOut?.id == null || _routerViewModel!.selectedRouterType?.id == null) {
        LoadingUtils.showToast(data: '请选择网络设备的进出口/有线无线类型');
        return false;
      }
    }

    if (needsSwitchDevice && _exchangeViewModel != null) {
      if (_exchangeViewModel!.selectedInOut?.id == null) {
        LoadingUtils.showToast(data: '请选择交换机进出口');
        return false;
      }
      if (_exchangeViewModel!.selectedPortNumber == null || _exchangeViewModel!.selectedSupplyMethod == null) {
        LoadingUtils.showToast(data: '请选择交换机接口数量和供电方式');
        return false;
      }
    }

    return true;
  }

  // 调用installStep2接口
  void _callInstallStep2() {
    List<Map<String, dynamic>> powers = [];
    List<Map<String, dynamic>> powerBoxes = [];
    List<Map<String, dynamic>> routers = [];
    List<Map<String, dynamic>> wiredNetworks = [];
    List<Map<String, dynamic>> nvrs = [];
    List<Map<String, dynamic>> switches = [];

    // 构建电源设备数据
    if (needsPowerDevice) {
      powers.add(_buildPowerData());
    }

    // 构建网络设备数据
    if (needsNetworkDevice) {
      routers.add(_buildNetworkData());
    }

    // 构建交换机设备数据
    if (needsSwitchDevice) {
      switches = _buildSwitchData();
    }


    // 调用installStep2接口
    HttpQuery.share.installService.installStep2(
      instanceId: instanceId,
      gateId: gateId,
      powers: powers,
      powerBoxes: powerBoxes,
      routers: routers,
      wiredNetworks: wiredNetworks,
      nvrs: nvrs,
      switches: switches,
      onSuccess: (data) {
        isLoading = false;
        notifyListeners();
        LoadingUtils.showToast(data: '设备信息提交成功');
        // 返回绑定界面
        IntentUtils.share.popResultOk(context!);
      },
      onError: (error) {
        isLoading = false;
        notifyListeners();
        LoadingUtils.showToast(data: '设备信息提交失败: $error');
      },
    );
  }

  // 构建电源设备数据
  Map<String, dynamic> _buildPowerData() {
    if (_powerViewModel == null) return {};
    return AddPowerViewModel.getPowersMap(_powerViewModel!);
  }

  // 构建网络设备数据
  Map<String, dynamic> _buildNetworkData() {
    if (_routerViewModel == null) return {};
    return {
      "ip": _routerViewModel!.routerIpController.text,
      "type": _routerViewModel!.selectedRouterType!.id!,
      "mac": _routerViewModel!.mac!,
      "pass_id": _routerViewModel!.selectedRouterInOut!.id!,
    };
  }

  // 构建交换机设备数据
  List<Map<String, dynamic>> _buildSwitchData() {
    if (_exchangeViewModel == null) return [];
    return [{
      "interface_num": int.parse(_exchangeViewModel!.selectedPortNumber!),
      "power_method": _exchangeViewModel!.selectedSupplyMethod!,
      "pass_id": _exchangeViewModel!.selectedInOut!.id!,
    }];
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