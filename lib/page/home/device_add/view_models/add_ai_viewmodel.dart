import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/hikvision_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../../bean/home/home_page/local_device_entity.dart';
import 'device_add_viewmodel.dart';

class AddAiViewModel extends BaseViewModelRefresh<dynamic> {
  // Function()? subNotifyListeners;

  // AiAddViewModel({this.subNotifyListeners});

  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool isInstall; //是安装 默认否
  AddAiViewModel(this.deviceType, this.stepNumber, this.isInstall);

  List<LocalDeviceEntity> deviceList = [LocalDeviceEntity()];

  ///ai
  // 创建一个 TextEditingController 列表来动态管理每个 TextField 的内容
  List<TextEditingController> controllers = [TextEditingController()];

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {
    // 不要忘记在 dispose 时销毁所有的 TextEditingController
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///点击事件
  //连接
  connectEventAction(int index) async {
    if (SysUtils.isIPAddress(controllers[index].text)) {
      LocalDeviceEntity? a =
          await hikvisionDeviceInfo(ipAddress: controllers[index].text);
      if (a != null) {
        if(isInstall){//可能有多个
          deviceList.insert(0, a);
          controllers.add(TextEditingController());
        }else{//只有一个
          deviceList = [a];
        }
      }
      notifyListeners();

    } else {
      LoadingUtils.showToast(data: '请输入正确的IP地址');
    }
  }
}
