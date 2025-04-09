import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../bean/home/home_page/device_detail_power_box_entity.dart';

///
///  omt
///  install.dart
///  设备安装服务
///
///  Created on 2024-07-06
///  Copyright © 2024 .. All rights reserved.
///

class InstallService {
  get _aiDeviceCameraInstall =>
      '${API.share.host}api/device/ai_device_camera/install';

  get _nvrInstall => '${API.share.host}api/device/nvr/install';

  get _switchInstall => '${API.share.host}api/device/switch/install';

  get _routerInstall => '${API.share.host}api/device/router/install';

  get _powerBoxInstall => '${API.share.host}api/device/power_box/install';

  get _powerInstall => '${API.share.host}api/device/power/install';

  get _getUnboundPowerBox =>
      '${API.share.host}api/device/power_box/unbound_list';

  get _getCameraStatus =>
      '${API.share.host}api/device/camera/control_status_map';

  get _getCameraType =>
      '${API.share.host}api/device/camera/camera_type_map';

  /// AI设备和摄像头安装
  aiDeviceCameraInstall({
    String? pNodeCode,
    String? instanceId,
    int? gateId,
    int? passId,
    required Map<String, dynamic> aiDevice,
    required Map<String, dynamic> camera,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "ai_device": aiDevice,
      "camera": camera,
    };

    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }
    if (instanceId != null) {
      params["instance_id"] = instanceId;
    }
    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _aiDeviceCameraInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// NVR安装
  nvrInstall({
    String? pNodeCode,
    required String ip,
    required String mac,
    String? instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "ip": ip,
      "mac": mac,
    };

    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }
    if (instanceId != null) {
      params["instance_id"] = instanceId;
    }
    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _nvrInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 交换机安装
  switchInstall({
    String? pNodeCode,
    required int interfaceNum,
    required String powerMethod,
    String? instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "interface_num": interfaceNum,
      "power_method": powerMethod,
    };

    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _switchInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 路由器安装
  routerInstall({
    String? pNodeCode,
    required String ip,
    required int type,
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "ip": ip,
      "type": type,
      "pass_id": passId,
    };

    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _routerInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 电源箱安装
  powerBoxInstall({
    String? pNodeCode,
    required String deviceCode,
    required String ip,
    required String mac,
    String? instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "device_code": deviceCode,
      "ip": ip,
      "mac": mac,
    };

    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }
    if (instanceId != null) {
      params["instance_id"] = instanceId;
    }
    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _powerBoxInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 电源信息安装
  powerInstall({
    String? pNodeCode,
    required bool hasBatteryMains, //有市电
    int? batteryCap, //电池信息
    required int type,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    List<Map<String, dynamic>> items = [];

    if (hasBatteryMains == true) {
      items.add({"type": 12});
    }

    if (batteryCap != null) {
      items.add({"type": 13, "battery_cap": batteryCap});
    }
    Map<String, dynamic> params = {
      "items": items,
      "type": type,
    };
    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _powerInstall,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 未绑定实例电源箱列表
  getUnboundPowerBox({
    required ValueChanged<List<DeviceDetailPowerBoxData>?> onSuccess,
    ValueChanged<List<DeviceDetailPowerBoxData>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

    HttpManager.share.doHttpPost<List<DeviceDetailPowerBoxData>>(
      await _getUnboundPowerBox,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getCameraType({
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _getCameraType,
      {},
      method: 'GET',
      autoHideDialog: false,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getCameraStatus({
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _getCameraStatus,
      {},
      method: 'GET',
      autoHideDialog: false,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }
}
