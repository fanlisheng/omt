import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/page/home/search_device/services/device_search_service.dart';
import 'package:omt/page/remove/widgets/remove_dialog_page.dart';
import 'package:omt/utils/dialog_utils.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../bean/home/home_page/device_entity.dart';
import '../../../bean/remove/device_list_entity.dart';
import '../../../utils/device_utils.dart';

class RemoveViewModel extends BaseViewModelRefresh<dynamic> {
  List<StrIdNameValue> instanceList = [];
  StrIdNameValue? selectedInstance;

  List<IdNameValue> doorList = [];
  IdNameValue? selectedDoor;

  List<IdNameValue> inOutList = [];
  IdNameValue? selectedInOut;

  DeviceListEntity deviceListEntity = DeviceListEntity();

  //设备数据
  List<DeviceListData> dismantleDeviceList = [];
  List<DeviceListData> noDismantleDeviceList = [];

  // 创建 FocusNode 来监听焦点事件
  FocusNode focusNode = FocusNode();
  TextEditingController instanceController = TextEditingController();
  bool isClear = false;
  final asgbKey = GlobalKey<AutoSuggestBoxState>();

  //如果是搜索结果
  bool isSearchResult = false;

  @override
  void initState() async {
    super.initState();
    _setupFocusListener();
    _loadInitialData();
    // dismantleDeviceList = [
    //   LocalDeviceEntity(
    //       deviceType: "测试", ipAddress: "192.168.12.16", selected: true),
    //   LocalDeviceEntity( selected: true),
    //   LocalDeviceEntity( selected: true),
    //   LocalDeviceEntity( selected: true)
    // ];
    // noDismantleDeviceList = [
    //   LocalDeviceEntity(),
    // ];
  }

  @override
  void dispose() {
    instanceController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  searchEventAction() {
    //判断 3个筛选，1.如果都没有提示 2.其它请求
    if (selectedInstance?.id == null) {
      LoadingUtils.showToast(data: "至少选择一个筛选条件");
      return;
    }
    noDismantleDeviceList = [];
    HttpQuery.share.removeService.getDeviceList(
        instanceId: selectedInstance!.id!,
        passId: selectedInOut?.id,
        gateId: selectedDoor?.id,
        onSuccess: (data) {
          dismantleDeviceList = data ?? [];
          isSearchResult = true;
          notifyListeners();
        },
        onError: (e) {
          isSearchResult = true;
          notifyListeners();
        });
  }

  //拆除设备
  dismantleEventAction() async {
    List<int> nodeIds = [];
    for (DeviceListData d in dismantleDeviceList) {
      nodeIds.add(d.id.toInt());
    }
    RemoveDialogPage.showAndSubmit(
        context: context!,
        removeIds: nodeIds,
        instanceId: selectedInstance?.id ?? "",
        gateId: selectedDoor?.id ?? 0,
        passId: selectedInOut?.id ?? 0,
        onSuccess: () {
          searchEventAction();
        });
    // RemoveViewModel.removeDevices(
    //   dialogContext: dialogContext,
    //   context: context!,
    //   // 确保 context 不为 null
    //   selectedDismantleCause: selectedDismantleCause,
    //   remark: remark,
    //   ids: nodeIds,
    //   onSuccess: () {
    //     searchEventAction();
    //   },
    //   selectedInstance: selectedInstance,
    //   selectedDoor: selectedDoor,
    //   selectedInOut: selectedInOut,
    // );
    // if (selectedDismantleCause.isEmpty) {
    //   LoadingUtils.showToast(data: "请选择拆除原因");
    //   return;
    // } else {
    //   if (selectedDismantleCause == "其它" && remark.isEmpty) {
    //     LoadingUtils.showToast(data: "请填写其它描述");
    //     return;
    //   }
    // }
    // Navigator.of(dialogContext).pop();
    // final result = await DialogUtils.showContentDialog(
    //     context: context!,
    //     title: "提交拆除设备申请",
    //     content: "您确定提交拆除这些设备申请,提交后等待/n'审核'",
    //     deleteText: "确定");
    // if (result == '确定') {
    //   List<int> nodeIds = [];
    //   for (DeviceListData d in dismantleDeviceList) {
    //     nodeIds.add(d.id.toInt());
    //   }
    //   HttpQuery.share.removeService.removeDevice(
    //       nodeIds: nodeIds,
    //       instanceId: selectedInstance?.id ?? "",
    //       gateId: selectedDoor?.id,
    //       passId: selectedInOut?.id,
    //       reason: selectedDismantleCause,
    //       remark: remark,
    //       onSuccess: (data) {
    //         //重新请求数据
    //         searchEventAction();
    //       });
    // }
  }

  //选中
  selectedItemEventAction(bool selected, int index) {
    //selected == false 是点击选中的设备

    if (selected == false) {
      DeviceListData a = dismantleDeviceList[index];
      a.selected = false;
      dismantleDeviceList.remove(a);
      noDismantleDeviceList.add(a);
    } else {
      DeviceListData a = noDismantleDeviceList[index];
      a.selected = true;
      noDismantleDeviceList.remove(a);
      dismantleDeviceList.add(a);
    }
    notifyListeners();
  }

  // 更新拆除原因的方法
  // void setDismantleCause(String cause) {
  //   selectedDismantleCause = cause;
  //   notifyListeners(); // 通知界面更新
  // }

  void _loadInitialData() async {
    // 使用状态服务初始化数据
    DeviceSearchInitData data = await DeviceSearchService().initSearchData();

    instanceList = data.instanceList;
    doorList = data.doorList;
    doorList.insert(0, IdNameValue(id: 0, name: "全部"));
    inOutList = data.inOutList;

    notifyListeners();
  }

  void _setupFocusListener() {
    focusNode.addListener(() {
      final asgbState = asgbKey.currentState;
      if (asgbState == null) return;
      if (focusNode.hasFocus) {
        // 当获取到焦点时
        asgbState.showOverlay();
        isClear = false;
      } else {
        // 当失去焦点时
        if (asgbState.isOverlayVisible) {
          asgbState.dismissOverlay();
        }
        instanceController.text = selectedInstance?.name ?? "";
      }
      notifyListeners();
    });
  }

  static Future<void> removeDevices({
    required BuildContext dialogContext,
    required BuildContext context,
    required String selectedDismantleCause,
    required List<int> ids,
    String? remark,
    StrIdNameValue? selectedInstance,
    IdNameValue? selectedDoor,
    IdNameValue? selectedInOut,
    required VoidCallback onSuccess,
  }) async {
    // 验证拆除原因
    if (selectedDismantleCause.isEmpty) {
      LoadingUtils.showToast(data: "请选择拆除原因");
      return;
    } else {
      if (selectedDismantleCause == "其它" && (remark ?? "").isEmpty) {
        LoadingUtils.showToast(data: "请填写其它描述");
        return;
      }
    }

    // 关闭对话框
    Navigator.of(dialogContext).pop();

    // 显示确认对话框
    final result = await DialogUtils.showContentDialog(
      context: context,
      title: "提交拆除设备申请",
      content: "您确定提交拆除这些设备申请,提交后等待\n审核",
      deleteText: "确定",
    );

    if (result == '确定') {
      // 调用拆除设备接口
      HttpQuery.share.removeService.removeDevice(
        nodeIds: ids,
        instanceId: selectedInstance?.id ?? "",
        gateId: selectedDoor?.id,
        passId: selectedInOut?.id,
        reason: selectedDismantleCause,
        remark: remark,
        onSuccess: (data) {
          // 重新请求数据
          onSuccess();
        },
      );
    }
  }
}
