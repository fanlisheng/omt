

import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/bean/video/video_frame/video_frame_data.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/json_utils.dart';

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

  VideoInfoEntity? theRtsp;
  List<VideoInfoCamEntity>? rtspList;
  int rtspIndex = 0;
  var rectTimes = 1280 / 640.0;

  TextEditingController? controllerRtsp;
  TextEditingController? controllerNvr;
  TextEditingController? controllerDeviceName;
  TextEditingController? controllerRecognitionInterval;

  List<IdNameValue> inOuts = [
    IdNameValue(id: 1, name: '进场'),
    IdNameValue(id: 2, name: '出场')
  ];

  List<IdNameValue> offsets = [
    IdNameValue(id: 0, name: '无'),
    IdNameValue(id: 1, name: '左'),
    IdNameValue(id: 2, name: '右')
  ];

  int selectedInoutId = -1;
  int selectedOffsetId = 0;

  List<Rect> rectanglesBase = [];
  List<Rect> rectangles = [];

  @override
  void initState() async {
    super.initState();

    controllerRtsp = TextEditingController();
    controllerDeviceName = TextEditingController();
    controllerRecognitionInterval = TextEditingController();
    controllerNvr = TextEditingController();

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
      onTapIndex(rtspIndex);
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
      LoadingUtils.showToast(data: '请输入设备名称');
      return;
    } else if (BaseSysUtils.empty(cr) ||
        (cr?.contains('rtsp') != true && cr?.contains('http') != true)) {
      LoadingUtils.showToast(data: '请输入rtsp地址');
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
    var tr = findTheRtsp();
    var rtsp2 = tr?.rtsp;
    if (!BaseSysUtils.empty(rtsp2)) {
      player.open(Media(rtsp2!));
    }
    controllerNvr?.text = tr?.nvr ?? '';

    notifyListeners();

    HttpQuery.share.videoConfigurationService.deviceInfo(
        uuid: tr?.value ?? '',
        onSuccess: (data) {
          theRtsp = data;
          var rect1 = theRtsp?.rect1;
          var rect2 = theRtsp?.rect2;
          var rect3 = theRtsp?.rect3;
          var rect4 = theRtsp?.rect4;

          rectanglesBase.clear();
          if (null != rect1 &&
              !(rect1.x == 0 &&
                  rect1.y == 0 &&
                  rect1.width == 0 &&
                  rect1.height == 0)) {
            rectanglesBase.add(Rect.fromLTWH(
                fixRectNum(rect1.x!) + 0.0,
                fixRectNum(rect1.y!) + 0.0,
                fixRectNum(rect1.width!) + 0.0,
                fixRectNum(rect1.height!) + 0.0));
          }
          if (null != rect2 &&
              !(rect2.x == 0 &&
                  rect2.y == 0 &&
                  rect2.width == 0 &&
                  rect2.height == 0)) {
            rectanglesBase.add(Rect.fromLTWH(
                fixRectNum(rect2.x!) + 0.0,
                fixRectNum(rect2.y!) + 0.0,
                fixRectNum(rect2.width!) + 0.0,
                fixRectNum(rect2.height!) + 0.0));
          }
          if (null != rect3 &&
              !(rect3.x == 0 &&
                  rect3.y == 0 &&
                  rect3.width == 0 &&
                  rect3.height == 0)) {
            rectanglesBase.add(Rect.fromLTWH(
                fixRectNum(rect3.x!) + 0.0,
                fixRectNum(rect3.y!) + 0.0,
                fixRectNum(rect3.width!) + 0.0,
                fixRectNum(rect3.height!) + 0.0));
          }
          if (null != rect4 &&
              !(rect4.x == 0 &&
                  rect4.y == 0 &&
                  rect4.width == 0 &&
                  rect4.height == 0)) {
            rectanglesBase.add(Rect.fromLTWH(
                fixRectNum(rect4.x!) + 0.0,
                fixRectNum(rect4.y!) + 0.0,
                fixRectNum(rect4.width!) + 0.0,
                fixRectNum(rect4.height!) + 0.0));
          }

          rectangles.clear();
          for (Rect r in rectanglesBase) {
            rectangles.add(Rect.fromLTWH(r.left, r.top, r.width, r.height));
          }
          selectedOffsetId = theRtsp?.other?.offset ?? selectedOffsetId;
          selectedInoutId = theRtsp?.webcam?.in_out ?? selectedInoutId;
          controllerRecognitionInterval?.text =
              '${theRtsp?.other?.time_interval ?? ''}';

          notifyListeners();
        });
  }

  VideoInfoCamEntity? findTheRtsp() {
    return rtspList?.findData<VideoInfoCamEntity>(rtspIndex);
  }

  num fixShowRectNum(double d) {
    return (d * rectTimes + 0.5).toInt();
  }

  num fixRectNum(num d) {
    return d / rectTimes;
  }

  findIndex(List<IdNameValue> datas, int? selectedId) {
    int ii = 0;
    for (var i in datas) {
      if (i.id == selectedId) {
        return ii;
      }
      ii++;
    }
    return -1;
  }

  void onTapUpdate() {
    if (null != theRtsp?.webcam?.value) {
      var httpRtsp = JsonUtils.getBeanSync<VideoInfoEntity>(theRtsp.toJson2());
      httpRtsp?.webcam?.nvr = controllerNvr?.text ?? '';
      if (!BaseSysUtils.empty(rectangles)) {
        httpRtsp?.rect1 = VideoInfoRectEntity.empty();
        httpRtsp?.rect2 = VideoInfoRectEntity.empty();
        httpRtsp?.rect3 = VideoInfoRectEntity.empty();
        httpRtsp?.rect4 = VideoInfoRectEntity.empty();

        if (rectangles.isNotEmpty) {
          httpRtsp?.rect1 = VideoInfoRectEntity()
            ..x = fixShowRectNum(rectangles[0].left).toInt()
            ..y = fixShowRectNum(rectangles[0].top).toInt()
            ..width = fixShowRectNum(rectangles[0].width).toInt()
            ..height = fixShowRectNum(rectangles[0].height).toInt();
        }
        if (rectangles.length > 1) {
          httpRtsp?.rect2 = VideoInfoRectEntity()
            ..x = fixShowRectNum(rectangles[1].left).toInt()
            ..y = fixShowRectNum(rectangles[1].top).toInt()
            ..width = fixShowRectNum(rectangles[1].width).toInt()
            ..height = fixShowRectNum(rectangles[1].height).toInt();
        }
        if (rectangles.length > 2) {
          httpRtsp?.rect3 = VideoInfoRectEntity()
            ..x = fixShowRectNum(rectangles[2].left).toInt()
            ..y = fixShowRectNum(rectangles[2].top).toInt()
            ..width = fixShowRectNum(rectangles[2].width).toInt()
            ..height = fixShowRectNum(rectangles[2].height).toInt();
        }
        if (rectangles.length > 3) {
          httpRtsp?.rect4 = VideoInfoRectEntity()
            ..x = fixShowRectNum(rectangles[3].left).toInt()
            ..y = fixShowRectNum(rectangles[3].top).toInt()
            ..width = fixShowRectNum(rectangles[3].width).toInt()
            ..height = fixShowRectNum(rectangles[3].height).toInt();
        }
      }
      httpRtsp?.other?.time_interval =
          controllerRecognitionInterval?.text.toInt();

      httpRtsp?.other?.offset = selectedOffsetId;
      if (selectedInoutId != -1) {
        httpRtsp?.webcam?.in_out = selectedInoutId;
      }

      HttpQuery.share.videoConfigurationService.updateDevice(
          data: httpRtsp,
          uuid: theRtsp!.webcam!.value!,
          onSuccess: (data) {
            loadData();
          });
    }
  }
}
