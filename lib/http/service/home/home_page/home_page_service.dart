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

  get _gateList => '${API.share.host}/api/gate/list';

  get _deviceScan => '${API.share.host}api/device/scan';

  get _bindGate => '${API.share.host}/api/device/bind_gate';

  get _deviceDetailAi => '${API.share.host}api/device/ai_device/detail';

  get _deviceDetailNvr => '${API.share.host}api/device/nvr/detail';

  get _deviceDetailPowerBox => '${API.share.host}api/device/power_box/detail';

  get _deviceDetailPower => '${API.share.host}api/device/power/detail';

  get _deviceDetailExchange => '${API.share.host}api/device/switch/detail';

  get _deviceDetailCamera => '${API.share.host}api/device/camera/detail';

  getInstanceList(String areaCode, {
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    String url = await _instanceList;
    HttpManager.share.doHttpPost<List<IdNameValue>>(
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

  deviceScan({
    required String instanceId,
    required List<DeviceEntity> deviceList,
    required ValueChanged<List<DeviceEntity>?>? onSuccess,
    ValueChanged<List<DeviceEntity>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    List devices = [];
    for (DeviceEntity device in deviceList){
      devices.add({
        "device_type": device.deviceType ?? 0,
        "ip": device.ip ?? "",
        "device_code": device.deviceCode ?? "",
        "mac": device.mac ?? ""
      });
    }

    HttpManager.share.doHttpPost<List<DeviceEntity>>(
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

  bindGate(int instanceId,
      int gateId,
      List<DeviceEntity> deviceList, {
        required ValueChanged<CodeMessageData?> onSuccess,
        ValueChanged<CodeMessageData?>? onCache,
        ValueChanged<String>? onError,
      }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _bindGate,
      {"instance_id": instanceId, "gate_id": gateId, "devices": deviceList},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceDetailAi({
    required String nodeCode,
    required ValueChanged<DeviceDetailAiData?> onSuccess,
    ValueChanged<DeviceDetailAiData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
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
    required String nodeCode,
    required ValueChanged<DeviceDetailNvrData?> onSuccess,
    ValueChanged<DeviceDetailNvrData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailNvrData>(
      await _deviceDetailNvr,
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

  deviceDetailPowerBox({
    required String nodeCode,
    required ValueChanged<DeviceDetailPowerBoxData?> onSuccess,
    ValueChanged<DeviceDetailPowerBoxData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<DeviceDetailPowerBoxData>(
      await _deviceDetailPowerBox,
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
