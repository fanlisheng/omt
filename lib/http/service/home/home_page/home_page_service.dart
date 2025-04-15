import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_camera_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_router_entity_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/utils/result.dart';

import '../../../../bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_entity.dart';
import '../../../../bean/home/home_page/device_unbound_entity.dart';
import '../../../../bean/video/video_configuration/Video_Connect_entity.dart';
import '../../../../utils/json_utils.dart';

// import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  home_page_service.dart
///  首页
///
///  Created by kayoxu on 2024-03-05 at 15:06:35
///  Copyright © 2024 .. All rights reserved.
///

class HomePageService {
  get _list async => '${API.share.host}xxx/xxx';

  get _detail async => '${API.share.host}xxx/xxx';

  get _instanceList => '${API.share.host}api/entity/instance/list';

  get _gateList => '${API.share.host}api/entity/gate/list';

  get _inOutList => '${API.share.host}api/entity/pass/list';

  get _deviceScan => '${API.share.host}api/device/scan';

  get _bindGate => '${API.share.host}api/device/bind_gate';

  get _deviceDetailAi => '${API.share.host}api/device/ai_device/detail';

  get _deviceDetailNvr => '${API.share.host}api/device/nvr/detail';

  get _deviceDetailPowerBox => '${API.share.host}api/device/power_box/detail';

  get _deviceDetailPower => '${API.share.host}api/device/power/detail';

  get _deviceDetailExchange => '${API.share.host}api/device/switch/detail';

  get _deviceDetailCamera => '${API.share.host}api/device/camera/detail';

  get _deviceDetailRouter => '${API.share.host}api/device/router/detail';

  get _cameraPhotoList => '${API.share.host}api/device/camera/snap_list';

  get _setCameraBasicPhoto =>
      '${API.share.host}api/device/camera/set_basic_photo';

  get _getUnboundDevices => '${API.share.host}api/device/devices';

  get _restartAiDevice => '${API.share.host}api/device/ai_device/restart';

  get _upgradeAiDeviceProgram =>
      '${API.share.host}api/device/ai_device/upgrade_program';

  get _upgradeAiDeviceIdentity =>
      '${API.share.host}api/device/ai_device/upgrade_identity';

  get _manualSnapCamera => '${API.share.host}api/device/camera/manual_snap';

  get _restartPowerBox => '${API.share.host}api/device/power_box/restart';

  get _dcInterfaceControl =>
      '${API.share.host}api/device/power_box/dc_interface_control';

  get _deleteNvrChannel => '${API.share.host}api/device/nvr/delete_channel';

  /// 电源箱DC接口绑定设备类型数据字典
  get _dcInterfaceDeviceTypeMap =>
      '${API.share.host}api/device/power_box/dc_interface/device_type_map';

  /// 电源箱DC接口绑定设备
  get _dcInterfaceBindDevice =>
      '${API.share.host}api/device/power_box/dc_interface/bind_device';

  /// 新增编辑接口URL
  get _editCamera => '${API.share.host}api/device/camera/edit';

  get _editNvr => '${API.share.host}api/device/nvr/edit';

  get _editPowerBox => '${API.share.host}api/device/power_box/edit';

  get _editRouter => '${API.share.host}api/device/router/edit';

  get _editSwitch => '${API.share.host}api/device/switch/edit';

  get _editPower => '${API.share.host}api/device/power/edit';

  /// 替换设备
  get _replaceAi => '${API.share.host}api/device/ai_device/replace';

  get _replaceNvr => '${API.share.host}api/device/nvr/replace';

  get _replacePowerBox => '${API.share.host}api/device/power_box/replace';

  //_configAi
  get _configAi async =>
      '${await API.share.hostVideoConfiguration}/webcam/save';

  getInstanceList(
    String areaCode, {
    required ValueChanged<List<StrIdNameValue>?>? onSuccess,
    ValueChanged<List<StrIdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    String url = await _instanceList;
    HttpManager.share.doHttpPost<List<StrIdNameValue>>(
      url,
      {"area_code": areaCode},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getGateList({
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _gateList,
      {},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getInOutList({
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _inOutList,
      {},
      method: 'GET',
      autoHideDialog: false,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceScan({
    required String instanceId,
    required List<DeviceEntity> deviceList,
    required ValueChanged<DeviceScanEntity?>? onSuccess,
    ValueChanged<DeviceScanEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    List devices = [];
    for (DeviceEntity device in deviceList) {
      devices.add({
        "device_type": device.deviceType ?? 0,
        "ip": device.ip ?? "",
        "device_code": device.deviceCode ?? "",
        "mac": device.mac ?? ""
      });
    }

    HttpManager.share.doHttpPost<DeviceScanEntity>(
      await _deviceScan,
      {"instance_id": instanceId, "devices": devices},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  bindGate({
    required String instanceId,
    required int gateId,
    required List<DeviceEntity> deviceList,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    List devices = [];
    for (DeviceEntity device in deviceList) {
      devices.add({
        "device_type": device.deviceType ?? 0,
        "ip": device.ip ?? "",
        "device_code": device.deviceCode ?? "",
        "mac": device.mac ?? ""
      });
    }
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _bindGate,
      {"instance_id": instanceId, "gate_id": gateId, "devices": devices},
      method: 'POST',
      autoHideDialog: false,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailAi({
    String? nodeId,
    String? deviceCode,
    required ValueChanged<DeviceDetailAiData?> onSuccess,
    ValueChanged<DeviceDetailAiData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeId != null) {
      params["node_id"] = nodeId.toInt();
    }
    if (deviceCode != null) {
      params["device_code"] = deviceCode;
    }
    HttpManager.share.doHttpPost<DeviceDetailAiData>(
      await _deviceDetailAi,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailNvr({
    String? nodeId,
    String? deviceCode, //mac地址去掉间隔小写
    required ValueChanged<DeviceDetailNvrData?> onSuccess,
    ValueChanged<DeviceDetailNvrData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeId != null) {
      params["node_id"] = nodeId.toInt();
    }
    if (deviceCode != null) {
      params["device_code"] = deviceCode;
    }
    HttpManager.share.doHttpPost<DeviceDetailNvrData>(
      await _deviceDetailNvr,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailPowerBox({
    String? nodeId,
    String? deviceCode, //mac地址去掉间隔小写
    required ValueChanged<DeviceDetailPowerBoxData?> onSuccess,
    ValueChanged<DeviceDetailPowerBoxData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeId != null) {
      params["node_id"] = nodeId.toInt();
    }
    if (deviceCode != null) {
      params["device_code"] = deviceCode;
    }
    HttpManager.share.doHttpPost<DeviceDetailPowerBoxData>(
      await _deviceDetailPowerBox,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailPower({
    required String nodeId,
    required ValueChanged<DeviceDetailPowerData?> onSuccess,
    ValueChanged<DeviceDetailPowerData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailPowerData>(
      await _deviceDetailPower,
      {
        "node_id": nodeId.toInt(),
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailExchange({
    required String nodeId,
    required ValueChanged<DeviceDetailExchangeData?> onSuccess,
    ValueChanged<DeviceDetailExchangeData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailExchangeData>(
      await _deviceDetailExchange,
      {
        "node_id": nodeId.toInt(),
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailCamera({
    required String nodeId,
    required ValueChanged<DeviceDetailCameraData?> onSuccess,
    ValueChanged<DeviceDetailCameraData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailCameraData>(
      await _deviceDetailCamera,
      {
        "node_id": nodeId.toInt(),
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailRouter({
    required String nodeId,
    required ValueChanged<DeviceDetailRouterData?> onSuccess,
    ValueChanged<DeviceDetailRouterData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailRouterData>(
      await _deviceDetailRouter,
      {
        "node_id": nodeId.toInt(),
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  cameraPhotoList({
    required int page,
    required String deviceCode,
    required int type,
    required List<String> snapAts,
    required ValueChanged<DeviceDetailCameraSnapList?>? onSuccess,
    ValueChanged<DeviceDetailCameraSnapList?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailCameraSnapList>(
      await _cameraPhotoList,
      {
        "page": page,
        "limit": 8,
        "device_code": deviceCode,
        "type": type,
        "snap_ats": snapAts,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  setCameraBasicPhoto({
    required String deviceCode,
    required int type,
    required String url,
    String? nodeId,
    required ValueChanged<CodeMessageData?>? onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "device_code": deviceCode,
      "type": type,
      "url": url,
    };

    if (nodeId != null) {
      params["node_id"] = nodeId.toInt();
    }
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _setCameraBasicPhoto,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getUnboundDevices({
    required String instanceId,
    required ValueChanged<DeviceUnboundEntity?>? onSuccess,
    ValueChanged<DeviceUnboundEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceUnboundEntity>(
      await _getUnboundDevices,
      {
        "instance_id": instanceId,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 重启AI设备
  restartAiDevice({
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _restartAiDevice,
      {
        'device_code': deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 升级AI设备主程版本
  upgradeAiDeviceProgram({
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _upgradeAiDeviceProgram,
      {
        'device_code': deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 升级AI设备识别版本
  upgradeAiDeviceIdentity({
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _upgradeAiDeviceIdentity,
      {
        'device_code': deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 摄像头手动抓拍
  manualSnapCamera({
    required String aiDeviceCode,
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _manualSnapCamera,
      {
        'ai_device_code': aiDeviceCode,
        'device_code': deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 重启电源箱
  restartPowerBox({
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _restartPowerBox,
      {
        'device_code': deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 开关电源箱DC接口
  /// [status] 1：关闭；2：打开
  dcInterfaceControl({
    required String deviceCode,
    required List<int> ids,
    required int status,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _dcInterfaceControl,
      {
        'device_code': deviceCode,
        'ids': ids,
        'status': status,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 获取电源箱DC接口绑定设备类型数据字典
  getDcInterfaceDeviceTypeMap({
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _dcInterfaceDeviceTypeMap,
      {},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 电源箱DC接口绑定设备
  dcInterfaceBindDevice({
    required String deviceCode,
    required int id,
    required int deviceType,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _dcInterfaceBindDevice,
      {
        'device_code': deviceCode,
        'id': id,
        'device_type': deviceType,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 删除NVR通道
  deleteNvrChannel({
    required String deviceCode,
    required List<Map> channels,
    String? nodeId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      'device_code': deviceCode,
      'channels': channels,
    };

    if (nodeId != null) {
      params["node_id"] = nodeId.toInt();
    }
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _deleteNvrChannel,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  // 新增编辑接口方法

  // 摄像头修改
  editCamera({
    required int nodeId,
    required String name,
    required int cameraType,
    required int passId,
    required int controlStatus,
    String? cameraCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "node_id": nodeId,
      "name": name,
      "camera_type": cameraType,
      "pass_id": passId,
      "control_status": controlStatus,
    };

    if (cameraCode != null && cameraCode.isNotEmpty) {
      params["camera_code"] = cameraCode;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editCamera,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  // NVR修改
  editNvr({
    required int nodeId,
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editNvr,
      {
        "node_id": nodeId,
        "pass_id": passId,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  // 电源箱修改
  editPowerBox({
    required int nodeId,
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editPowerBox,
      {
        "node_id": nodeId,
        "pass_id": passId,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  // 路由器修改
  editRouter({
    required int nodeId,
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editRouter,
      {
        "node_id": nodeId,
        "pass_id": passId,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  // 交换机修改
  editSwitch({
    required int nodeId,
    required int passId,
    required int interfaceNum,
    required String powerMethod,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editSwitch,
      {
        "node_id": nodeId,
        "pass_id": passId,
        "interface_num": interfaceNum,
        "power_method": powerMethod,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  editPower({
    required int nodeId,
    required int passId,
    required List<int> powerType,
    int? batteryCapacity,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "node_id": nodeId,
      "pass_id": passId,
      "PowerType": powerType,
    };

    if (batteryCapacity != null) {
      params["battery_capacity"] = batteryCapacity;
    }
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _editPower,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  replaceAi({
    required int nodeId,
    required String ip,
    required String mac,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _replaceAi,
      {
        "node_id": nodeId,
        "ip": ip,
        "mac": mac,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  replaceNvr({
    required int nodeId,
    required String ip,
    required String mac,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _replaceNvr,
      {
        "node_id": nodeId,
        "ip": ip,
        "mac": mac,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  replacePowerBox({
    required int nodeId,
    required String deviceCode,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _replacePowerBox,
      {
        "node_id": nodeId,
        "device_code": deviceCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  configAi({
    required VideoInfoCamEntity? data,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      await _configAi,
      JsonUtils.getMap(data.toJson2()),
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

//
// detail(
//   Map map, {
//   ValueChanged<DetailEntity?>? onSuccess,
//   ValueChanged<DetailEntity?>? onCache,
//   ValueChanged<String>? onError,
// }) async {
//   map.addAll({'fullData': true});
//   HttpManager.share.doHttpPost<DetailEntity>(
//     await _detail,
//     map,
//     method: 'GET',
//     autoHideDialog: false,
//     autoShowDialog: false,
//     onSuccess: onSuccess,
//     onCache: onCache,
//     onError: onError,
//   );
// }
}
