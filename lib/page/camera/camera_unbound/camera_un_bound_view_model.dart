import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

// import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/widget/picker/id_name_picker.dart';

///
///  omt
///  camera_bound_delete_view_model.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraUnBoundViewModel extends BaseViewModelList<CameraInfoEntity> {

  CameraHttpEntity? cameraHttpEntity;

  List<IdNameValue> points = [];

  @override
  int getPageSize() {
    return 20;
  }

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.cameraConfigurationService.pointList(onSuccess: (data) {
      points.clear();
      if (!BaseSysUtils.empty(data)) {
        points.addAll(data!);
      }
    });
  }

  @override
  void dispose() {
     super.dispose();
  }

  @override
  bool hasMore() {
    return true;
  }

  int times = 0;

  @override
  loadData({pageIndex, onSuccess, onCache, onError}) {
    var nowTimestamp = BaseTimeUtils.nowTimestamp();
    if (nowTimestamp - times > 500) {
      times = nowTimestamp;
      HttpQuery.share.cameraConfigurationService.pointCameraUnbindList(
          pageIndex: pageIndex,
          pageSize: pageSize,
          onSuccess: (data) {
            cameraHttpEntity = data;
            onSuccess?.call(data?.data ?? []);
          },
          onError: onError,
          onCache: (data) {
            cameraHttpEntity = data;
            onCache?.call(data?.data ?? []);
          });
    }
  }


  void bindDevice(CameraInfoEntity data) {
    IdNamePickerWidget.show(
        context: context!,
        points: points,
        title: '选择矿区',
        okBtnText: '绑定矿区',
        placeholder: '请输入或者选择矿区',
        onDataPick: (data) {
          LogUtils.info(msg: data.toString());
        });
  }
}
