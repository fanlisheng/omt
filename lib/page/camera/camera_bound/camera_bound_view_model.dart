import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

// import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../utils/color_utils.dart';

///
///  omt
///  camera_bound_delete_view_model.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraBoundViewModel extends BaseViewModelList<CameraInfoEntity> {
  final asbKey = GlobalKey<AutoSuggestBoxState>(
    debugLabel: 'Manually controlled AutoSuggestBox',
  );

  FocusNode focusNode = FocusNode();

  CameraHttpEntity? cameraHttpEntity;

  List<IdNameValue> points = [];

  IdNameValue? selectedPoint;

  String sgText = '';

  @override
  int getPageSize() {
    return 20;
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      if (asbKey.currentState?.isOverlayVisible != true) {
        asbKey.currentState?.showOverlay();
      }
    } else {
      if (BaseSysUtils.empty(sgText) && null != selectedPoint) {
        onPointSelected(null);
      }
    }
  }

  @override
  void initState() async {
    super.initState();
    focusNode.addListener(_onFocusChange);

    HttpQuery.share.cameraConfigurationService.pointList(onSuccess: (data) {
      points.clear();
      if (!BaseSysUtils.empty(data)) {
        points.addAll(data!);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
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
      HttpQuery.share.cameraConfigurationService.pointCameraList(
          instanceId: selectedPoint?.id,
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

  void onPointSelected(AutoSuggestBoxItem<IdNameValue>? item) {
    selectedPoint = item?.value;
    refresh();
  }

  void deleteDevice(CameraInfoEntity data) {
    showDialog<String>(
      context: context!,
      builder: (context) => ContentDialog(
        title: const Text('删除', style: TextStyle(color: ColorUtils.colorWhite)),
        content: const Text(
          '确定要删除?',
        ),
        actions: [
          Button(
            child: const Text('删除'),
            onPressed: () {
              Navigator.pop(context);
              HttpQuery.share.cameraConfigurationService.deleteDevice(
                  code: [data.gb_id ?? ''],
                  instanceId: selectedPoint?.id,
                  onSuccess: (data) {
                    loadDataWithPageIndex(getPageIndex());
                  });
            },
          ),
          FilledButton(
            child: const Text('取消',style: TextStyle(color: ColorUtils.colorWhite),),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
