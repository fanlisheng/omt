import 'package:flutter/cupertino.dart';
import 'package:kayo_package/views/common/404.dart';
import 'package:omt/page/home/bind_device/widgets/bind_device_screen.dart';
import 'package:omt/page/home/device_add/widgets/device_add_screen.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/user/launcher/launcher_page.dart';
import 'package:omt/page/user/nav/navi_page.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/lib/search/search_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';

import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/page/camera/camera_bound/camera_bound_page.dart';
import 'package:omt/page/label/label_me/label_me_page.dart';
import 'package:omt/page/tools/terminal/terminal_page.dart';
import 'package:omt/page/one_picture/one_picture/one_picture_page.dart';

///ReplaceRouterPageImport

///
///  tfblue_app
///  router_utils.dart
///
///  Created by kayoxu on 2021/10/22 at 4:00 下午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class RouterPage {
  ///用户、登录相关//////////////////////////////////////

  ///LauncherPage
  static const String LauncherPage = 'LauncherPage';

  ///登录
  static const String UserLoginPage = 'UserLoginPage';

  ///首页
  static const String HomePage = 'HomePage';

  ///搜索页面只返回文字
  static const String KSearchPage = 'KSearchPage';

  ///视频配置
  static const String VideoConfigurationPage = 'VideoConfigurationPage';

  ///视频画框
  static const String VideoFramePage = 'VideoFramePage';

  ///视频操作中心
  static const String VideoOperationsCenterPage = 'VideoOperationsCenterPage';

  ///已绑定矿区摄像头管理
  static const String CameraBoundPage = 'CameraBoundPage';

  ///导航页
  static const String NaviPage = 'NaviPage';

  ///数据标注
  static const String LabelMePage = 'LabelMePage';

  ///终端
  static const String TerminalPage = 'TerminalPage';

  ///一张图
  static const String OnePicturePage = 'OnePicturePage';

  ///设备绑定
  static const String DeviceBindPage = 'DeviceBindPage';

  ///设备添加
  static const String DeviceAddPage = 'DeviceAddPage';

  ///ReplaceRouterPageDefine
}

Route<dynamic> generateRoute(RouteSettings settings, {uniqueId}) {
  Map<String, dynamic> arguments = {};
  if (settings.arguments is Map) {
    arguments = Map<String, dynamic>.from(settings.arguments as Map);
  }

  switch (settings.name) {
    case RouterPage.LauncherPage:
      return CupertinoPageRoute(
          settings: settings, builder: (context) => const LauncherPage());

    case RouterPage.HomePage:
      return CupertinoPageRoute(
          settings: settings, builder: (context) => const HomePage());

    case RouterPage.UserLoginPage:
      return CupertinoPageRoute(
          settings: settings, builder: (context) => const UserLoginPage());
    case RouterPage.KSearchPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) => KSearchPage(
              keyword: arguments['keyword'], hintText: arguments['hintText']));

    case RouterPage.VideoConfigurationPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const VideoConfigurationPage();
          });
    case RouterPage.VideoFramePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const VideoFramePage();
          });

    case RouterPage.VideoOperationsCenterPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const VideoOperationsCenterPage();
          });
    case RouterPage.CameraBoundPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const CameraBoundPage();
          });
    case RouterPage.NaviPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const NaviPage();
          });

    case RouterPage.LabelMePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const LabelMePage();
          });
    case RouterPage.TerminalPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return const TerminalPage();
          });

    case RouterPage.OnePicturePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return OnePicturePage();
          });

    case RouterPage.DeviceBindPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return BindDeviceScreen(
              deviceData: arguments["data"],
            );
          });

    case RouterPage.DeviceAddPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return DeviceAddScreen(
              id: arguments["id"],
              deviceType: arguments["type"],
            );
          });

    ///ReplaceRouterGenerateRoute

    default:
      return CupertinoPageRoute(
          builder: (context) => WidgetNotFound(
                backClick: () {
                  IntentUtils.share.pop(context);
                },
              ));
  }
}

Route<dynamic> _pageRouter(settings, uniqueId) {
  return generateRoute(settings, uniqueId: uniqueId);
}
