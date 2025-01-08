import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../../bean/home/home_page/local_device_entity.dart';

enum BindDevicePageState {
  idle, // 空闲状态，没有请求
  loading, // 请求中
  success, // 请求成功
  failure, // 请求失败
}

class DeviceAddViewModel extends BaseViewModelRefresh<dynamic> {
  final int id;
  final int deviceType;
  DeviceAddViewModel(this.id, this.deviceType); //页面状态

  String portType = "";
  List portTypes = ["显示进口", "出口", "共用进出口"];

  bool batteryMains = false;
  bool battery = false;

  BindDevicePageState pageState = BindDevicePageState.loading;

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

  ///确定电源类型
  confirmPowerEventAction(){
    if (portType.isNotEmpty && (battery || batteryMains)){
      LogUtils.info(msg: "confirmPowerEventAction");
    }
  }
}
