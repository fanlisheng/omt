import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/bean/common/code_data.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';



import '../../../bean/remove/device_list_entity.dart';

///
///  omt
///  install.dart
///  设备安装服务
///
///  Created on 2024-07-06
///  Copyright © 2024 .. All rights reserved.
///

class RemoveService {
  get _removeDevice => '${API.share.host}api/approval/remove/create';

  get _getDeviceList => '${API.share.host}api/device/list';
  
  get _getDeviceListWithStatus => '${API.share.host}api/device/devices_group_remove_status';

  /// 拆除设备
  removeDevice({
    required List<int> nodeIds,
    required String instanceId,
    int? gateId,
    int? passId,
    required String reason,
    String? remark,
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "instance_id": instanceId,
      "node_ids": nodeIds,
      "Reason": reason,
    };

    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }

    if (remark != null) {
      params["Remark"] = remark;
    }

    HttpManager.share.doHttpPost<CodeMessageData>(
      await _removeDevice,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getDeviceList({
    required String instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<List<DeviceListData>?>? onSuccess,
    ValueChanged<List<DeviceListData>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "instance_id": instanceId,
    };
    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }
    HttpManager.share.doHttpPost<List<DeviceListData>>(
      await _getDeviceList,
      params,
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  /// 获取三种状态的设备列表
  getDeviceListWithStatus({
    required String instanceId,
    int? gateId,
    int? passId,
    required ValueChanged<DevicesRemoveStatusEntity?>? onSuccess,
    ValueChanged<DevicesRemoveStatusEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    Map<String, dynamic> params = {
      "instance_id": instanceId,
    };
    if (gateId != null) {
      params["gate_id"] = gateId;
    }
    if (passId != null) {
      params["pass_id"] = passId;
    }
    HttpManager.share.doHttpPost<DevicesRemoveStatusEntity>(
      await _getDeviceListWithStatus,
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
