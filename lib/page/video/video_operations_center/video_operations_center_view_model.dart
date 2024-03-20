import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/video/video_operations_center/video_operations_center_data.dart';
import 'package:omt/utils/sys_utils.dart';

///
///  omt
///  video_operations_center_view_model.dart
///  视频操作中心
///
///  Created by kayoxu on 2024-03-08 at 11:53:00
///  Copyright © 2024 .. All rights reserved.
///

class VideoOperationsCenterViewModel extends BaseViewModelRefresh<VideoOperationsCenterData> {
  String rtspUrl = "rtsp://192.168.101.189:8554/mystream";
  late final player = Player();
  late final controller = VideoController(player);
  late final player2 = Player();
  late final controller2 = VideoController(player2);
  late final player3 = Player();
  late final controller3 = VideoController(player3);
  @override
  void initState() async {
    super.initState();
    player.open(Media(SysUtils.testLivePlay()));
    player2.open(Media(SysUtils.testLivePlay()));
    player3.open(Media(SysUtils.testLivePlay()));
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
    ///网络请求

  }
}
