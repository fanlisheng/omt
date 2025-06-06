import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_nvr_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/sys_utils.dart';

import '../../../../bean/home/home_page/device_entity.dart';

class AddNvrViewModel extends BaseViewModel {
  final String pNodeCode;

  AddNvrViewModel(this.pNodeCode);

  // ===== NVR 相关属性 =====
  List<DeviceEntity> nvrDeviceList = [];
  bool? isNvrNeeded ;
  DeviceEntity? selectedNvr;
  DeviceDetailNvrData nvrData = DeviceDetailNvrData();
  bool isNvrSearching = false;
  IdNameValue? selectedNarInOut;
  List<IdNameValue> inOutList = [];
  bool stopScanning = false;

  @override
  void initState() {
    super.initState();
    if(pNodeCode.isNotEmpty){
      isNvrNeeded = true;
      refreshNvrAction();
    }
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
    stopScanning = true;
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

// 刷新NVR列表
  refreshNvrAction() {
    if (isNvrSearching) return;
    _getNvrList();
  }

  // 选择一个NVR IP
  void selectNvrIpAction(DeviceEntity nvrDevice) {
    if (nvrDevice.mac == null || nvrDevice == selectedNvr) return;
    selectedNvr = nvrDevice;
    isNvrNeeded = true;
    notifyListeners();
    //请求通道信息
    String deviceCode =
        DeviceUtils.getDeviceCodeByMacAddress(macAddress: selectedNvr!.mac!);
    requestData(deviceCode);
  }

  void requestData(String deviceCode) {
    HttpQuery.share.homePageService.deviceDetailNvr(
        deviceCode: deviceCode,
        onSuccess: (data) {
          nvrData = data ?? DeviceDetailNvrData();
          notifyListeners();
        });
  }

  // 获取NVR列表
  void _getNvrList() {
    isNvrSearching = true;
    notifyListeners();
    LoadingUtils.show(data: "正在获取当前网络下的NVR设备");
    DeviceUtils.scanAndFetchDevicesInfo(
            deviceType: "NVR", shouldStop: _shouldStop)
        .then((List<DeviceEntity> data) {
      nvrDeviceList.clear();
      for (var a in data) {
        if (a.ip != null) {
          nvrDeviceList.add(a);
        }
      }
      isNvrSearching = false;
      notifyListeners();
      LoadingUtils.dismiss();
    });
  }

  // 安装NVR设备
  void installNvrAction() {
    // // 检查是否已选择NVR
    // if (selectedNarInOut == null) {
    //   LoadingUtils.showToast(data: '请先选择进出口');
    //   return;
    // }
    // if (selectedNvr == null) {
    //   LoadingUtils.showToast(data: '请先选择NVR设备');
    //   return;
    // }

    if (checkNvrSelection() == false) {
      return;
    }

    HttpQuery.share.installService.nvrInstall(
        pNodeCode: pNodeCode,
        ip: selectedNvr!.ip ?? "",
        mac: selectedNvr!.mac ?? "",
        passId: selectedNarInOut!.id!,
        onSuccess: (data) {
          LoadingUtils.showToast(data: 'NVR安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: 'NVR安装失败: $error');
        });
  }

  bool checkNvrSelection() {
    if (isNvrNeeded == null) {
      LoadingUtils.showToast(data: '请选选择是否需要安装!');
      return false;
    }
    if (isNvrNeeded ?? false) {
      if (selectedNarInOut == null) {
        LoadingUtils.showToast(data: '请先选择进出口');
        return false;
      }
      if (selectedNvr == null) {
        LoadingUtils.showToast(data: '请先选择NVR设备');
        return false;
      }
    }
    return true;
  }

  bool _shouldStop() {
    return stopScanning; // 当 stopAiScanning 为 true 时停止
  }

  static   Map<String, dynamic> getNvr(AddNvrViewModel nvrViewModel) {
    int passId = nvrViewModel.selectedNarInOut!.id!;
    String mac = nvrViewModel.selectedNvr!.mac ?? "";
    String ip = nvrViewModel.selectedNvr?.ip ?? "";

    Map<String, dynamic> params = {
      "ip": ip,
      "mac": mac,
      "pass_id": passId,
    };
    return params;
  }
}
