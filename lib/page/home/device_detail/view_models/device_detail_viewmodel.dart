import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DeviceDetailViewModel extends BaseViewModelRefresh<dynamic> {
  final int id;
  DeviceType deviceType;

  DeviceDetailViewModel(this.id, this.deviceType);

  //电源类型
  String portType = "";
  List portTypes = ["显示进口", "出口", "共用进出口"];
  bool batteryMains = false; //市电
  bool battery = false; //电池

  IdNameValue? deviceTypeSelected;
  List deviceTypes = [];

  @override
  void initState() async {
    super.initState();
    deviceTypes = [
      IdNameValue(id: 1, name: "AI设备"),
      IdNameValue(id: 2, name: "摄像头"),
      IdNameValue(id: 3, name: "NVR"),
      IdNameValue(id: 4, name: "电源箱"),
      IdNameValue(id: 5, name: "交换机"),
      IdNameValue(id: 6, name: "电池"),
    ];

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
  confirmPowerEventAction() {
    if (portType.isNotEmpty && (battery || batteryMains)) {
      LogUtils.info(msg: "confirmPowerEventAction");
    }
  }

  //选择设备类型
  selectedDeviceType(a) {
    deviceTypeSelected = a!;
    switch (deviceTypeSelected?.id) {
      case 1:
        deviceType = DeviceType.ai;
        break;
      case 2:
        deviceType = DeviceType.camera;
        break;
      case 3:
        deviceType = DeviceType.nvr;
        break;
      case 4:
        deviceType = DeviceType.powerBox;
        break;
      case 5:
        deviceType = DeviceType.exchange;
        break;
      case 6:
        deviceType = DeviceType.battery;
        break;
    }
    notifyListeners();
  }
}
