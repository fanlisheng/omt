import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/page/home/home_page.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';
import 'package:omt/page/video/video_frame%20/video_frame_page.dart';
import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:window_manager/window_manager.dart';

///
///  omt
///  home_view_model.dart
///  首页
///
///  Created by kayoxu on 2024-03-05 at 15:27:39
///  Copyright © 2024 .. All rights reserved.
///
final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class NavigationBodyItem extends StatelessWidget {
  const NavigationBodyItem({
    this.header,
    this.content,
  });

  final String? header;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}

class HomeViewModel extends BaseViewModelRefresh<dynamic> {
  int topIndex = 0;

  List<NavigationPaneItem> items = [
    PaneItemHeader(header: const Text('视频配置')),
    PaneItem(
      icon: Icon(Icons.video_settings),
      title: Text('视频配置'),
      body: VideoConfigurationPage(),
      onTap: () => debugPrint('视频配置'),
    ),
    PaneItem(
      icon: Icon(Icons.video_library),
      title: Text('视频画框'),
      body: VideoFramePage(),
      onTap: () => debugPrint('视频画框'),
    ),
    PaneItem(
      icon: Icon(Icons.settings_input_svideo),
      title: Text('操作中心'),
      body: VideoOperationsCenterPage(),
      onTap: () => debugPrint('操作中心'),
    ),
  ];

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }
}
