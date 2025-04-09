import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/test/test.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_nvr_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_power_box_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/http/http_query.dart';

import '../../../../utils/intent_utils.dart';
import '../../search_device/services/device_search_service.dart';

enum DeviceType {
  power, // 电源
  ai, // ai
  camera, //摄像头
  nvr,
  battery, // 电池
  powerBox, //电源箱
  exchange, //交互机
  router, //路由器
}

//
enum StepNumber {
  first,
  second,
  third,
  four,
}

class DeviceAddViewModel extends BaseViewModelRefresh<dynamic> {
  // 父节点code
  final String pNodeCode;

  DeviceAddViewModel(
    this.pNodeCode,
  );

  StepNumber stepNumber = StepNumber.first; //第几步
  DeviceType? deviceType; //设备类型
  bool isInstall = false; //是安装 默认否

  // 设备信息
  // String deviceCode = ''; // 设备编码
  // String deviceIp = ''; // 设备IP
  // String deviceMac = ''; // 设备MAC地址

  IdNameValue? deviceTypeSelected;
  List deviceTypes = [];

  // ===== 共用 进出口 =====
  List<IdNameValue> inOutList = [];

  // IdNameValue? selectedInOut;

  // ===== 电源设备相关属性 =====
  String portType = "";
  bool batteryMains = false; //市电
  bool battery = false; //电池
  IdNameValue? selectedPowerInOut;

  // ===== AI设备相关属性 =====
  List<DeviceDetailAiData> aiDeviceList = [DeviceDetailAiData()];
  List<TextEditingController> aiControllers = [TextEditingController()];
  bool isAiSearching = false;
  String? selectedAiIp;
  List<DeviceEntity> aiSearchResults = [];
  bool stopAiScanning = false;

  // ===== 摄像头相关属性 =====
  late final player = Player();
  late final videoController = VideoController(player);
  List<CameraDeviceEntity> cameraDeviceList = [CameraDeviceEntity()];
  List<TextEditingController> cameraControllers = [TextEditingController()];
  List<IdNameValue> cameraTypeList = [];
  List<String> entryExitList = ["共用进出口", "进出口1", "进出口2"];
  List<IdNameValue> regulationList = [];
  String selectedAiIpForCamera = "";

  // ===== NVR相关属性 =====
  List<DeviceEntity> nvrDeviceList = [DeviceEntity()];
  bool isNvrNeeded = true;
  DeviceEntity? selectedNvrIp;
  List<DeviceEntity> nvrIpList = [];
  DeviceDetailNvrData nvrData = DeviceDetailNvrData();
  bool isNvrSearching = false;
  IdNameValue? selectedNarInOut;

  // ===== 电源箱相关属性 =====
  IdNameValue? selectedPowerBoxInOut;
  DeviceDetailPowerBoxData? selectedDeviceDetailPowerBox;
  bool isPowerBoxNeeded = false;
  List<DeviceDetailPowerBoxData> powerBoxList = [];

  // ===== 电池/交换机相关属性 =====
  bool isCapacity80 = true;
  List<int> portNumber = [5, 8];
  int? selectedPortNumber;
  List<String> supplyMethod = ["POE", "DC", "AC"];
  String? selectedSupplyMethod;

  // ===== 路由器相关属性 =====
  IdNameValue? selectedRouterInOut;
  IdNameValue? selectedRouterType;
  List<IdNameValue> routerTypeList = [];
  TextEditingController routerIpController = TextEditingController();

  // ===== 网络环境相关属性 =====
  String selectedNetworkEnv = "";
  List<IdNameValue> networkEnvList = [];

  @override
  void initState() async {
    super.initState();
    deviceTypes = [
      IdNameValue(id: 1, name: "AI设备"),
      IdNameValue(id: 2, name: "摄像头"),
      IdNameValue(id: 3, name: "NVR"),
      IdNameValue(id: 4, name: "电源箱"),
      IdNameValue(id: 5, name: "交换机"),
      IdNameValue(id: 6, name: "电源"),
      IdNameValue(id: 7, name: "路由器"),
    ];
    routerTypeList = [
      IdNameValue(id: 6, name: "无线"),
      IdNameValue(id: 7, name: "有线")
    ];

    // 初始化NVR的进/出口列表
    HttpQuery.share.homePageService.getInOutList(
      onSuccess: (List<IdNameValue>? data) {
        inOutList = data ?? [];
        notifyListeners();
      },
    );

    // 初始化网络环境列表
    networkEnvList = [
      IdNameValue(id: 1, name: "环境1"),
      IdNameValue(id: 2, name: "环境2"),
      IdNameValue(id: 3, name: "环境3")
    ];
  }

  @override
  void dispose() {
    // 销毁所有控制器
    for (var controller in aiControllers) {
      controller.dispose();
    }
    for (var controller in cameraControllers) {
      controller.dispose();
    }
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
        deviceType = DeviceType.power;
        break;
      case 7:
        deviceType = DeviceType.router;
        break;
    }
    notifyListeners();
  }

  //上一步
  backStepEventAction() {
    switch (stepNumber) {
      case StepNumber.first:
        return;
      case StepNumber.second:
        stepNumber = StepNumber.first;
      case StepNumber.third:
        stepNumber = StepNumber.second;
      case StepNumber.four:
        stepNumber = StepNumber.third;
    }
    notifyListeners();
  }

  //下一步
  nextStepEventAction() async {
    switch (stepNumber) {
      case StepNumber.first:
        if ((deviceTypeSelected?.name ?? "").isEmpty) {
          return;
        }
        switch (deviceType) {
          case DeviceType.router:
            String? subnet = await DeviceUtils.getSubnet();
            if (null != subnet && subnet.isNotEmpty) {
              subnet = '$subnet.1';
              routerIpController.text = subnet;
            }
            break;
          case DeviceType.powerBox:
            // 初始化电源箱列表
            HttpQuery.share.installService.getUnboundPowerBox(
              onSuccess: (List<DeviceDetailPowerBoxData>? data) {
                powerBoxList = data ?? [];
                notifyListeners();
              },
            );
            String? subnet = await DeviceUtils.getSubnet();
            if (null != subnet && subnet.isNotEmpty) {
              subnet = '$subnet.1';
              routerIpController.text = subnet;
            }
            break;
          default:
            break;
        }
        stepNumber = StepNumber.second;
      case StepNumber.second:
        // 根据设备类型执行不同的操作
        switch (deviceType) {
          case DeviceType.ai:
            // 检查是否已连接AI设备
            if (aiDeviceList.isEmpty || aiDeviceList.first.mac == null) {
              LoadingUtils.showToast(data: '请先连接AI设备');
              return;
            }
            break;
          case DeviceType.camera:
            // 检查是否已连接摄像头
            if (cameraDeviceList.isEmpty) {
              LoadingUtils.showToast(data: '请先连接摄像头');
              return;
            }
            break;
          case DeviceType.nvr:
            // 检查是否已选择NVR
            if (selectedNarInOut == null) {
              LoadingUtils.showToast(data: '请先选择进出口');
              return;
            }
            if (selectedNvrIp == null) {
              LoadingUtils.showToast(data: '请先选择NVR设备');
              return;
            }
            installNvr(
                pNodeCode: pNodeCode,
                ip: selectedNvrIp!.ip ?? "",
                mac: selectedNvrIp!.mac ?? "",
                passId: selectedNarInOut!.id!);
            return;
          case DeviceType.powerBox:
            // 检查是否已选择电源箱
            if (selectedDeviceDetailPowerBox == null) {
              LoadingUtils.showToast(data: '请先选择电源箱');
              return;
            }
            break;
          case DeviceType.exchange:
            // 交换机需要检查参数
            if (selectedPortNumber == null || selectedSupplyMethod == null) {
              LoadingUtils.showToast(data: '请选择交换机接口数量和供电方式');
              return;
            }

            // 执行交换机安装
            installSwitch(
              pNodeCode: pNodeCode,
              interfaceNum: selectedPortNumber!,
              powerMethod: selectedSupplyMethod!,
            );
            return;
          case DeviceType.power:
            // 电源需要检查参数
            if (selectedPowerInOut?.id == null) {
              LoadingUtils.showToast(data: '请选择进出口');
              return;
            }
            if (batteryMains == false && battery == false) {
              LoadingUtils.showToast(data: '请选择电源类型');
              return;
            }

            // 执行电源安装
            installPower(
              pNodeCode: pNodeCode,
              hasBatteryMains: batteryMains,
              batteryCap: battery == false ? null : (isCapacity80 ? 80 : 160),
              type: selectedPowerInOut!.id!,
            );
            break;
          case DeviceType.router:
            // 路由器需要检查参数
            if (selectedRouterInOut?.id == null ||
                selectedRouterType?.id == null) {
              LoadingUtils.showToast(data: '请选择进出口/有线无线类型');
              return;
            }
            if (routerIpController.text.isEmpty) {
              LoadingUtils.showToast(data: '没有识别到路由器');
              return;
            }

            // 执行路由器安装
            installRouter(
              pNodeCode: pNodeCode,
              ip: routerIpController.text,
              type: selectedRouterType!.id!, // 默认类型
              passId: selectedRouterInOut!.id!,
            );
            return;
          default:
            break;
        }
        stepNumber = StepNumber.third;
      case StepNumber.third:
        if (deviceType == DeviceType.ai || deviceType == DeviceType.camera) {
          stepNumber = StepNumber.four;
        }
      //完成
      case StepNumber.four:
      //完成
    }
    notifyListeners();
  }

  // ===== AI设备相关方法 =====

  // 连接AI设备
  connectAiDeviceAction(int index) async {
    if (SysUtils.isIPAddress(aiControllers[index].text)) {
      //获取到mac
      LoadingUtils.show(data: "连接设备中...");
      String? mac = await DeviceUtils.getMacAddressByIp(
          ip: aiControllers[index].text,
          shouldStop: () {
            return false;
          });
      if (mac == null) {
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
              //只有一个
              aiDeviceList = [data];
            }
            notifyListeners();
            LoadingUtils.dismiss;
          });
    } else {
      LoadingUtils.showToast(data: '请输入正确的IP地址');
    }
  }

  // 开始搜索AI设备
  void startAiSearch() async {
    isAiSearching = true;
    aiSearchResults.clear();
    selectedAiIp = null;
    notifyListeners();
    // 扫描设备
    List<DeviceEntity> searchDevices = await DeviceSearchService()
        .scanDevices(shouldStop: _shouldStopAi, deviceType: "AI设备");
    if (_shouldStopAi()) {
      stopAiSearch();
      return;
    }
    List<DeviceEntity> aiDevices =
        searchDevices.where((device) => device.deviceType == 10).toList();
    // 搜索完成后调用：
    aiSearchResults = List.from(aiDevices); // 设置搜索结果
    isAiSearching = false;
    notifyListeners();
  }

  // 停止搜索AI设备
  void stopAiSearch() {
    isAiSearching = false;
    aiSearchResults = [];
    notifyListeners();
  }

  // 处理选中的AI设备IP
  void handleSelectedAiIp() {
    if (selectedAiIp != null) {
      // 将选中的IP填入第一个空的或新的输入框
      int targetIndex =
          aiControllers.indexWhere((controller) => controller.text.isEmpty);
      if (targetIndex == -1) {
        // 使用第一个输入框
        aiControllers[0].text = selectedAiIp!;
      } else {
        aiControllers[targetIndex].text = selectedAiIp!;
      }

      // 自动触发连接
      connectAiDeviceAction(targetIndex == -1 ? 0 : targetIndex);
    }
  }

  // 定义一个停止条件的回调函数
  bool _shouldStopAi() {
    return stopAiScanning; // 当 stopAiScanning 为 true 时停止
  }

  // 安装AI设备和摄像头
  installAiDeviceAndCamera({
    String? pNodeCode,
    String? instanceId,
    int? gateId,
    int? passId,
    required Map<String, dynamic> aiDevice,
    required Map<String, dynamic> camera,
  }) {
    HttpQuery.share.installService.aiDeviceCameraInstall(
        pNodeCode: pNodeCode,
        instanceId: instanceId,
        gateId: gateId,
        passId: passId,
        aiDevice: aiDevice,
        camera: camera,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '安装成功');
        },
        onError: (error) {
          LoadingUtils.showToast(data: '安装失败: $error');
        });
  }

  // ===== 摄像头相关方法 =====

  // 连接摄像头
  connectCameraAction() {
    if (cameraDeviceList.isNotEmpty) {
      cameraDeviceList.first.rtsp = cameraDeviceList.first.rtspController.text;
      notifyListeners();
    }
  }

  // 完成摄像头设置
  completeCameraAction() {
    if (cameraDeviceList.isNotEmpty) {
      cameraDeviceList.first.readOnly = true;
      notifyListeners();
    }
  }

  // 重启识别
  restartRecognitionAction() {
    notifyListeners();
  }

  // 图片预览
  photoPreviewAction() {
    notifyListeners();
  }

  // 删除摄像头
  deleteCameraAction(int index) {
    notifyListeners();
  }

  // 编辑摄像头
  editCameraAction(int index) {
    notifyListeners();
  }

  // ===== NVR相关方法 =====

  // 刷新NVR列表
  refreshNvrAction() {
    if (isNvrSearching) return;
    _getNvrList();
  }

  // 选择一个NVR IP
  selectNvrIpAction(DeviceEntity ip) {
    if (ip.mac == null || ip == selectedNvrIp) return;
    selectedNvrIp = ip;
    isNvrNeeded = true;
    notifyListeners();
    //请求通道信息
    String deviceCode =
        DeviceUtils.getDeviceCodeByMacAddress(macAddress: selectedNvrIp!.mac!);
    HttpQuery.share.homePageService.deviceDetailNvr(
        deviceCode: deviceCode,
        onSuccess: (data) {
          nvrData = data ?? DeviceDetailNvrData();
          notifyListeners();
        });
  }

  // 获取NVR列表
  void _getNvrList() {
    isNvrSearching = true;
    notifyListeners();
    LoadingUtils.show(data: "正在获取当前网络下的NVR设备");
    DeviceUtils.scanAndFetchDevicesInfo(deviceType: "NVR")
        .then((List<DeviceEntity> data) {
      LoadingUtils.show(data: "正在获取当前网络下的NVR设备");
      nvrIpList.clear();
      for (var a in data) {
        if (a.ip != null) {
          nvrIpList.add(a);
        }
      }
      isNvrSearching = false;
      notifyListeners();
      LoadingUtils.dismiss();
    });
  }

  // 安装NVR设备
  installNvr({
    required String pNodeCode,
    required String ip,
    required String mac,
    String? instanceId,
    int? gateId,
    required int passId,
  }) {
    HttpQuery.share.installService.nvrInstall(
        pNodeCode: pNodeCode,
        ip: ip,
        mac: mac,
        instanceId: instanceId,
        gateId: gateId,
        passId: passId,
        onSuccess: (data) {
          LoadingUtils.showToast(data: 'NVR安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: 'NVR安装失败: $error');
        });
  }

  /// ===== 电源箱相关方法 =====

  //选择电源箱code
  selectedPowerBoxCode(DeviceDetailPowerBoxData? a) {
    HttpQuery.share.homePageService.deviceDetailPowerBox(
        nodeCode: a?.deviceCode ?? "",
        onSuccess: (data) {
          selectedDeviceDetailPowerBox = selectedDeviceDetailPowerBox;
        });
    notifyListeners();
  }

  // 安装电源箱
  installPowerBox({
    String? pNodeCode,
    required String deviceCode,
    required String ip,
    required String mac,
    String? instanceId,
    int? gateId,
    int? passId,
  }) {
    HttpQuery.share.installService.powerBoxInstall(
        pNodeCode: pNodeCode,
        deviceCode: deviceCode,
        ip: ip,
        mac: mac,
        instanceId: instanceId,
        gateId: gateId,
        passId: passId,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '电源箱安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '电源箱安装失败: $error');
        });
  }

  // 安装电源信息
  installPower({
    String? pNodeCode,
    required bool hasBatteryMains, //有市电
    required int type,
    int? batteryCap,
  }) {
    HttpQuery.share.installService.powerInstall(
        pNodeCode: pNodeCode,
        hasBatteryMains: hasBatteryMains,
        type: type,
        batteryCap: batteryCap,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '电源信息安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '电源信息安装失败: $error');
        });
  }

  // ===== 电池/交换机相关方法 =====

  // 安装交换机
  installSwitch({
    String? pNodeCode,
    required int interfaceNum,
    required String powerMethod,
  }) {
    HttpQuery.share.installService.switchInstall(
        pNodeCode: pNodeCode,
        interfaceNum: interfaceNum,
        powerMethod: powerMethod,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '交换机安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '交换机安装失败: $error');
        });
  }

  // 安装电池
  installBattery({
    String? pNodeCode,
    required int capacity,
  }) {
    // HttpQuery.share.installService.batteryInstall(
    //     pNodeCode: pNodeCode,
    //     capacity: capacity,
    //     onSuccess: (data) {
    //       LoadingUtils.showToast(data: '电池安装成功');
    //     },
    //     onError: (error) {
    //       LoadingUtils.showToast(data: '电池安装失败: $error');
    //     });
  }

  // 安装路由器
  installRouter({
    String? pNodeCode,
    required String ip,
    required int type,
    required int passId,
  }) {
    HttpQuery.share.installService.routerInstall(
        pNodeCode: pNodeCode,
        type: type,
        ip: ip,
        passId: passId,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '路由器安装成功');
          IntentUtils.share.popResultOk(context!);
        },
        onError: (error) {
          LoadingUtils.showToast(data: '路由器安装失败: $error');
        });
  }

  _getCameraTypeList() {
    HttpQuery.share.installService.getCameraType(onSuccess: (data) {
      cameraTypeList = data ?? [];
    });
  }

  _getCameraStatusList() {
    HttpQuery.share.installService.getCameraStatus(onSuccess: (data) {
      regulationList = data ?? [];
    });
  }
}
