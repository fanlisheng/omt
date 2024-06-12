import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/page/camera/camera_bound/camera_bound_page.dart';
import 'package:omt/page/camera/camera_bound_delete/camera_bound_delete_page.dart';
import 'package:omt/page/camera/camera_unbound/camera_un_bound_page.dart';
import 'package:omt/page/home/home_page.dart';
import 'package:omt/page/label/label_me/label_me_page.dart';
import 'package:omt/page/tools/terminal/terminal_page.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/utils/auth_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';
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
  PaneDisplayMode displayMode = PaneDisplayMode.auto;
  List<NavigationPaneItem> videoItems = [
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

  List<NavigationPaneItem> cameraItems = [
    PaneItemHeader(header: const Text('摄像头配置')),
    PaneItem(
      icon: Icon(FluentIcons.t_v_monitor_selected),
      title: Text('已绑定矿区'),
      body: CameraBoundPage(),
      onTap: () => debugPrint('已绑定矿区'),
    ),
    PaneItem(
      icon: Icon(FluentIcons.t_v_monitor),
      title: Text('未绑定矿区'),
      body: CameraUnBoundPage(),
      onTap: () => debugPrint('未绑定矿区'),
    ),
    PaneItem(
      icon: Icon(Icons.delete),
      title: Text('绑定到已删除矿区'),
      body: CameraBoundDeletePage(),
      onTap: () => debugPrint('绑定到已删除矿区'),
    ),
  ];

  List<NavigationPaneItem> toolsItems = [
    PaneItemHeader(header: const Text('小工具')),
    PaneItem(
      icon: Icon(Icons.terminal_outlined),
      title: Text('终端'),
      body: TerminalPage(),
      onTap: () => debugPrint('小工具'),
    ),

  ];
  List<NavigationPaneItem> labelMeItems = [
    PaneItemHeader(header: const Text('标注')),
    PaneItem(
      icon: Icon(FluentIcons.label),
      title: Text('标注'),
      body: LabelMePage(),
      onTap: () => debugPrint('标注'),
    ),
  ];
  List<NavigationPaneItem> items = [];

  @override
  void initState() async {
    super.initState();

    if (SysUtils.useNavi()) {
      SharedUtils.getTheUserPermission().then((value) {
        if (value?.id == AuthEnum.menuVideoConfiguration) {
          items.addAll(videoItems);
        } else if (value?.id == AuthEnum.menuCameraConfiguration) {
          items.addAll(cameraItems);
        } else if (value?.id == AuthEnum.menuTools) {
          items.addAll(toolsItems);
        } else if (value?.id == AuthEnum.menuLabelMe) {
          items.addAll(labelMeItems);
        }
        notifyListeners();
      });
    } else {
      if (AuthUtils.share.hasAuth(authId: AuthEnum.menuVideoConfiguration)) {
        items.addAll(videoItems);
      }
      if (AuthUtils.share.hasAuth(authId: AuthEnum.menuCameraConfiguration)) {
        items.addAll(cameraItems);
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  void setDisplayMode(PaneDisplayMode mode) {
    displayMode = mode;
    notifyListeners();
  }
}
