import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';

///
///  omt
///  install.dart
///  设备安装服务
///
///  Created on 2024-07-06
///  Copyright © 2024 .. All rights reserved.
///

class InstallService {
  get _aiDeviceCameraInstall => '${API.share.host}api/device/ai_device_camera/install';
  get _nvrInstall => '${API.share.host}api/device/nvr/install';
  get _switchInstall => '${API.share.host}api/device/switch/install';
  get _routerInstall => '${API.share.host}api/device/router/install';
  get _powerBoxInstall => '${API.share.host}api/device/power_box/install';
  get _powerInstall => '${API.share.host}api/device/power/install';

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
    required String deviceCode,
    required String ip,
    required String mac,
    required String interfaceNum,
    required String powerMethod,
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
      "interface_num": interfaceNum,
      "power_method": powerMethod,
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
    required String deviceCode,
    required String ip,
    required String mac,
    required int type,
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
      "type": type,
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
    String? instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {};

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
} 