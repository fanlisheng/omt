import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_power_box_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/page/home/device_add/widgets/power_box_bind_device_dialog_page.dart';
import 'package:omt/utils/intent_utils.dart';

class AddPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
  // 父节点code
  final String pNodeCode;
  final bool isInstall; //是安装 默认否

  AddPowerBoxViewModel(this.pNodeCode, {this.isInstall = false});

  // ===== 电源箱相关属性 =====
  IdNameValue? selectedPowerBoxInOut;
  DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox;
  bool? isPowerBoxNeeded;
  List<DeviceDetailPowerBoxData> powerBoxList = [];
  List<IdNameValue> inOutList = [];

  final asgbKey = GlobalKey<AutoSuggestBoxState>();
  final focusNode = FocusNode();
  final controller = TextEditingController();
  


  // String powerBoxMemo = "";
  // final TextEditingController powerBoxMemoController = TextEditingController();

  @override
  void initState() async {
    super.initState();
    if (isInstall == false) {
      isPowerBoxNeeded = true;
    }
    
    // 加载基础数据
    _loadInitialData();
  }
  
  /// 加载初始数据
  void _loadInitialData() {
    int completedRequests = 0;
    const int totalRequests = 2;
    
    void checkAllRequestsCompleted() {
      completedRequests++;
      if (completedRequests == totalRequests) {
        // 所有网络请求完成后通知UI更新
        _smartRestoreCacheSelections();
        notifyListeners();
      }
    }
    
    // 初始化进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        checkAllRequestsCompleted();
      },
    );
    
    // 初始化电源箱列表
    HttpQuery.share.installService.getUnboundPowerBox(
      onSuccess: (List<DeviceDetailPowerBoxData>? data) {
        powerBoxList = data ?? [];
        checkAllRequestsCompleted();
      },
    );
  }

  /// 刷新电源箱列表数据
  Future<void> refreshPowerBoxList() async {
    HttpQuery.share.installService.getUnboundPowerBox(
      onSuccess: (List<DeviceDetailPowerBoxData>? data) {
        powerBoxList = data ?? [];
        notifyListeners();
      },
    );
  }
  
  /// 智能恢复缓存选择项（公共方法）
  void smartRestoreCacheSelections() {
    _smartRestoreCacheSelections();
  }
  
  /// 智能恢复缓存选择项
  void _smartRestoreCacheSelections() {
    bool needRequestInterface = false;
    DeviceDetailPowerBoxData? finalSelectedPowerBox;
    
    // 智能恢复进出口选择
    if (selectedPowerBoxInOut != null && inOutList.isNotEmpty) {
      IdNameValue? matchedInOut;
      bool inOutExists = inOutList.any((inOut) {
        if (inOut.id == selectedPowerBoxInOut?.id) {
          matchedInOut = inOut;
          return true;
        }
        return false;
      });
      if (inOutExists && matchedInOut != null) {
        // 只有当对象引用不同时才重新赋值，避免不必要的UI更新
        if (selectedPowerBoxInOut != matchedInOut) {
          selectedPowerBoxInOut = matchedInOut;
        }
      } else {
        // 如果缓存的进出口不在新列表中，清空选择
        selectedPowerBoxInOut = null;
      }
    }
    
    // 智能恢复电源箱选择
    if (selectedDeviceDetailPowerBox != null && powerBoxList.isNotEmpty) {
      DeviceDetailPowerBoxData? matchedPowerBox;
      bool powerBoxExists = powerBoxList.any((powerBox) {
        if (powerBox.deviceCode == selectedDeviceDetailPowerBox?.deviceCode) {
          matchedPowerBox = powerBox;
          return true;
        }
        return false;
      });
      if (powerBoxExists && matchedPowerBox != null) {
        // 只有当对象引用不同时才重新赋值，避免不必要的UI更新
        if (selectedDeviceDetailPowerBox != matchedPowerBox) {
          selectedDeviceDetailPowerBox = matchedPowerBox;
          controller.text = matchedPowerBox?.deviceCode ?? "";
          needRequestInterface = true;
          finalSelectedPowerBox = matchedPowerBox;
        }
      } else {
        // 如果缓存的电源箱不在新列表中，清空选择
        selectedDeviceDetailPowerBox = null;
        controller.clear();
      }
    }
    
    // 通知UI更新
    notifyListeners();
    
    // 在所有数据处理完成后，统一调用一次selectedPowerBoxCode
    if (needRequestInterface && finalSelectedPowerBox != null) {
      selectedPowerBoxCode(finalSelectedPowerBox, requestInterface: true);
    }
  }

  /// 同步控制器与数据
  void syncControllersWithData() {
    // 如果有选中的电源箱数据，同步到控制器
    if (selectedDeviceDetailPowerBox != null && controller.text.isEmpty) {
      controller.text = selectedDeviceDetailPowerBox?.deviceCode ?? "";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    try {
      controller.dispose();
    } catch (e) {
      // 忽略重复释放错误
    }
    try {
      focusNode.dispose();
    } catch (e) {
      // 忽略重复释放错误
    }
    try {
      super.dispose();
    } catch (e) {
      // 忽略父类dispose错误
    }
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  //选择电源箱code
  selectedPowerBoxCode(DeviceDetailPowerBoxData? a, {bool requestInterface = true}) {
    if (a == null) return;
    selectedDeviceDetailPowerBox = a;
    if (requestInterface) {
      requestDcInterfaceData(a);
    }
  }

  // 安装电源箱
  void installPowerBox() {
    // 检查是否已选择电源箱
    if (checkSelection() == false) {
      return;
    }

    HttpQuery.share.installService.powerBoxInstall(
        pNodeCode: pNodeCode,
        deviceCode: selectedDeviceDetailPowerBox!.deviceCode!,
        passId: selectedPowerBoxInOut!.id!,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '电源箱安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '电源箱安装失败: $error');
        });
  }

  // openDcAction(DeviceDetailPowerBoxDataDcInterfaces a) {
  //   HttpQuery.share.homePageService.dcInterfaceControl(
  //       deviceCode: selectedDeviceDetailPowerBox?.deviceCode ?? "",
  //       ids: [a.id ?? 0],
  //       status: a.statusText == "打开" ? 1 : 2,
  //       onSuccess: (data) {
  //         selectedDeviceDetailPowerBox?.dcInterfaces?.remove(a);
  //         LoadingUtils.show(data: "${(a.statusText == "打开") ? "关闭" : "打开"}成功!");
  //         // _requestData();
  //       });
  // }

  // //记录 （绑定设备）
  // void recordDeviceAction(DeviceDetailPowerBoxDataDcInterfaces a) {
  //   PowerBoxBindDeviceDialogPage.showAndSubmit(
  //       context: context!,
  //       deviceCode: selectedDeviceDetailPowerBox?.deviceCode ?? "",
  //       dcId: a.id ?? 0,
  //       onSuccess: () {
  //         LoadingUtils.show(data: "记录成功!");
  //         requestDcInterfaceData(selectedDeviceDetailPowerBox!);
  //       });
  // }

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

  //检查
  bool checkSelection() {
    if (isPowerBoxNeeded == null) {
      LoadingUtils.showToast(data: '请选选择是否需要安装!');
      return false;
    }
    if (isPowerBoxNeeded ?? false) {
      if (selectedPowerBoxInOut?.id == null) {
        LoadingUtils.showToast(data: '请选择进出口');
        return false;
      }
      if (selectedDeviceDetailPowerBox?.deviceCode == null) {
        LoadingUtils.showToast(data: '请先选择电源箱');
        return false;
      }
    }
    return true;
  }



  /// 从缓存恢复电源箱数据
  void restoreFromCache({
    bool? isPowerBoxNeeded,
    List<IdNameValue>? inOutList,
    IdNameValue? selectedPowerBoxInOut,
    DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox,
  }) {
    // 恢复电源箱相关数据
    if (isPowerBoxNeeded != null) {
      this.isPowerBoxNeeded = isPowerBoxNeeded;
    }
    // 恢复进出口列表
    if (inOutList != null) {
      this.inOutList = inOutList;
    }
    // 恢复选中的进出口
    if (selectedPowerBoxInOut != null) {
      this.selectedPowerBoxInOut = selectedPowerBoxInOut;
    }
    // 恢复选中的电源箱
    if (selectedDeviceDetailPowerBox != null) {
      this.selectedDeviceDetailPowerBox = selectedDeviceDetailPowerBox;
      // 同步控制器
      controller.text = selectedDeviceDetailPowerBox.deviceCode ?? "";
      // 缓存恢复时调用selectedPowerBoxCode方法（只在外部缓存恢复时执行）
      selectedPowerBoxCode(selectedDeviceDetailPowerBox, requestInterface: true);
    }
    
    print('电源箱缓存数据已恢复');
    notifyListeners();
  }

  static Map<String, dynamic>? getPowerBoxes(
      AddPowerBoxViewModel powerBoxViewModel) {
    if (powerBoxViewModel.isPowerBoxNeeded == false) {
      return null;
    }
    String deviceCode =
    powerBoxViewModel.selectedDeviceDetailPowerBox!.deviceCode!;
    int passId = powerBoxViewModel.selectedPowerBoxInOut!.id!;

    Map<String, dynamic> params = {
      "device_code": deviceCode,
      "pass_id": passId,
    };
    return params;
  }
}
