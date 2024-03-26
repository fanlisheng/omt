import 'package:flutter/cupertino.dart';
import 'package:kayo_package/extension/_index_extension.dart';

import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/utils/json_utils.dart';

import '../../../bean/video/video_configuration/Video_Connect_entity.dart';
// import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  video_configuration_service.dart
///  视频配置
///
///  Created by kayoxu on 2024-03-08 at 11:44:33
///  Copyright © 2024 .. All rights reserved.
///

class VideoConfigurationService {
  get _connect async => '/central_control/get';

  get _add_device async =>
      '${await API.share.hostVideoConfiguration}/webcam/save';

  get _device_list async =>
      '${await API.share.hostVideoConfiguration}/webcam/list';

  connect({
    required String host,
    ValueChanged<VideoConnectEntity?>? onSuccess,
    ValueChanged<VideoConnectEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<VideoConnectEntity>(
      'http://$host:8000${await _connect}',
      {},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  addDevice({
    required VideoInfoCamEntity? data,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      await _add_device,
      JsonUtils.getMap(data.toJson2()),
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceList({
    ValueChanged<List<VideoInfoCamEntity>?>? onSuccess,
    ValueChanged<List<VideoInfoCamEntity>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<VideoInfoCamEntity>?>(
      await _device_list,
      {},
      method: 'get',
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
