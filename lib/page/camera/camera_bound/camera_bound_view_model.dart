import 'package:fluent_ui/fluent_ui.dart';

// import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/log_utils.dart';

///
///  omt
///  camera_bound_view_model.dart
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

  List<IdNameValue> points = [];

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      if (asbKey.currentState?.isOverlayVisible != true) {
        asbKey.currentState?.showOverlay();
      }
    } else {}
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

  @override
  loadData({pageIndex, onSuccess, onCache, onError}) {
    HttpQuery.share.cameraConfigurationService.pointCameraList(
        onSuccess: (data) {
          onSuccess?.call(data?.data ?? []);
        },
        onError: onError,
        onCache: (data) {
          onCache?.call(data?.data ?? []);
        });
  }
}
