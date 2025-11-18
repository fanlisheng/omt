import 'dart:async';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/base_view_model.dart';
import 'package:omt/http/http_query.dart';

import '../../../bean/one_picture/one_picture/one_picture_data_entity.dart';
import '../../../generated/json/base/json_convert_content.dart';
import '../../home/device_add/view_models/add_ai_viewmodel.dart';
import '../../home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import '../../home/device_add/view_models/add_camera_viewmodel.dart';
import '../../home/device_add/view_models/add_nvr_viewmodel.dart';
import '../../home/device_add/view_models/add_power_box_viewmodel.dart';
import '../../../bean/common/id_name_value.dart';
import '../../home/device_add/view_models/add_power_viewmodel.dart';
import '../../one_picture/one_picture/one_picture_page.dart';
import '../../../utils/device_utils.dart';

class PreviewViewModel extends BaseViewModel {
  OnePictureDataData? onePictureDataData;

  final GlobalKey<OnePicturePageState> picturePageKey = GlobalKey();

  // 处理所有viewModel数据并构建 OnePictureDataData 对象
  void buildPreviewData({
    required StrIdNameValue? selectedInstance,
    required IdNameValue? selectedDoor,
    // required IdNameValue? selectedInOut,
    required AddAiViewModel aiViewModel,
    required AddCameraViewModel cameraViewModel,
    required AddNvrViewModel nvrViewModel,
    required AddPowerBoxViewModel powerBoxViewModel,
    required AddPowerViewModel powerViewModel,
  }) {
    if (selectedInstance == null || selectedDoor == null) {
      return;
    }

    try {
      Map<String, dynamic> powersMap =
          AddPowerViewModel.getPowersMap(powerViewModel);
      Map<String, dynamic>? powerBoxes =
          AddPowerBoxViewModel.getPowerBoxes(powerBoxViewModel);
      Map<String, dynamic> network =
          AddPowerViewModel.getNetwork(powerViewModel);
      Map<String, dynamic>? nvr = AddNvrViewModel.getNvr(nvrViewModel);
      List<Map<String, dynamic>> routers = [];
      List<Map<String, dynamic>> wiredNetworks = [];
      if (network["type"] == 6) {
        routers.add(network);
      } else {
        wiredNetworks.add(network);
      }

      HttpQuery.share.installService.installPreview(
          instanceId: selectedInstance.id ?? "",
          gateId: selectedDoor.id ?? 0,
          powers: [powersMap],
          powerBoxes: powerBoxes != null ? [powerBoxes] : [],
          routers: routers,
          wiredNetworks: wiredNetworks,
          nvrs: nvr != null ? [nvr] : [],
          switches: AddPowerViewModel.getSwitches(powerViewModel),
          onSuccess: (data) {
            onePictureDataData = data;
            notifyListeners();
            
            // OnePicturePage 的内部状态不会自动响应外部数据变化
            // 必须通过 refreshWithData 主动通知它更新
            // 使用 scheduleMicrotask 在下一个事件循环中调用，确保 UI 已经重建
            Future.microtask(() {
              if (picturePageKey.currentState != null && onePictureDataData != null) {
                picturePageKey.currentState?.refreshWithData(data: onePictureDataData);
              }
            });
          });
    } catch (e) {
      print("Error building OnePictureDataData: $e");
    }
  }

  // 清除预览数据，用于重置页面
  void clearPreviewData() {
    // 清空数据
    onePictureDataData = null;

    // 通知UI更新
    notifyListeners();

    // 延迟一点时间确保UI能够更新
    Timer(Duration(milliseconds: 100), () {
      // 确保OnePicturePage的状态存在
      if (picturePageKey.currentState != null) {
        picturePageKey.currentState?.clearData();
      }

      // 再次通知UI更新
      notifyListeners();
    });
  }

  /// 获取设备统计信息
  /// 返回格式：1个电池 / 1个电源箱 / 2个路由器 / 2个交换机 / 2个AI设备 / 2个摄像头 / 1个NVR
  String getDeviceStatistics() {
    if (onePictureDataData == null) {
      return '暂无设备';
    }

    // 统计各类设备数量，使用Set去重
    Map<int, int> deviceCounts = {};
    Set<String> countedNodes = {}; // 记录已统计的节点，使用node_code去重
    _countDevices(onePictureDataData!, deviceCounts, countedNodes);

    if (deviceCounts.isEmpty) {
      return '暂无设备';
    }

    // 直接遍历统计结果
    List<String> statistics = [];
    deviceCounts.forEach((deviceType, count) {
      // 通过 intToDeviceTypeMap + _deviceTypeNameMap 获取名称
      String name = DeviceUtils.getDeviceTypeNameByInt(deviceType);
      statistics.add('$count个$name');
    });

    return '${statistics.join('  /  ')}';
  }

  /// 递归统计设备数量
  void _countDevices(OnePictureDataData data, Map<int, int> counts, Set<String> countedNodes) {
    // 使用 node_code 作为唯一标识，避免重复统计
    String nodeKey = data.nodeCode ?? '';
    
    // 如果节点已经统计过，直接返回
    if (nodeKey.isNotEmpty && countedNodes.contains(nodeKey)) {
      return;
    }
    
    // 统计当前节点
    if (data.type != null && _isCountableDevice(data.type!)) {
      counts[data.type!] = (counts[data.type!] ?? 0) + 1;
      // 标记该节点已统计
      if (nodeKey.isNotEmpty) {
        countedNodes.add(nodeKey);
      }
    }

    // 递归统计子节点
    if (data.children.isNotEmpty) {
      for (var child in data.children) {
        _countDevices(child, counts, countedNodes);
      }
    }

    // 递归统计 nextList
    if (data.nextList.isNotEmpty) {
      for (var next in data.nextList) {
        _countDevices(next, counts, countedNodes);
      }
    }
  }

  /// 判断是否是需要统计的设备类型
  bool _isCountableDevice(int type) {
    // 使用 DeviceUtils.countableDeviceTypes 判断
    return DeviceUtils.countableDeviceTypes.contains(type);
  }


}
