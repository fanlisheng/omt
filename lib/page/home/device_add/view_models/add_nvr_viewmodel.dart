// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:kayo_package/kayo_package.dart';
// import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
// import 'package:omt/bean/common/code_data.dart';
// import 'package:omt/http/http_query.dart';
// import 'package:omt/utils/device_utils.dart';
// import '../../../../bean/common/id_name_value.dart';
// import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
// import '../../../../bean/home/home_page/device_entity.dart';
// import 'device_add_viewmodel.dart';
//
// class AddNvrViewModel extends BaseViewModelRefresh<dynamic> {
//   // Function()? subNotifyListeners;
//
//   // AiAddViewModel({this.subNotifyListeners});
//
//   final DeviceType deviceType;
//   final StepNumber stepNumber;
//   final bool showInstall;
//
//   AddNvrViewModel(this.deviceType, this.stepNumber, this.showInstall);
//
//   List<DeviceEntity> deviceList = [DeviceEntity()];
//
//   ///nvr
//   // 是否需要安装NVR
//   bool isNvrNeeded = true;
//
//   // 当前选择的NVR IP地址
//   DeviceEntity? selectedNvrIp;
//
//   // NVR IP地址列表
//   List<DeviceEntity> nvrIpList = [];
//
//   // NVR信息
//   DeviceDetailNvrData nvrData = DeviceDetailNvrData();
//   bool isSearching = false; //在搜索中
//
//   List<IdNameValue> inOutList = [];
//   IdNameValue? selectedInOut;
//
//   @override
//   void initState() async {
//     super.initState();
//     // nvrInfo = [
//     //   {
//     //     "通道号": "1",
//     //     "是否在录像": "正在录像",
//     //     "信号状态": "正常",
//     //     "更新时间": "2024-09-25 10:22:34"
//     //   },
//     //   {"通道号": "2", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     //   {"通道号": "3", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     //   {"通道号": "4", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     //   {"通道号": "5", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     //   {"通道号": "6", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     //   {"通道号": "7", "是否在录像": "未录像", "信号状态": "正常", "更新时间": "2024-09-25 10:22:34"},
//     // ];
//     // nvrIpList = [
//     //   "192.168.101.252",
//     //   "192.168.101.253",
//     //   "192.168.101.254",
//     //   "192.168.101.255"
//     // ];
//     HttpQuery.share.homePageService.getInOutList(
//       onSuccess: (List<IdNameValue>? data) {
//         inOutList = data ?? [];
//         notifyListeners();
//       },
//     );
//     _getNvrList();
//   }
//
//   @override
//   void dispose() {}
//
//   @override
//   loadData({onSuccess, onCache, onError}) {
//     ///网络请求
//   }
//
//   ///点击刷新事件
//   refreshEventAction() {
//     if (isSearching) return;
//     _getNvrList();
//   }
//
//   //选择一个ip
//   selectNvrIpAction(DeviceEntity ip) {
//     if (ip.mac == null) return;
//     selectedNvrIp = ip;
//     isNvrNeeded = true;
//     notifyListeners();
//     //请求通道信息
//     String deviceCode =
//         DeviceUtils.getDeviceCodeByMacAddress(macAddress: selectedNvrIp!.mac!);
//     HttpQuery.share.homePageService.deviceDetailNvr(
//         deviceCode: deviceCode,
//         onSuccess: (data) {
//           nvrData = data ?? DeviceDetailNvrData();
//           notifyListeners();
//         });
//   }
//
//   // 安装NVR设备
//   installNvr({
//     String? pNodeCode,
//     required String deviceCode,
//     required String ip,
//     required String mac,
//     String? instanceId,
//     int? gateId,
//     int? passId,
//   }) {
//     HttpQuery.share.installService.nvrInstall(
//         pNodeCode: pNodeCode,
//         deviceCode: deviceCode,
//         ip: ip,
//         mac: mac,
//         instanceId: instanceId,
//         gateId: gateId,
//         passId: passId,
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: 'NVR安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: 'NVR安装失败: $error');
//         });
//   }
//
//   void _getNvrList() {
//     isSearching = true;
//     LoadingUtils.show(data: "正在获取当前网络下的NVR设备");
//     DeviceUtils.scanAndFetchDevicesInfo(deviceType: "NVR")
//         .then((List<DeviceEntity> data) {
//       for (var a in data) {
//         if (a.ip != null) {
//           nvrIpList.add(a);
//         }
//       }
//       LoadingUtils.dismiss();
//       isSearching = false;
//       notifyListeners();
//     });
//   }
// }
