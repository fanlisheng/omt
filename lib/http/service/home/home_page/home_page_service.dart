import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/utils/result.dart';

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

  get _instanceList => '${API.share.host}/api/instance/list';

  get _gateList => '${API.share.host}/api/gate/list';

  get _deviceScan => '${API.share.host}/api/device/scan';

  getInstanceList(
    String areaCode, {
    required ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _instanceList,
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

  deviceScan(
    List<DeviceEntity> deviceList, {
    required ValueChanged<List<DeviceEntity>?>? onSuccess,
    ValueChanged<List<DeviceEntity>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<DeviceEntity>>(
      await _deviceScan,
      {},
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
