import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/sys_utils.dart';

import '../../../../utils/intent_utils.dart';
import '../../search_device/services/device_search_service.dart';

import '../../search_device/services/device_search_service.dart';

class EditAiViewModel extends BaseViewModel {
  final DeviceDetailAiData deviceInfo;

  EditAiViewModel(this.deviceInfo);

  // ===== AI设备相关属性 =====
  List<DeviceDetailAiData> aiDeviceList = [DeviceDetailAiData()];
  List<TextEditingController> aiControllers = [TextEditingController()];
  bool isAiSearching = false;
  String? selectedAiIp;
  List<DeviceEntity> aiSearchResults = [];
  bool stopAiScanning = false;

  @override
  void initState() {
    super.initState();
    // 初始化AI设备列表和控制器
    // aiDeviceList = [deviceInfo];
    // aiControllers = [TextEditingController(text: deviceInfo.ip)];
  }

  @override
  void dispose() {
    // 销毁所有控制器
    for (var controller in aiControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 连接AI设备
  connectAiDeviceAction(int index) async {
    if (SysUtils.isIPAddress(aiControllers[index].text)) {
      //获取到mac
      LoadingUtils.show(data: "连接设备中...");
      String? mac = await DeviceUtils.getMacAddressByIp(
          ip: aiControllers[index].text,
          shouldStop: () {
            return false;
          });
      if (mac == null) {
        LoadingUtils.showToast(data: '该设备不在线');
        return;
      }
      //请求设备信息
      String deviceCode =
          DeviceUtils.getDeviceCodeByMacAddress(macAddress: mac);
      HttpQuery.share.homePageService.deviceDetailAi(
          deviceCode: deviceCode,
          onSuccess: (DeviceDetailAiData? data) {
            if (data != null) {
              data.mac = mac;
              data.ip = aiControllers[index].text;
              //只有一个
              aiDeviceList = [data];
            }
            notifyListeners();
            LoadingUtils.dismiss;
          });
    } else {
      LoadingUtils.showToast(data: '请输入正确的IP地址');
    }
  }

  // 开始搜索AI设备
  void startAiSearch() async {
    isAiSearching = true;
    aiSearchResults.clear();
    selectedAiIp = null;
    notifyListeners();
    // 扫描设备
    List<DeviceEntity> searchDevices = await DeviceSearchService()
        .scanDevices(shouldStop: _shouldStopAi, deviceType: "AI设备");
    if (_shouldStopAi()) {
      stopAiSearch();
      return;
    }
    List<DeviceEntity> aiDevices =
        searchDevices.where((device) => device.deviceType == 10).toList();
    // 搜索完成后调用：
    aiSearchResults = List.from(aiDevices); // 设置搜索结果
    isAiSearching = false;
    notifyListeners();
  }

  // 停止搜索AI设备
  void stopAiSearch() {
    isAiSearching = false;
    notifyListeners();
  }

  // 处理选中的AI设备IP
  void handleSelectedAiIp() {
    if (selectedAiIp != null) {
      // 将选中的IP填入第一个空的或新的输入框
      int targetIndex =
          aiControllers.indexWhere((controller) => controller.text.isEmpty);
      if (targetIndex == -1) {
        // 使用第一个输入框
        aiControllers[0].text = selectedAiIp!;
      } else {
        aiControllers[targetIndex].text = selectedAiIp!;
      }

      // 自动触发连接
      connectAiDeviceAction(targetIndex == -1 ? 0 : targetIndex);
    }
  }

  // 定义一个停止条件的回调函数
  bool _shouldStopAi() {
    return stopAiScanning; // 当 stopAiScanning 为 true 时停止
  }

  // 替换AI设备编辑
  void replaceAiDevice() {

    // 这里添加保存AI设备编辑的API调用
    // 例如：HttpQuery.share.editService.editAiDevice(...)
    if (aiDeviceList.isEmpty) {
      LoadingUtils.showToast(data: "请先连接设备");
      return;
    }
    DeviceDetailAiData? device = aiDeviceList.first;
    if (device.ip == null) {
      LoadingUtils.showToast(data: "请先连接设备");
      return;
    }
    HttpQuery.share.homePageService.replaceAi(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        ip: device.ip ?? "",
        mac: device.mac ?? "",
        onSuccess: (result) {
          LoadingUtils.showToast(data: "修改信息成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.dismiss();
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {
    // 实现数据加载
  }
}
