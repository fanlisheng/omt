import 'package:go_router/go_router.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/routing/routes.dart';

import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';

enum BindDevicePageState {
  idle, // 空闲状态，没有请求
  loading, // 请求中
  success, // 请求成功
  failure, // 请求失败
}

class BindDeviceViewModel extends BaseViewModelRefresh<dynamic> {
  //扫描出的设备数据
  final List<DeviceEntity> deviceData;

  BindDeviceViewModel(this.deviceData);

  //全选中
  bool selected = false;

  //选中的数量
  int selectedCount = 0;

  //大门号
  String? gateNo;
  List gates = <String>[
    'Abyssinian',
    'Aegean',
    'American Bobtail',
    'American Curl',
    'American Ringtail',
    'American Shorthair',
    'American Wirehair',
    'Aphrodite Giant',
    'Arabian Mau',
    'Asian cat',
    'Asian Semi-longhair',
    'Australian Mist',
    'Balinese',
    'Bambino',
  ];
  //页面状态
  BindDevicePageState pageState = BindDevicePageState.idle;

  @override
  void initState() async {
    super.initState();
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
    context!.pop();
  }

  //成功返回
  goBackEventAction() {}

  //手动绑定
  handBindingEventAction() {
    HttpQuery.share.homePageService.bindGate(1,1,deviceData,onSuccess: (m){

    });

  }
}
