import 'package:flutter/cupertino.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:omt/bean/camera/camera_entity.dart';

import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
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

class CameraConfigurationService {
  get _point_list async =>
      '${await API.share.hostCameraConfiguration}/api/gbserver/client/point_list';

  get _point_camera_list async =>
      '${await API.share.hostCameraConfiguration}/api/gbserver/client/point_webcam_list';

  pointList({
    ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>?>(
      await _point_list,
      {},
      method: 'get',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  pointCameraList({
    ValueChanged<CameraHttpEntity?>? onSuccess,
    ValueChanged<CameraHttpEntity?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CameraHttpEntity>(
      await _point_camera_list,
      {'fullData': true},
      method: 'get',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }
}
