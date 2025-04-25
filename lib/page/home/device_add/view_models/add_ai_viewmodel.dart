import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../../utils/dialog_utils.dart';
import '../../search_device/services/device_search_service.dart';
import '../widgets/ai_search_view.dart';

class AddAiViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;

  AddAiViewModel(this.pNodeCode);

  bool isInstall = false; //是否是安装 默认否
  // ===== AI设备相关属性 =====
  List<DeviceDetailAiData> aiDeviceList = [DeviceDetailAiData()];
  List<TextEditingController> aiControllers = [TextEditingController()];
  bool isAiSearching = false;
  String? selectedAiIp;

  // List<DeviceEntity> aiSearchResults = [];
  bool stopAiScanning = false;

  @override
  void initState() {
    super.initState();
    isInstall = pNodeCode.isEmpty;
    notifyListeners();
  }

  @override
  void dispose() {
    // 销毁所有控制器
    for (var controller in aiControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 连接AI设备
  connectAiDeviceAction(int index) async {

    //改变别的设备成已完成
    for (int i = 0 ; i < aiDeviceList.length ; i ++){
      if(i != index ){
        String mac = aiDeviceList[i].mac ?? "";
        if(mac.isNotEmpty){
          aiDeviceList[i].end = true;
        }
      }
    }
    notifyListeners();

    if (SysUtils.isIPAddress(aiControllers[index].text)) {
      //获取到mac
      LoadingUtils.show(data: "连接设备中...");
      String? mac = await DeviceUtils.getMacAddressByIp(
          ip: aiControllers[index].text,
          shouldStop: () {
            return false;
          });
      if (mac == null) {
        LoadingUtils.dismiss();
        LoadingUtils.showToast(data: '该设备不在线');
        return;
      }
      //请求设备信息
      String deviceCode =
          DeviceUtils.getDeviceCodeByMacAddress(macAddress: mac);
      HttpQuery.share.homePageService.deviceDetailAi(
          deviceCode: deviceCode,
          onSuccess: (DeviceDetailAiData? data) {
            if (data != null) {
              data.mac = mac;
              data.ip = aiControllers[index].text;
              data.enabled = true;
              if (index < aiDeviceList.length) {
                aiDeviceList[index] = data;
              }
            }
            notifyListeners();
            LoadingUtils.dismiss;
          });
    } else {
      LoadingUtils.showToast(data: '请输入正确的IP地址');
    }
  }

  // 开始搜索AI设备
  void startAiSearch(int rowIndex) async {
    showAiSearchDialog(context!).then((ip) {
      selectedAiIp = ip;
      handleSelectedAiIp(rowIndex);
    });
  }

  // 添加
  void addAiAction() {
    if((aiDeviceList.last.mac?.isEmpty ?? true) || (aiDeviceList.last.ip?.isEmpty ?? true)){
      LoadingUtils.showInfo(data: '请先把上面AI设备信息完善');
      return;
    }
    aiDeviceList.add(DeviceDetailAiData());
    aiControllers.add(TextEditingController());
    for (DeviceDetailAiData aiData in aiDeviceList) {
      aiData.enabled = false;
    }
    aiDeviceList.last.enabled = true;
    notifyListeners();
  }

  //删除
  deleteAiAction(int index) async{
    final result = await DialogUtils.showContentDialog(
        context: context!,
        title: "确定删除",
        content: "确定删除该Ai设备？",
        deleteText: "确定");
    if (result == '取消') return;
    removeAiDataForIndex(index);
  }

  // 处理选中的AI设备IP
  void handleSelectedAiIp(int rowIndex) {
    if (selectedAiIp != null && rowIndex < aiControllers.length) {
      aiControllers[rowIndex].text = selectedAiIp!;
      // 自动触发连接
      connectAiDeviceAction(rowIndex);
    }
  }


  ///私有方法
  //移除index对应的数据
  removeAiDataForIndex(int index){
    if( index < aiDeviceList.length && index < aiControllers.length){
      aiDeviceList.removeAt(index);
      aiControllers.removeAt(index);
      notifyListeners();
    }
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {
    // TODO: implement loadData
    throw UnimplementedError();
  }

}
