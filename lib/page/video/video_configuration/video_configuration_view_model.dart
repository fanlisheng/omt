import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/bean/video/video_configuration/video_configuration_data.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';

///
///  omt
///  video_configuration_view_model.dart
///  视频配置
///
///  Created by kayoxu on 2024-03-08 at 11:44:33
///  Copyright © 2024 .. All rights reserved.
///

class VideoConfigurationViewModel
    extends BaseViewModelRefresh<VideoConfigurationData> {
  TextEditingController? controllerIP;
  VideoConnectEntity? videoConnectEntity;

  @override
  void initState() async {
    super.initState();
    controllerIP = TextEditingController();

    SharedUtils.getControlIP().then((value) {
      controllerIP?.text = value;
      notifyListeners();

      if (!BaseSysUtils.empty(value)) {
        HttpQuery.share.videoConfigurationService.connect(
            host: value,
            onSuccess: (data) {
              videoConnectEntity = data;
              notifyListeners();
            });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  void connect() {
    if (BaseSysUtils.empty(controllerIP?.text)) {
      LoadingUtils.showInfo(data: '请输入工控机IP');
    } else if (SysUtils.isIPAddress(controllerIP!.text)) {
      HttpQuery.share.videoConfigurationService.connect(
          host: controllerIP!.text,
          onSuccess: (data) {
            videoConnectEntity = data;
            SharedUtils.setControlIP(controllerIP!.text);
            notifyListeners();
            LoadingUtils.showSuccess(data: '连接成功');
          },
          onError: (e) {
            videoConnectEntity = null;
            SharedUtils.setControlIP('');
            notifyListeners();
            LoadingUtils.showInfo(data: '连接失败');
          });
    } else {
      LoadingUtils.showInfo(data: '请输入正确的工控机IP');
    }
  }
}
