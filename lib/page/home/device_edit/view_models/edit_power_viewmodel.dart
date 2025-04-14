import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_power_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';

class EditPowerViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceDetailPowerData deviceInfo;

  EditPowerViewModel(this.deviceInfo);

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
    // 初始化数据
    // 设置电源类型
    batteryMains = (deviceInfo.powerType ?? []).contains(1); // 如果包含 1，batteryMains = true
    battery = (deviceInfo.powerType ?? []).contains(2); //

    // 设置电池信息
    if (deviceInfo.batteryCapacity != null && deviceInfo.batteryCapacity! > 0) {
      battery = true;
      isCapacity80 = deviceInfo.batteryCapacity == 80;
    }

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        // 设置当前选中的进出口
        for (var entry in inOutList) {
          if (entry.name == deviceInfo.passName) {
            selectedPowerInOut = entry;
            break;
          }
        }
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

  // 保存电源编辑
  void savePowerEdit() {
    // 电源需要检查参数
    if (selectedPowerInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }
    if (batteryMains == false && battery == false) {
      LoadingUtils.showToast(data: '请选择电源类型');
      return;
    }
    List<int> powerType = [];
    if (batteryMains) {
      powerType.add(1);
    }
    if (battery) {
      powerType.add(2);
    }
    HttpQuery.share.homePageService.editPower(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        passId: selectedPowerInOut!.id ?? 0,
        powerType: powerType,
        batteryCapacity: battery ? (isCapacity80 ? 80 : 160) : null,
        onSuccess: (result) {
          LoadingUtils.showToast(data: "修改信息成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }
}
