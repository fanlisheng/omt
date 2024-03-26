import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/bean/video/video_frame /video_frame _data.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/json_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/sys_utils.dart';

///
///  omt
///  video_frame_view_model.dart
///  视频画框
///
///  Created by kayoxu on 2024-03-08 at 11:47:54
///  Copyright © 2024 .. All rights reserved.
///

class VideoFrameViewModel extends BaseViewModelRefresh<VideoFrameData> {
  late final player = Player();
  late final controller = VideoController(player);

  List<VideoInfoCamEntity>? rtspList;
  int rtspIndex = 0;

  TextEditingController? controllerRtsp;
  TextEditingController? controllerDeviceName;

  List<IdNameValue> boxList = [IdNameValue(id: -1, name: '全部')];

  late IdNameValue selectedBox = boxList[0];

  List<Rect> rectanglesBase = [];
  List<Rect> rectangles = [];

  @override
  void initState() async {
    super.initState();

    controllerRtsp = TextEditingController();
    controllerDeviceName = TextEditingController();

    // player.open(Media(SysUtils.testLivePlay()));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    HttpQuery.share.videoConfigurationService.deviceList(onSuccess: (data) {
      rtspList = data;
      notifyListeners();
    });
  }

  void updateRectangles(List<Rect> value) {
    notifyListeners();
  }

  void clearRectangles() {
    rectangles.clear();
    notifyListeners();
  }

  void onTapAdd() {
    var cr = controllerRtsp?.text;
    var cdn = controllerDeviceName?.text;
    if (BaseSysUtils.empty(cdn)) {
      LoadingUtils.showInfo(data: '请输入设备名称');
      return;
    } else if (BaseSysUtils.empty(cr) || cr?.contains('rtsp') != true) {
      LoadingUtils.showInfo(data: '请输入rtsp地址');
      return;
    }

    var webcam = VideoInfoCamEntity()
      ..name = cdn
      ..rtsp = cr
      ..in_out = 0;

    HttpQuery.share.videoConfigurationService.addDevice(
        data: webcam,
        onSuccess: (data) {
          loadData();
        });
  }

  void onTapIndex(int index) {
    rtspIndex = index;
    var rtsp2 = findTheRtsp()?.rtsp;
    if (!BaseSysUtils.empty(rtsp2)) {
      player.open(Media(rtsp2!));
    }
    notifyListeners();
  }

  VideoInfoCamEntity? findTheRtsp() {
    return rtspList?.findData<VideoInfoCamEntity>(rtspIndex);
  }
}
