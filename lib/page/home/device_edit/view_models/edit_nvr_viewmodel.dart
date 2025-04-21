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

class EditNvrViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceDetailNvrData? deviceInfo;
  final bool isReplace; //是替换 默认否
  EditNvrViewModel(this.deviceInfo, this.isReplace);

  bool stopScanning = false;

  // ===== NVR 相关属性 =====
  DeviceEntity? selectedNvr; //选中nav ip和mac
  List<DeviceEntity> nvrDeviceList = [];
  DeviceDetailNvrData? nvrData; // 选中的nvr请求数据
  bool isNvrSearching = false;
  IdNameValue? selectedNarInOut;
  List<IdNameValue> inOutList = [];

  @override
  void initState() {
    super.initState();
    // 初始化数据
    nvrData = deviceInfo;

    if (isReplace) {
      refreshNvrAction();
    }

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        // 设置当前选中的进出口
        for (var entry in inOutList) {
          if (entry.name == deviceInfo?.passName) {
            selectedNarInOut = entry;
            break;
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    stopScanning = true;
    LoadingUtils.dismiss();
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
        },
        onError: (e) {
          nvrData = null;
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

  // 保存NVR编辑
  void saveNvrEdit() {
    // 检查是否已选择NVR
    if (selectedNarInOut == null) {
      LoadingUtils.showToast(data: '请先选择进出口');
      return;
    }

    HttpQuery.share.homePageService.editNvr(
        nodeId: int.parse(deviceInfo?.nodeId ?? "0"),
        passId: selectedNarInOut!.id ?? 0,
        onSuccess: (result) {
          LoadingUtils.showToast(data: "修改信息成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }

  void replaceNvr() {
    // 检查是否已选择NVR
    if (selectedNvr == null) {
      LoadingUtils.showToast(data: '请先选择Nvr');
      return;
    }

    HttpQuery.share.homePageService.replaceNvr(
        nodeId: int.parse(deviceInfo?.nodeId ?? "0"),
        // passId: selectedNarInOut!.id ?? 0,
        ip: selectedNvr?.ip ?? "",
        mac: selectedNvr?.mac ?? "",
        onSuccess: (result) {
          LoadingUtils.showToast(data: "替换成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: "替换失败: $error");
        });
  }

  // removeChannelAction(DeviceDetailNvrDataChannels? info) {
  //   HttpQuery.share.homePageService.deleteNvrChannel(
  //       deviceCode: selectedNvr?.deviceCode ?? "",
  //       nodeId: deviceInfo?.nodeId ?? "",
  //       channels: [
  //         {"id": info?.id ?? 0, "channel_num": info?.channelNum}
  //       ],
  //       onSuccess: (data) {
  //         nvrData?.channels?.remove(info);
  //         LoadingUtils.show(data: "移除成功!");
  //       });
  // }

  bool _shouldStop() {
    return stopScanning; // 当 stopAiScanning 为 true 时停止
  }
}
