import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

// import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/log_utils.dart';

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


  @override
  int getPageSize() {
    return 20;
  }

  @override
  void initState() async {
    super.initState();

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


  void deleteDevice(CameraInfoEntity data) {
    showDialog<String>(
      context: context!,
      builder: (context) => ContentDialog(
        title: const Text('删除'),
        content: const Text(
          '确定要删除?',
        ),
        actions: [
          Button(
            child: const Text('删除'),
            onPressed: () {
              Navigator.pop(context);

            },
          ),
          FilledButton(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
