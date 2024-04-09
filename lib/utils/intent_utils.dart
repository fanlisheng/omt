import 'dart:core';

import 'package:flutter/material.dart';

import 'package:kayo_package/kayo_package.dart';
import 'package:omt/http/api.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/utils/image_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:omt/utils/sys_utils.dart';
import 'color_utils.dart';

///  smart_community
///  common.common.utils
///
///  Created by kayoxu on 201 9/1/24.
///  Copyright © 2019 kayoxu. All rights reserved.

class IntentUtils extends BaseIntentUtilsNoBoost {
  static IntentUtils get share => IntentUtils._share();

  static IntentUtils? _instance;

  IntentUtils._();

  // bool useFlutterBoost = false;
  // var withFlutterBoostContainer = false;

  List<String> uniqueIdList = [];

  factory IntentUtils._share() {
    _instance ??= IntentUtils._();
    return _instance!;
  }

  @override
  Future? push(BuildContext? context,
      {String? routeName,
      bool finish = false,
      bool removeAll = false,
      // bool? withFlutterBoostContainer,
      Map<String, dynamic>? data}) async {
    return super.push(context!,
        routeName: routeName, finish: finish, removeAll: removeAll, data: data);
  }

  @override
  pop(BuildContext context,
      {Map<String, dynamic>? data, bool finishAct = false}) {
    /*  if (useFlutterBoost == true) {
      return BoostNavigator.instance.pop(data);
    } else */
    {
      return super.pop(context, data: data, finishAct: finishAct);
    }
  }

  void gotoLogin(BuildContext? context, {bool noAlert = false}) async {
    if (noAlert == true) {
      await SharedUtils.clear();
      // await SocketService.socketClose();
      push(context, routeName: RouterPage.UserLoginPage, removeAll: true);
    } else {
      if (true) {
        await fu.showDialog<String>(
          context: context!,
          builder: (context) => fu.ContentDialog(
            title: const Text('退出登录'),
            content: const Text(
              '你确定要退出登录？',
            ),
            actions: [
              fu.FilledButton(
                child: TextView(
                  '确定',
                  color: ColorUtils.colorWhite,
                  textDarkOnlyOpacity: true,
                ),
                onPressed: () async {
                  await SharedUtils.clear();
                  await API.share.init();
                  // SocketService.socketClose();
                  push(context,
                      routeName: RouterPage.UserLoginPage, removeAll: true);
                },
              ),
              fu.Button(
                child: TextView(
                  '取消',
                  color: ColorUtils.colorBlack,
                ),
                onPressed: () => Navigator.pop(context, '取消'),
              ),
            ],
          ),
        );

        return;
      }

      List<Widget> list = [];
      var logoutAction = AlertSheet.sheetAction(
          text: '确定',
          color: ColorUtils.colorRed,
          showLine: true,
          callback: () async {
            await SharedUtils.clear();
            await API.share.init();
            // SocketService.socketClose();
            push(context, routeName: RouterPage.UserLoginPage, removeAll: true);
          });

      list.add(logoutAction);
      AlertSheet.sheet(context,
          title: '退出登录？',
          showCancel: true,
          cancelText: '取消',
          cancelColor: ColorUtils.colorBlackLite,
          children: list);
    }
  }

  void goHome(BuildContext? context, {bool checkUserPermission = false}) async {
    if (SysUtils.useNavi()) {
      if (checkUserPermission) {
        var theUserPermission = await SharedUtils.getTheUserPermission();
        if (theUserPermission?.id == null) {
          gotoNav(context);
        }else{
          goHomeBase(context);
        }
      } else {
        gotoNav(context);
      }
    } else {
      goHomeBase(context);
    }
  }

  void goHomeBase(BuildContext? context) {
    push(context, routeName: RouterPage.HomePage, removeAll: true);
  }

  void gotoNav(BuildContext? context, {bool showDialog = false}) {
    if (showDialog) {
      fu.showDialog<String>(
        context: context!,
        builder: (context) => fu.ContentDialog(
          title: const Text('返回导航页面'),
          content: const Text(
            '你确定要返回导航页面？',
          ),
          actions: [
            fu.FilledButton(
              child: TextView(
                '确定',
                color: ColorUtils.colorWhite,
                textDarkOnlyOpacity: true,
              ),
              onPressed: () async {
                push(context, routeName: RouterPage.NaviPage, removeAll: true);
              },
            ),
            fu.Button(
              child: TextView(
                '取消',
                color: ColorUtils.colorBlack,
              ),
              onPressed: () => Navigator.pop(context, '取消'),
            ),
          ],
        ),
      );
    } else {
      push(context, routeName: RouterPage.NaviPage, removeAll: true);
    }
  }

  ///播放视频
  /// IntentUtils.playVideo(viewService.context,url: 'https://file.shomes.cn/minio/file/2/2021/0224/0eeabebc-f09e-460b-82b3-afb571ced770.flv');
  void playVideo(BuildContext context, {String? path, String? url, bool? vlc}) {
    if (BaseSysUtils.empty(path) && BaseSysUtils.empty(url)) {
      LoadingUtils.showInfo(data: '当前视频无法播放');
      return;
    }

    if (null != vlc) {
      // IntentUtils.share.p
      // return;
    }

    // IntentUtils.share.push(context, routeName: RouterPage.VideoScreen, data: {
    //   'path': path,
    //   'noToolBar': true,
    //   'online': false,
    //   // 'url': ImageUtils.share.getImageUrl(url: "http://183.224.113.211:8098/minio/file/0/2023/1208/c8b5458d-ee31-4c5e-a95b-5f8840812db8.mp4"),
    //   'url': ImageUtils.share.getImageUrl(url: url),
    //   'vlc': vlc
    // });
  }
}
