import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/routing/routes.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
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

  // String? gateNo;
  // List gates = <String>[
  //   'Abyssinian',
  //   'Aegean',
  //   'American Bobtail',
  //   'American Curl',
  //   'American Ringtail',
  //   'American Shorthair',
  //   'American Wirehair',
  //   'Aphrodite Giant',
  //   'Arabian Mau',
  //   'Asian cat',
  //   'Asian Semi-longhair',
  //   'Australian Mist',
  //   'Balinese',
  //   'Bambino',
  // ];

  //页面状态
  BindDevicePageState pageState = BindDevicePageState.idle;

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
      LoadingUtils.showToast(data:"未选择大门或大门编号不正确");
      return;
    }

    request();
  }

  //成功返回
  goBackEventAction() {
    // context!.pop();
    IntentUtils.share.popResultOk(context!);
  }

  //手动绑定
  handBindingEventAction() {
    request();
  }

  void request() {
    pageState = BindDevicePageState.loading;
    notifyListeners();
    List<DeviceEntity> selectedDevices = [];
    if (deviceData.isNotEmpty) {
      selectedDevices =
          deviceData.where((device) => device.selected ?? false).toList();
    }
    HttpQuery.share.homePageService.bindGate(
        instanceId: instance.id ?? "",
        gateId: selectedDoor?.id ?? 0,
        deviceList: selectedDevices,
        onSuccess: (m) {
          pageState = BindDevicePageState.success;
          notifyListeners();
        },
        onError: (e) {
          pageState = BindDevicePageState.failure;
          notifyListeners();
        });
  }
}
