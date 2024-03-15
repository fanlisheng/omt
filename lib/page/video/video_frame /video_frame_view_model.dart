import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/video/video_frame /video_frame _data.dart';

///
///  omt
///  video_frame_view_model.dart
///  视频画框
///
///  Created by kayoxu on 2024-03-08 at 11:47:54
///  Copyright © 2024 .. All rights reserved.
///

class VideoFrameViewModel extends BaseViewModelRefresh<VideoFrameData> {
  // String rtspUrl = "rtsp://127.0.0.1:8554/mystream";
  String rtspUrl = "rtsp://192.168.101.189:8554/mystream";
  late final player = Player();
  late final controller = VideoController(player);



  @override
  void initState() async {
    super.initState();
    // player.open(Media('https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
    // player.open(Media('http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8'));
    player.open(Media(rtspUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }
}
