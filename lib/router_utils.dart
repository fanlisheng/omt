import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/views/common/404.dart';
import 'package:omt/page/home/home_page.dart';
import 'package:omt/page/user/launcher/launcher_page.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:omt/page/video/video_frame%20/video_frame_page.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/lib/search/search_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';

import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';

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
          settings: settings, builder: (context) => HomePage());

    case RouterPage.UserLoginPage:
      return CupertinoPageRoute(
          settings: settings, builder: (context) => UserLoginPage());
    case RouterPage.KSearchPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) => KSearchPage(
              keyword: arguments['keyword'], hintText: arguments['hintText']));

    case RouterPage.VideoConfigurationPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return VideoConfigurationPage();
          });
    case RouterPage.VideoFramePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return VideoFramePage();
          });

    case RouterPage.VideoOperationsCenterPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return VideoOperationsCenterPage();
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
