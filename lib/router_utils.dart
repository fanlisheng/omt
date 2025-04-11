import 'package:flutter/cupertino.dart';
import 'package:kayo_package/views/common/404.dart';
import 'package:omt/page/home/bind_device/widgets/bind_device_screen.dart';
import 'package:omt/page/home/device_add/widgets/device_add_screen.dart';
import 'package:omt/page/home/device_detail/widgets/device_detail_screen.dart';
import 'package:omt/page/home/device_edit/widgets/edit_ai_view.dart';
import 'package:omt/page/home/device_edit/widgets/edit_battery_exchange_view.dart';
import 'package:omt/page/home/device_edit/widgets/edit_camera_view.dart';
import 'package:omt/page/home/device_edit/widgets/edit_power_box_view.dart';
import 'package:omt/page/home/device_edit/widgets/edit_power_view.dart';
import 'package:omt/page/home/device_edit/widgets/edit_router_view.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/home/photo_detail/widgets/photo_detail_screen.dart';
import 'package:omt/page/home/photo_preview/widgets/photo_preview_screen.dart';
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

  ///设备详情
  static const String DeviceDetailScreen = 'DeviceDetailScreen';

  ///图片预览
  static const String PhotoPreviewScreen = 'PhotoPreviewScreen';

  ///照片预览详情
  static const String PhotoDetailScreen = 'PhotoDetailScreen';

  ///设备编辑相关//////////////////////////////////////

  ///AI设备编辑
  static const String EditAiPage = 'EditAiPage';

  ///摄像头编辑
  static const String EditCameraPage = 'EditCameraPage';

  ///NVR设备编辑
  static const String EditNvrPage = 'EditNvrPage';

  ///电源箱编辑
  static const String EditPowerBoxPage = 'EditPowerBoxPage';

  ///电源编辑
  static const String EditPowerPage = 'EditPowerPage';

  ///电池/交换机编辑
  static const String EditBatteryExchangePage = 'EditBatteryExchangePage';

  ///路由器编辑
  static const String EditRouterDevicePage = 'EditRouterDevicePage';

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
              deviceData: arguments["deviceData"],
              doorList: arguments["doorList"],
              instance: arguments["instance"],
            );
          });

    case RouterPage.DeviceAddPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return DeviceAddScreen(
              pNodeCode: arguments["pNodeCode"],
            );
          });

    case RouterPage.DeviceDetailScreen:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return DeviceDetailScreen(
              viewModel: arguments["data"],
            );
          });

    case RouterPage.PhotoPreviewScreen:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return PhotoPreviewScreen(
              photoPreviewScreenData: arguments["data"],
            );
          });

    case RouterPage.PhotoDetailScreen:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return PhotoDetailScreen(
              pageNeedData: arguments["data"],
            );
          });

    case RouterPage.EditAiPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditAiView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditCameraPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditCameraView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditNvrPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditCameraView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditPowerBoxPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditPowerBoxView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditPowerPage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditPowerView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditBatteryExchangePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditBatteryExchangeView(
              model: arguments["data"],
            );
          });

    case RouterPage.EditRouterDevicePage:
      return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return EditRouterView(
              model: arguments["data"],
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
