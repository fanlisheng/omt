// import 'package:kayo_package/kayo_package.dart';
// import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
// import 'package:omt/bean/common/code_data.dart';
// import 'package:omt/http/http_query.dart';
// import 'device_add_viewmodel.dart';
//
// class AddBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {
//   final DeviceType deviceType;
//   final StepNumber stepNumber;
//   final bool isInstall; //是安装 默认否
//   AddBatteryExchangeViewModel(this.deviceType, this.stepNumber, this.isInstall);
//
//   // 容量80
//   bool isCapacity80 = true;
//
//   List<String> portNumber = ["5口", "8口"];
//   String? selectedPortNumber;
//
//   List<String> supplyMethod = ["POE", "DC", "AC"];
//   String? selectedSupplyMethod;
//
//   @override
//   void initState() async {
//     super.initState();
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
//   // 安装交换机
//   installSwitch({
//     String? pNodeCode,
//     required String interfaceNum,
//     required String powerMethod,
//   }) {
//     HttpQuery.share.installService.switchInstall(
//         pNodeCode: pNodeCode,
//         interfaceNum: interfaceNum,
//         powerMethod: powerMethod,
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: '交换机安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: '交换机安装失败: $error');
//         });
//   }
//
//   // 安装路由器
//   installRouter({
//     String? pNodeCode,
//     String? ip,
//     required int type,
//     String? instanceId,
//     int? gateId,
//     int? passId,
//   }) {
//     HttpQuery.share.installService.routerInstall(
//         pNodeCode: pNodeCode,
//         type: type,
//         ip: "192.168.101.1",
//         onSuccess: (data) {
//           LoadingUtils.showToast(data: '路由器安装成功');
//         },
//         onError: (error) {
//           LoadingUtils.showToast(data: '路由器安装失败: $error');
//         });
//   }
// }
