// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:kayo_package/kayo_package.dart';
// import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
// import 'package:omt/bean/common/id_name_value.dart';
// import 'package:omt/utils/hikvision_utils.dart';
// import 'package:omt/utils/log_utils.dart';
// import 'package:omt/utils/shared_utils.dart';
// import 'package:omt/utils/sys_utils.dart';
// import '../../../../bean/home/home_page/device_entity.dart';
// import 'device_add_viewmodel.dart';
// import 'add_battery_exchange_viewmodel.dart';
//
// class SecondStepViewModel extends BaseViewModelRefresh<dynamic> {
//   Function()? subNotifyListeners;
//
//   SecondStepViewModel({this.subNotifyListeners});
//
//   DeviceType deviceType = DeviceType.camera;
//   StepNumber stepNumber = StepNumber.second;
//
//   List<DeviceEntity> deviceList = [DeviceEntity()];
//
//   ///ai
//   // 创建一个 TextEditingController 列表来动态管理每个 TextField 的内容
//   List<TextEditingController> controllers = [TextEditingController()];
//
//   // 添加电池/交换机 ViewModel
//   AddBatteryExchangeViewModel? batteryExchangeViewModel;
//
//   @override
//   void initState() async {
//     super.initState();
//
//   }
//
//   @override
//   void dispose() {
//     // 不要忘记在 dispose 时销毁所有的 TextEditingController
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   loadData({onSuccess, onCache, onError}) {
//     ///网络请求
//   }
//
//   ///点击事件
//   //连接
//   connectEventAction(int index) async {
//     if (SysUtils.isIPAddress(controllers[index].text)) {
//       DeviceEntity? a =
//           await hikvisionDeviceInfo(ipAddress: controllers[index].text);
//       if (a != null) {
//         deviceList.insert(0, a);
//         controllers.add(TextEditingController());
//       }
//       if (subNotifyListeners != null) {
//         subNotifyListeners!();
//       }
//     } else {
//       LoadingUtils.showToast(data: '请输入正确的IP地址');
//     }
//   }
// }
