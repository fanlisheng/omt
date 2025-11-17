import 'package:flutter/cupertino.dart';
import 'package:kayo_package/extension/_index_extension.dart';

import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/utils/json_utils.dart';

import '../../../bean/video/video_configuration/Video_Connect_entity.dart';
// import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  camera_configuration_service.dart
///  视频配置
///
///  Created by kayoxu on 2024-03-08 at 11:44:33
///  Copyright © 2024 .. All rights reserved.
///

class VideoConfigurationService {
  // Webcam API路径常量
  static const String webcamDeviceCodeInfo = 'device_code/info';
  static const String webcamSave = 'save';
  static const String webcamRemove = 'remove';
  static const String webcamList = 'list';
  static const String webcamInfo = 'info';
  static const String webcamInfoSave = 'info/save';
  static const String webcamRemoveAll = '/webcam/remove/all';

  get _connect async => '/central_control/get';

  get _add_device async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamSave);

  get _device_list async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamList);

  get _device_info async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamInfo);

  get _update_device async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamInfoSave);

  get _stop_recognition async =>
      '${await API.share.hostVideoConfiguration}/contrl/python/stop';

  get _restart_recognition async =>
      '${await API.share.hostVideoConfiguration}/new/contrl/python/restart';

  get _restart_centralcontrol async =>
      '${await API.share.hostVideoConfiguration}/contrl/golang/restart';

  get _restart_device async =>
      '${await API.share.hostVideoConfiguration}/contrl/system/restart';

  get _delete_device async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamRemove);

  get _device_info_uuid async => await API.share
      .buildControlWebcamUrl(VideoConfigurationService.webcamDeviceCodeInfo);

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

  deviceInfo({
    required String uuid,
    ValueChanged<VideoInfoEntity?>? onSuccess,
    ValueChanged<VideoInfoEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<VideoInfoEntity>(
      '${await _device_info}/$uuid',
      {},
      method: 'get',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void updateDevice({
    required String uuid,
    required VideoInfoEntity? data,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      '${await _update_device}/$uuid',
      JsonUtils.getMap(data.toJson2()),
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void stopRecognition({
    required String? uuid,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      // '${await _stop_recognition}/$uuid',
      '${await _stop_recognition}',
      {},
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void restartRecognition({
    required String? uuid,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      // '${await _stop_recognition}/$uuid',
      '${await _restart_recognition}',
      {},
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void restartCentralControl({
    required String? uuid,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      // '${await _stop_recognition}/$uuid',
      '${await _restart_centralcontrol}',
      {},
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void restartDevice({
    required String? uuid,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      // '${await _stop_recognition}/$uuid',
      '${await _restart_device}',
      {},
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  void deleteDevice({
    required String uuid,
    ValueChanged<dynamic>? onSuccess,
    ValueChanged<dynamic>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<dynamic>(
      '${await _delete_device}/$uuid',
      // '${await _delete_device}',
      {},
      method: 'post',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  deviceInfoUuids({
    ValueChanged<List<dynamic>?>? onSuccess,
    ValueChanged<List<dynamic>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<dynamic>?>(
      await _device_info_uuid,
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
