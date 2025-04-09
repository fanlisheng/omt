import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_detail_ai_entity.dart';
import 'package:omt/bean/home/home_page/device_detail_camera_entity.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/utils/result.dart';

import '../../../../bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../bean/home/home_page/device_detail_power_entity.dart';
import '../../../../bean/home/home_page/device_unbound_entity.dart';

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

  get _cameraPhotoList => '${API.share.host}api/device/camera/snap_list';

  get _setCameraBasicPhoto =>
      '${API.share.host}api/device/camera/set_basic_photo';

  get _getUnboundDevices => '${API.share.host}api/device/devices';

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
    String? nodeCode,
    String? deviceCode,
    required ValueChanged<DeviceDetailAiData?> onSuccess,
    ValueChanged<DeviceDetailAiData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeCode != null) {
      params["node_code"] = deviceCode;
    }
    if (deviceCode != null) {
      params["device_code"] = deviceCode;
    }
    HttpManager.share.doHttpPost<DeviceDetailAiData>(
      await _deviceDetailAi,
      {
        "node_code": nodeCode,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailNvr({
    String? nodeCode,
    String? deviceCode, //mac地址去掉间隔小写
    required ValueChanged<DeviceDetailNvrData?> onSuccess,
    ValueChanged<DeviceDetailNvrData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeCode != null) {
      params["node_code"] = nodeCode;
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
    String? nodeCode,
    String? deviceCode, //mac地址去掉间隔小写
    required ValueChanged<DeviceDetailPowerBoxData?> onSuccess,
    ValueChanged<DeviceDetailPowerBoxData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    if (nodeCode != null) {
      params["node_code"] = nodeCode;
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
    required String nodeCode,
    required ValueChanged<DeviceDetailPowerData?> onSuccess,
    ValueChanged<DeviceDetailPowerData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailPowerData>(
      await _deviceDetailPower,
      {
        "node_code": nodeCode,
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
    required String nodeCode,
    required ValueChanged<DeviceDetailExchangeData?> onSuccess,
    ValueChanged<DeviceDetailExchangeData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailExchangeData>(
      await _deviceDetailExchange,
      {
        "node_code": nodeCode,
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
    required String nodeCode,
    required ValueChanged<DeviceDetailCameraData?> onSuccess,
    ValueChanged<DeviceDetailCameraData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailCameraData>(
      await _deviceDetailCamera,
      {
        "node_code": nodeCode,
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
    required ValueChanged<CodeMessageData?>? onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _setCameraBasicPhoto,
      {"device_code": deviceCode, "type": type, "url": url},
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
