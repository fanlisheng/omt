import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../bean/one_picture/one_picture/one_picture_data_entity.dart';

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
      '${API.share.host}api/device/aidevice_camera/install';

  get _nvrInstall => '${API.share.host}api/device/nvr/install';

  get _switchInstall => '${API.share.host}api/device/switch/install';

  get _routerInstall => '${API.share.host}api/device/router/install';

  get _powerBoxInstall => '${API.share.host}api/device/power_box/install';

  get _powerInstall => '${API.share.host}api/device/power/install';

  get _getUnboundPowerBox =>
      '${API.share.host}api/device/power_box/unbound_list';

  get _getCameraStatus =>
      '${API.share.host}api/device/camera/control_status_map';

  get _getCameraType => '${API.share.host}api/device/camera/camera_type_map';

  get _installStep1 => '${API.share.host}api/device/install/step1';

  get _installPreview => '${API.share.host}api/device/tree/preview';

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
      "pass_id": passId,
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
    required String mac,
    required int type,
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "ip": ip,
      "type": type,
      "mac": mac,
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
    String? instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "device_code": deviceCode,
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
    required int passId,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    List<int> items = [];

    if (hasBatteryMains) {
      items.add(1);
    }
    if (batteryCap != null) {
      items.add(2);
    }
    Map<String, dynamic> params = {
      "PowerType": items,
      "pass_id": passId,
    };
    if (pNodeCode != null) {
      params["p_node_code"] = pNodeCode;
    }
    if (batteryCap != null) {
      params["battery_capacity"] = batteryCap;
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
      method: 'POST',
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
      method: 'POST',
      autoHideDialog: false,
      autoShowDialog: false,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// AI设备和摄像头安装
  installStep1({
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
      await _installStep1,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 设备安装第二步预览
  installPreview({
    String? instanceId,
    int? gateId,
    required List<Map<String, dynamic>> powers,
    required List<Map<String, dynamic>> powerBoxes,
    required List<Map<String, dynamic>> routers,
    required List<Map<String, dynamic>> wiredNetworks,
    required List<Map<String, dynamic>> nvrs,
    required List<Map<String, dynamic>> switches,
    required ValueChanged<OnePictureDataData?> onSuccess,
    ValueChanged<OnePictureDataData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "powers": powers,
      "power_boxes": powerBoxes,
      "routers": routers,
      "wired_networks": wiredNetworks,
      "nvrs": nvrs,
      "switches": switches,
    };

    if (instanceId != null) {
      params["instance_id"] = instanceId;
    }
    if (gateId != null) {
      params["gate_id"] = gateId;
    }

    // Map<String, dynamic> params = {
    //   "instance_id": instanceId,
    //   "gate_id": gateId,
    //   // 电源信息
    //   "powers": [
    //     {
    //       "PowerType": [1],
    //       "battery_capacity": 100,
    //       "pass_id": 2
    //     }
    //   ],
    //   // 电源箱
    //   "power_boxes": [
    //     {"device_code": "", "pass_id": 1}
    //   ],
    //   // 无线路由器
    //   "routers": [
    //     {"ip": "192.168.101.1", "mac": "24:32:ae:74:aa:d8", "pass_id": 2}
    //   ],
    //   // 有线网络
    //   "wired_networks": [
    //     {"ip": "192.168.101.1", "mac": "24:32:ae:74:aa:d8", "pass_id": 1}
    //   ],
    //   // nvr
    //   "nvrs": [
    //     {"ip": "192.168.101.1", "mac": "24:32:ae:74:aa:d8", "pass_id": 1}
    //   ],
    //   // 交换机
    //   "switches": [
    //     {"interface_num": 3, "power_method": "POE", "pass_id": 1}
    //   ]
    // };

    HttpManager.share.doHttpPost<OnePictureDataData>(
      await _installPreview,
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
