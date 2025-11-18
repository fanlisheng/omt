import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_power_box_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/intent_utils.dart';


class EditPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceDetailPowerBoxData deviceInfo;
  final bool isReplace; //是替换 默认否
  EditPowerBoxViewModel(this.deviceInfo, this.isReplace);

  // ===== 电源箱相关属性 =====
  IdNameValue? selectedPowerBoxInOut;
  DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox;
  bool isPowerBoxNeeded = true;
  List<DeviceDetailPowerBoxData> powerBoxList = [];
  List<IdNameValue> inOutList = [];

  final asgbKey = GlobalKey<AutoSuggestBoxState>();
  final focusNode = FocusNode();
  final controller = TextEditingController();

  @override
  void initState() async {
    super.initState();
    // 初始化数据
    // selectedDeviceDetailPowerBox = deviceInfo;

    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        // 设置当前选中的进出口
        for (var entry in inOutList) {
          if (entry.name == deviceInfo.passName) {
            selectedPowerBoxInOut = entry;
            break;
          }
        }
        notifyListeners();
      },
    );

    // 获取可选电源箱列表
    HttpQuery.share.installService.getUnboundPowerBox(
      onSuccess: (List<DeviceDetailPowerBoxData>? data) {
        powerBoxList = data ?? [];
        // 添加当前电源箱到列表
        if (!powerBoxList
            .any((element) => element.deviceCode == deviceInfo.deviceCode)) {
          powerBoxList.add(deviceInfo);
        }
        notifyListeners();
      },
    );
  }

  /// 刷新电源箱列表数据
  Future<void> refreshPowerBoxList() async {
    HttpQuery.share.installService.getUnboundPowerBox(
      onSuccess: (List<DeviceDetailPowerBoxData>? data) {
        powerBoxList = data ?? [];
        // 添加当前电源箱到列表
        if (!powerBoxList
            .any((element) => element.deviceCode == deviceInfo.deviceCode)) {
          powerBoxList.add(deviceInfo);
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose;
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  //选择电源箱code
  selectedPowerBoxCode(DeviceDetailPowerBoxData? a) {
    if (a == null) return;
    selectedDeviceDetailPowerBox = a;
    requestDcInterfaceData(a);
  }

  // 保存电源箱编辑
  void savePowerBoxEdit() {
    // 检查是否已选择电源箱
    if (selectedPowerBoxInOut?.id == null) {
      LoadingUtils.showToast(data: '请选择进出口');
      return;
    }

    HttpQuery.share.homePageService.editPowerBox(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        passId: selectedPowerBoxInOut!.id ?? 0,
        onSuccess: (result) {
          LoadingUtils.showToast(data: "修改信息成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.dismiss();
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }

  //替换电源箱
  void replaceDevice() {
    if (selectedDeviceDetailPowerBox?.deviceCode == null) {
      LoadingUtils.showToast(data: '请先选择电源箱');
      return;
    }

    HttpQuery.share.homePageService.replacePowerBox(
        nodeId: int.parse(deviceInfo.nodeId ?? "0"),
        deviceCode: selectedDeviceDetailPowerBox?.deviceCode ?? "",
        onSuccess: (result) {
          LoadingUtils.showToast(data: "替换成功");
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.dismiss();
          LoadingUtils.showToast(data: "保存失败: $error");
        });
  }

  changeDeviceStateAction(info) {
    notifyListeners();
  }


  //请求电源箱接口信息
  void requestDcInterfaceData(DeviceDetailPowerBoxData a) {
    HttpQuery.share.homePageService.deviceDetailPowerBox(
        deviceCode: a.deviceCode ?? "",
        onSuccess: (data) {
          selectedDeviceDetailPowerBox = a;
          selectedDeviceDetailPowerBox?.dcInterfaces = data?.dcInterfaces ?? [];
          notifyListeners();
        });
  }
}
