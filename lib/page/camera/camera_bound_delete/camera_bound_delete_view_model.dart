// import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/widget/picker/id_name_picker.dart';

///
///  omt
///  camera_bound_delete_view_model.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraBoundDeleteViewModel extends BaseViewModelList<CameraInfoEntity> {
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
  bool hasMore() {
    return true;
  }

  int times = 0;

  @override
  loadData({pageIndex, onSuccess, onCache, onError}) {
    var nowTimestamp = BaseTimeUtils.nowTimestamp();
    if (nowTimestamp - times > 500) {
      times = nowTimestamp;
      HttpQuery.share.cameraConfigurationService.pointCameraBindDeleteList(
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
        onDataPick: (dp) {
          if (null != dp) {
            HttpQuery.share.cameraConfigurationService.bind2Point(
                instanceId: dp.id,
                code: [data.channel_info!],
                onSuccess: (data) {
                  loadDataWithPageIndex(getPageIndex());
                  LoadingUtils.showToast(data: '绑定成功');
                });
          }
        });
  }
}
