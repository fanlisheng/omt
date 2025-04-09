// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:kayo_package/kayo_package.dart';
// import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
// import 'package:omt/bean/common/code_data.dart';
// import 'package:omt/http/http_query.dart';
// import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
// import '../../../../bean/home/home_page/device_entity.dart';
// import 'device_add_viewmodel.dart';
//
// class AddPowerBoxViewModel extends BaseViewModelRefresh<dynamic> {
//   // Function()? subNotifyListeners;
//
//   // AiAddViewModel({this.subNotifyListeners});
//
//   final DeviceType deviceType;
//   final StepNumber stepNumber;
//   final bool isInstall; //是安装 默认否
//
//   AddPowerBoxViewModel(this.deviceType, this.stepNumber, this.isInstall);
//
//   List<DeviceEntity> deviceList = [DeviceEntity()];
//
//   // 进/出口选项
//   String selectedEntryExit = "";
//   List entryExitList = ["显示进口", "出口", "共用进出口"];
//
//   DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox;
//
//   // List powerBoxCodingList = ["1", "2"];
//
//   bool isPowerBoxNeeded = false;
//
//   List<DeviceDetailPowerBoxData> powerBoxList = [];
//   DeviceDetailPowerBoxData selectedDeviceInfo = DeviceDetailPowerBoxData();
//
//   // ed接口信息
//   // List<Map<String, String>> edPortInfo = [];
//
//   @override
//   void initState() async {
//     super.initState();
//     // edPortInfo = [
//     //   {
//     //     "DC": "1",
//     //     "状态": "正在录像",
//     //     "电压": "正常",
//     //     "电流": "2024-09-25 10:22:34",
//     //     "运行设备": "未知"
//     //
//     //   },
//     //   {
//     //     "DC": "1",
//     //     "状态": "正在录像",
//     //     "电压": "正常",
//     //     "电流": "2024-09-25 10:22:34",
//     //     "运行设备": "未知"
//     //   },
//     //   {
//     //     "DC": "1",
//     //     "状态": "正在录像",
//     //     "电压": "正常",
//     //     "电流": "2024-09-25 10:22:34",
//     //     "运行设备": "未知"
//     //   }
//     // ];
//     HttpQuery.share.installService.getUnboundPowerBox(
//         onSuccess: (List<DeviceDetailPowerBoxData>? data) {
//       powerBoxList = data ?? [];
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   loadData({onSuccess, onCache, onError}) {
//     ///网络请求
//   }
//
//   // 安装电源箱
//   installPowerBox({
//     String? pNodeCode,
//     required String deviceCode,
//     required String ip,
//     required String mac,
//     String? instanceId,
//     int? gateId,
//     int? passId,
//   }) {
//     HttpQuery.share.installService.powerBoxInstall(
//         pNodeCode: pNodeCode,
//         deviceCode: deviceCode,
//         ip: ip,
//         mac: mac,
//         instanceId: instanceId,
//         gateId: gateId,
//         passId: passId,
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: '电源箱安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: '电源箱安装失败: $error');
//         });
//   }
//
//   // 安装电源信息
//   installPower({
//     String? pNodeCode,
//     String? instanceId,
//     int? gateId,
//     int? passId,
//   }) {
//     HttpQuery.share.installService.powerInstall(
//         pNodeCode: pNodeCode,
//         instanceId: instanceId,
//         gateId: gateId,
//         passId: passId,
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: '电源信息安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: '电源信息安装失败: $error');
//         });
//   }
// }
