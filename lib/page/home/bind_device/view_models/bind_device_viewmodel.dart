import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/routing/routes.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/dialog_utils.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';

enum BindDevicePageState {
  idle, // 空闲状态，没有请求
  loading, // 请求中
  success, // 请求成功
  failure, // 请求失败
}

class BindDeviceViewModel extends BaseViewModelRefresh<dynamic> {
  //扫描出的设备数据
  List<DeviceEntity> deviceData;
  final StrIdNameValue instance;
  final List<IdNameValue> doorList;

  BindDeviceViewModel(this.deviceData, this.instance, this.doorList);

  //全选中
  bool selected = false;

  //选中的数量
  int selectedCount = 0;

  //大门号
  IdNameValue? selectedDoor;

  //页面状态
  BindDevicePageState pageState = BindDevicePageState.idle;

  //提交后显示的text
  String showText = "";

  //添加成功，用户记录添加成功过，返回后刷新
  bool addSuccess = false;

  @override
  void initState() async {
    super.initState();
    for (var e in deviceData) {
      e.selected = false;
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

  ///点击事件
  //选择全部
  selectedAllEventAction(bool? a) {
    selected = a!;
    for (var a in deviceData) {
      a.selected = selected;
    }
    if (selected == true) {
      selectedCount = deviceData.length;
    } else {
      selectedCount = 0;
    }
    // List<DeviceEntity> selectedDevices = [];
    // if (deviceData.isNotEmpty) {
    //   selectedDevices =
    //       deviceData.where((device) => device.selected ?? false).toList();
    // }
    // pageState = BindDevicePageState.success;
    // displayBindingMessage(selectedDevices);
    notifyListeners();
  }

  //选中一个
  selectedItemEventAction(int index) {
    deviceData[index].selected = !(deviceData[index].selected ?? false);
    if (deviceData[index].selected == true) {
      selectedCount++;
    } else {
      selectedCount--;
    }
    notifyListeners();
  }

  //绑定设备
  bingingEventAction() {
    if (selectedDoor == null || (selectedDoor?.id ?? 0) <= 0) {
      LoadingUtils.showToast(data: "未选择大门或大门编号不正确");
      return;
    }

    // 检测设备配置状态
    checkDeviceConfiguration();
  }

  // 检测设备配置状态
  void checkDeviceConfiguration() {
    // 检查当前大门下是否有电源信息、网络信息、交换机信息
    HttpQuery.share.removeService.getDeviceList(
      instanceId: instance.id ?? "",
      gateId: selectedDoor?.id,
      onSuccess: (deviceList) {
        List<String> missingDevices = [];

        // 检查是否有电源设备 (设备类型 5: 电源箱, 或其他电源相关设备)
        bool hasPowerDevice =
            deviceList?.any((device) => device.type == 5 || device.type == 4) ??
                false;

        // 检查是否有网络设备 (设备类型 6: 路由器)
        bool hasNetworkDevice =
            deviceList?.any((device) => device.type == 6) ?? false;

        // 检查是否有交换机设备 (设备类型 9: 交换机)
        bool hasSwitchDevice =
            deviceList?.any((device) => device.type == 9) ?? false;

        if (!hasPowerDevice) {
          missingDevices.add("电源信息");
        }
        if (!hasNetworkDevice) {
          missingDevices.add("网络信息");
        }
        if (!hasSwitchDevice) {
          missingDevices.add("交换机信息");
        }

        if (missingDevices.isNotEmpty) {
          // 显示设备缺失弹窗
          showMissingDeviceDialog(missingDevices);
        } else {
          // 所有设备都已配置，继续绑定流程
          request();
        }
      },
      onError: (error) {
        LoadingUtils.showToast(data: "检测设备配置失败: $error");
      },
    );
  }

  // 显示设备缺失弹窗
  void showMissingDeviceDialog(List<String> missingDevices) {
    String deviceText = missingDevices.join("、");
    String message = "经系统检测，当前大门下存在${deviceText}未配置的设备，请完成设备添加后方可提交绑定";

    DialogUtils.showContentDialog(
      context: context!,
      title: "设备检测",
      content: message,
      deleteText: "去添加",
      cancelText: "取消",
    ).then((result) {
      if (result == "确定") {
        // 跳转到设备添加界面
        navigateToDeviceAddScreen(missingDevices);
      }
    });
  }

  //成功返回
  void goBackEventAction() {
    // 统一处理返回逻辑
    void handlePop({required bool success}) {
      if (success) {
        IntentUtils.share.popResultOk(context!);
      } else {
        IntentUtils.share.pop(context!);
      }
    }

    if (deviceData.isNotEmpty) {
      if (pageState == BindDevicePageState.idle) {
        handlePop(success: addSuccess);
      } else {
        pageState = BindDevicePageState.idle;
        notifyListeners();
      }
    } else {
      handlePop(success: addSuccess);
    }
  }

  // 跳转到设备添加界面
  void navigateToDeviceAddScreen(List<String> missingDevices) {
    String pNodeCode = "${instance.id}-2#${selectedDoor?.id}";
    IntentUtils.share
        .push(context, routeName: RouterPage.MissingDeviceAddScreen, data: {
      'missingDevices': missingDevices,
      'instance': instance.id,
      'gateId': selectedDoor?.id,
      "pNodeCode": pNodeCode
    })?.then((result) {
      // 如果设备添加成功，重新检查设备配置
      if (IntentUtils.share.isResultOk(result)) {
        checkDeviceConfiguration();
      }
    });
  }

  //手动绑定
  handBindingEventAction() {
    request();
  }

  void request() {
    List<DeviceEntity> selectedDevices = [];
    if (deviceData.isNotEmpty) {
      selectedDevices =
          deviceData.where((device) => device.selected ?? false).toList();
    }
    if (selectedDevices.isEmpty) {
      LoadingUtils.showToast(data: "没有选中的设备，请选择需要绑定的设备!");
      return;
    }

    pageState = BindDevicePageState.loading;
    notifyListeners();

    HttpQuery.share.homePageService.bindGate(
        instanceId: instance.id ?? "",
        gateId: selectedDoor?.id ?? 0,
        deviceList: selectedDevices,
        onSuccess: (m) {
          pageState = BindDevicePageState.success;
          displayBindingMessage(selectedDevices);
          deviceData.removeWhere((device) => selectedDevices.contains(device));
          addSuccess = true;
          notifyListeners();
        },
        onError: (e) {
          pageState = BindDevicePageState.failure;
          displayBindingMessage(selectedDevices);
          notifyListeners();
        });
  }

  void displayBindingMessage(List<DeviceEntity> selectedDevices) {
    // 提取所有非空的 deviceTypeText 并去重
    final deviceTypes = selectedDevices
        .map(
            (device) => DeviceUtils.getDeviceTypeString(device.deviceType ?? 0))
        .toSet() // 去重
        .toList();

    if (deviceTypes.isEmpty) {
      return;
    }

    // 检查是否包含“摄像头”
    bool hasCamera = deviceTypes.contains("摄像头");
    String deviceTypeString = deviceTypes.join("、"); // 用“、”拼接设备类型
    String stateText = (pageState == BindDevicePageState.success) ? "成功" : "失败";

    if (hasCamera && deviceTypes.length == 1) {
      // 只有摄像头类型
      showText = "摄像头、实例绑定关系业务平台绑定$stateText\n实例、摄像头绑定关系IOT绑定$stateText";
    } else if (!hasCamera) {
      // 没有摄像头类型
      showText = "实例、$deviceTypeString绑定关系IOT绑定$stateText";
    } else {
      // 有多种类型且包含摄像头
      showText =
          '摄像头、实例绑定关系业务平台绑定$stateText\n实例、$deviceTypeString绑定关系IOT绑定$stateText';
    }
  }
}
