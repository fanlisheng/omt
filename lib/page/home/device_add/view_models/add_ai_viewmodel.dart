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
import '../../../../services/install_cache_service.dart';
import '../../../../bean/install/install_cache_data.dart';

class AddAiViewModel extends BaseViewModelRefresh<dynamic> {
  final String pNodeCode;

  AddAiViewModel(this.pNodeCode);

  bool isInstall = false; //是否是安装 默认否
  
  // ===== 大门编号相关属性 =====
  int? gateId;
  String? instanceId;
  
  // ===== AI设备相关属性 =====
  List<DeviceDetailAiData> aiDeviceList = [DeviceDetailAiData()];
  List<TextEditingController> aiControllers = [TextEditingController()];
  bool isAiSearching = false;
  String? selectedAiIp;

  // List<DeviceEntity> aiSearchResults = [];
  bool stopAiScanning = false;
  
  // 缓存服务
  final InstallCacheService _cacheService = InstallCacheService.instance;

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
      try {
        controller.dispose();
      } catch (e) {
        // 忽略已经被释放的控制器
      }
    }
    try {
      super.dispose();
    } catch (e) {
    }
  }
  
  /// 同步aiControllers和aiDeviceList
  /// 确保控制器数量与设备列表匹配，并填充IP地址
  void syncControllersWithDeviceList() {
    // 调整控制器数量以匹配设备列表
    while (aiControllers.length < aiDeviceList.length) {
      aiControllers.add(TextEditingController());
    }
    while (aiControllers.length > aiDeviceList.length) {
      if (aiControllers.isNotEmpty) {
        aiControllers.removeLast().dispose();
      }
    }
    
    // 同步IP地址到控制器
    for (int i = 0; i < aiDeviceList.length && i < aiControllers.length; i++) {
      aiControllers[i].text = aiDeviceList[i].ip ?? '';
    }
    
    notifyListeners();
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
            _saveAiCache(); // 保存缓存
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
    _saveAiCache(); // 保存缓存
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
      // 先释放控制器再移除
      aiControllers[index].dispose();
      aiControllers.removeAt(index);
      _saveAiCache(); // 保存缓存
      notifyListeners();
    }
  }
  
  /// 保存AI设备缓存数据
  void _saveAiCache() async {
    try {
      final cacheData = await _cacheService.getCacheData();
      if (cacheData != null) {
        final updatedCacheData = InstallCacheData(
          currentStep: cacheData.currentStep,
          selectedInstance: cacheData.selectedInstance,
          selectedDoor: cacheData.selectedDoor,
          selectedInOut: cacheData.selectedInOut,
          selectedTags: cacheData.selectedTags,
          aiDeviceList: aiDeviceList,
          cameraDeviceList: cacheData.cameraDeviceList,
          nvrData: cacheData.nvrData,
          powerBoxData: cacheData.powerBoxData,
          powerData: cacheData.powerData,
          gateId: gateId,
          instanceId: instanceId,
          cameraInOutList: cacheData.cameraInOutList,
          cameraTypeList: cacheData.cameraTypeList,
          regulationList: cacheData.regulationList,
          isNvrNeeded: cacheData.isNvrNeeded,
          selectedNarInOut: cacheData.selectedNarInOut,
          nvrInOutList: cacheData.nvrInOutList,
          selectedNvr: cacheData.selectedNvr,
          nvrDeviceData: cacheData.nvrDeviceData,
          isPowerBoxNeeded: cacheData.isPowerBoxNeeded,
          selectedPowerBoxInOut: cacheData.selectedPowerBoxInOut,
          powerBoxInOutList: cacheData.powerBoxInOutList,
          selectedDeviceDetailPowerBox: cacheData.selectedDeviceDetailPowerBox,
          powerBoxList: cacheData.powerBoxList,
          portType: cacheData.portType,
          batteryMains: cacheData.batteryMains,
          battery: cacheData.battery,
          isCapacity80: cacheData.isCapacity80,
          selectedPowerInOut: cacheData.selectedPowerInOut,
          powerInOutList: cacheData.powerInOutList,
          selectedRouterType: cacheData.selectedRouterType,
          routerTypeList: cacheData.routerTypeList,
          routerIp: cacheData.routerIp,
          mac: cacheData.mac,
          exchangeDevices: cacheData.exchangeDevices,
          selectedExchangeInOut: cacheData.selectedExchangeInOut,
          createdAt: cacheData.createdAt,
        );
        
        _cacheService.saveCacheData(updatedCacheData);
      }
    } catch (e) {
      print('保存AI设备缓存数据失败: $e');
    }
  }
  
  /// 从缓存恢复AI设备数据
  void restoreFromCache() async {
    try {
      final cacheData = await _cacheService.getCacheData();
      if (cacheData != null) {
        gateId = cacheData.gateId;
        instanceId = cacheData.instanceId;
        
        // 恢复AI设备列表
        if (cacheData.aiDeviceList.isNotEmpty) {
          aiDeviceList.clear();
          aiDeviceList.addAll(cacheData.aiDeviceList);
          syncControllersWithDeviceList();
        }
        
        notifyListeners();
      }
    } catch (e) {
      print('从缓存恢复AI设备数据失败: $e');
    }
  }

  @override
  loadData(
      {ValueChanged? onSuccess,
      ValueChanged? onCache,
      ValueChanged<String>? onError}) {
    // AI设备的数据加载通过initState中的restoreFromCache完成
    // 这里可以触发成功回调
    if (onSuccess != null) {
      onSuccess(aiDeviceList);
    }
  }

}
