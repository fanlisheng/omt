import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/bean/video/video_operations_center/video_operations_center_data.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/sys_utils.dart';

///
///  omt
///  video_operations_center_view_model.dart
///  视频操作中心
///
///  Created by kayoxu on 2024-03-08 at 11:53:00
///  Copyright © 2024 .. All rights reserved.
///

class VideoOperationsCenterViewModel
    extends BaseViewModelRefresh<VideoOperationsCenterData> {
  late final player = Player();
  late final controller = VideoController(player);
  late final player2 = Player();
  late final controller2 = VideoController(player2);
  late final player3 = Player();
  late final controller3 = VideoController(player3);

  List<VideoInfoCamEntity>? rtspList;
  int rtspIndex = 0;

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    player3.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    HttpQuery.share.videoConfigurationService.deviceList(onSuccess: (data) {
      rtspList = data;
      onTapIndex(rtspIndex);
      notifyListeners();
    });
  }

  VideoInfoCamEntity? findTheRtsp() {
    return rtspList?.findData<VideoInfoCamEntity>(rtspIndex);
  }

  void onTapIndex(int index) {
    rtspIndex = index;
    var tr = findTheRtsp();
    var rtsp2 = tr?.rtsp;
    if (!BaseSysUtils.empty(rtsp2)) {
      player.open(Media(rtsp2!));
      player2.open(Media(rtsp2));
      player3.open(Media(rtsp2));
    }

    notifyListeners();
  }

  void stopRecognition() {
    if (BaseSysUtils.empty(findTheRtsp()?.value) && false) {
      LoadingUtils.showToast(data: '请选择设备');
    }
    HttpQuery.share.videoConfigurationService.stopRecognition(
        uuid: findTheRtsp()?.value,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '停止识别成功');
        });
  }

  void restartRecognition() {
    if (BaseSysUtils.empty(findTheRtsp()?.value) && false) {
      LoadingUtils.showToast(data: '请选择设备');
    }
    HttpQuery.share.videoConfigurationService.restartRecognition(
        uuid: findTheRtsp()?.value,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '重启识别成功');
        });
  }

  void restartCentralControl() {
    if (BaseSysUtils.empty(findTheRtsp()?.value) && false) {
      LoadingUtils.showToast(data: '请选择设备');
    }
    HttpQuery.share.videoConfigurationService.restartCentralControl(
        uuid: findTheRtsp()?.value,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '重启中控成功');
        },
        onError: (e) {
          if (e.endsWith('contrl/golang/restart\n')) {
            Timer(const Duration(milliseconds: 100), () {
              LoadingUtils.showToast(data: '重启中控成功');
            });
          }
          // LoadingUtils.showToast(data: e);
        });
  }

  void restartDevice() {
    if (BaseSysUtils.empty(findTheRtsp()?.value) && false) {
      LoadingUtils.showToast(data: '请选择设备');
    }
    HttpQuery.share.videoConfigurationService.restartDevice(
        uuid: findTheRtsp()?.value,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '重启设备成功');
        },
        onError: (e) {
          if (e.endsWith('contrl/system/restart\n')) {
            Timer(const Duration(milliseconds: 100), () {
              LoadingUtils.showToast(data: '重启设备成功');
            });
          }
          // LoadingUtils.showToast(data: e);
        });
  }

  void deleteDevice() {
    if (BaseSysUtils.empty(findTheRtsp()?.value)) {
      LoadingUtils.showToast(data: '请选择设备');
    }
    HttpQuery.share.videoConfigurationService.deleteDevice(
        uuid: findTheRtsp()!.value!,
        onSuccess: (data) {
          LoadingUtils.showToast(data: '删除设备成功');
          rtspIndex = 0;
          Timer(const Duration(seconds: 1), () {
            loadData();
          });
        });
  }
}
