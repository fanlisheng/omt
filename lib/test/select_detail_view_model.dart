import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/foundation/basic_types.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';

import '../page/home/device_add/view_models/device_add_viewmodel.dart';

class SelectDetailViewModel extends BaseViewModelRefresh<dynamic> {
  TextEditingController controller = TextEditingController();

  Map<DeviceType, String> deviceTypeNameMap = {
    DeviceType.ai: "AI设备",
    DeviceType.power: "电源",
    DeviceType.nvr: "NVR",
    DeviceType.powerBox: "电源箱",
    DeviceType.battery: "电池",
    DeviceType.exchange: "交换机",
    DeviceType.camera: "摄像头",
  };

  // 下拉菜单选项列表
  List<String> get deviceTypeList => deviceTypeNameMap.values.toList();

  // 当前选中的设备类型名称
  String _selectedDeviceType = "";

  String get selectedDeviceType => _selectedDeviceType;

  set selectedDeviceType(String value) {
    _selectedDeviceType = value;
    notifyListeners();
  }

  DeviceType? getDeviceTypeFromName(String selectedName) {
    try {
      return deviceTypeNameMap.entries
          .firstWhere((entry) => entry.value == selectedName)
          .key;
    } catch (e) {
      return null; // 如果找不到匹配项，返回 null
    }
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {}
}
