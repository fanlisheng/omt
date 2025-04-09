// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:kayo_package/kayo_package.dart';
// import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
// import 'package:omt/bean/common/code_data.dart';
// import 'package:omt/http/http_query.dart';
// import 'package:omt/http/service/home/home_page/home_page_service.dart';
// import 'package:omt/utils/hikvision_utils.dart';
// import 'package:omt/utils/sys_utils.dart';
// import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
// import '../../../../bean/home/home_page/device_entity.dart';
// import '../../../../utils/device_utils.dart';
// import '../../search_device/services/device_search_service.dart';
// import 'device_add_viewmodel.dart';
//
// class AddAiViewModel extends BaseViewModelRefresh<dynamic> {
//   // Function()? subNotifyListeners;
//
//   // AiAddViewModel({this.subNotifyListeners});
//
//   final DeviceType deviceType;
//   final StepNumber stepNumber;
//   final bool isInstall; //是安装 默认否
//
//   bool isSearching = false;
//   String? selectedIp;
//   List<DeviceEntity> searchResults = [];
//
//   AddAiViewModel(this.deviceType, this.stepNumber, this.isInstall);
//
//   List<DeviceDetailAiData> deviceList = [DeviceDetailAiData()];
//
//   ///ai
//   // 创建一个 TextEditingController 列表来动态管理每个 TextField 的内容
//   List<TextEditingController> controllers = [TextEditingController()];
//
//   //停止扫描
//   bool stopScanning = false;
//
//   @override
//   void initState() async {
//     super.initState();
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
//       //获取到mac
//       String? mac = await DeviceUtils.getMacAddressByIp(
//           ip: controllers[index].text,
//           shouldStop: () {
//             return false;
//           });
//       if (mac == null) return;
//       //请求设备信息
//       String deviceCode =
//           DeviceUtils.getDeviceCodeByMacAddress(macAddress: mac);
//       HttpQuery.share.homePageService.deviceDetailAi(
//           nodeCode: deviceCode,
//           onSuccess: (DeviceDetailAiData? data) {
//             data?.mac = mac;
//             if (data != null) {
//               if (isInstall) {
//                 //可能有多个
//                 deviceList.insert(0, data);
//                 controllers.add(TextEditingController());
//               } else {
//                 //只有一个
//                 deviceList = [data];
//               }
//             }
//             notifyListeners();
//           });
//     } else {
//       LoadingUtils.showToast(data: '请输入正确的IP地址');
//     }
//   }
//
//   // 安装AI设备和摄像头
//   installAiDeviceAndCamera({
//     String? pNodeCode,
//     String? instanceId,
//     int? gateId,
//     int? passId,
//     required Map<String, dynamic> aiDevice,
//     required Map<String, dynamic> camera,
//   }) {
//     HttpQuery.share.installService.aiDeviceCameraInstall(
//         pNodeCode: pNodeCode,
//         instanceId: instanceId,
//         gateId: gateId,
//         passId: passId,
//         aiDevice: aiDevice,
//         camera: camera,
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: '安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: '安装失败: $error');
//         });
//   }
//
//   // 开始搜索
//   void startSearch() async {
//     isSearching = true;
//     searchResults.clear();
//     selectedIp = null;
//     notifyListeners();
//     // 扫描设备
//     List<DeviceEntity> searchDevices =
//         await DeviceSearchService().scanDevices(shouldStop: _shouldStop);
//     if (_shouldStop()) {
//       stopSearch();
//       return;
//     }
//     List<DeviceEntity> aiDevices =
//         searchDevices.where((device) => device.deviceType == 10).toList();
//     // 搜索完成后调用：
//     isSearching = false;
//     searchResults = List.from(aiDevices); // 设置搜索结果
//     notifyListeners();
//   }
//
//   // 停止搜索
//   void stopSearch() {
//     isSearching = false;
//     searchResults = [];
//     notifyListeners();
//   }
//
//   // 处理选中的IP
//   void handleSelectedIp() {
//     if (selectedIp != null) {
//       // 将选中的IP填入第一个空的或新的输入框
//       int targetIndex =
//           controllers.indexWhere((controller) => controller.text.isEmpty);
//       if (targetIndex == -1) {
//         if (isInstall) {
//           // 如果是安装模式，添加新的输入框
//           controllers.add(TextEditingController(text: selectedIp));
//           deviceList.add(DeviceDetailAiData());
//         } else {
//           // 如果不是安装模式，使用第一个输入框
//           controllers[0].text = selectedIp!;
//         }
//       } else {
//         controllers[targetIndex].text = selectedIp!;
//       }
//
//       // 自动触发连接
//       connectEventAction(
//           targetIndex == -1 ? controllers.length - 1 : targetIndex);
//     }
//   }
//
//   // 定义一个停止条件的回调函数
//   bool _shouldStop() {
//     return stopScanning; // 当 stopScanning 为 true 时停止
//   }
// }
