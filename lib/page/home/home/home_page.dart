import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:window_manager/window_manager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import '../../../utils/color_utils.dart';
import 'home_view_model.dart';

///
///  omt
///  home_page.dart
///  首页
///
///  Created by kayoxu on 2024-03-05 at 15:27:39
///  Copyright © 2024 .. All rights reserved.
///

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<HomeViewModel>(
        model: HomeViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.NavigationView(
            appBar: fu.NavigationAppBar(
                title: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    windowManager.startDragging();
                  },
                  child: fu.Row(
                    children: [
                      ImageView(
                          src: source("ic_logo"),
                          width: 22,
                          height: 22,
                          margin: const fu.EdgeInsets.only(right: 10)),
                      Text(
                        "福立盟运维配置客户端",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: "#E9F4F5".toColor(),
                        ),
                      ),
                      // 版本号显示
                      if (model.currentVersion.isNotEmpty) ...<Widget>[
                        const SizedBox(width: 8),
                        Text(
                          "v${model.currentVersion}",
                          style: TextStyle(
                            fontSize: 12,
                            color: "#B8E6EA".toColor(),
                          ),
                        ),
                      ],
                      // 新版本提示标识
                      if (model.hasNewVersion) ...<Widget>[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => model.onNewVersionTap(),
                          child: Container(
                            width: 46,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF940E),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '新版本',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                automaticallyImplyLeading: false,
                actions: SysUtils.appBarAction(context),
                leading: null,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home/ic_nav_bg.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            onDisplayModeChanged: (mode) {
              debugPrint('Changed to $mode');
            },
            pane: fu.NavigationPane(
              selected: model.topIndex,
              onChanged: (index) {
                model.topIndex = index;
                model.notifyListeners();
              },
              displayMode: model.displayMode,
              size: const fu.NavigationPaneSize(openWidth: 160, topHeight: 0),
              indicator: const fu.StickyNavigationIndicator(),
              // header: model.displayMode == fu.PaneDisplayMode.open ||
              //         model.displayMode == fu.PaneDisplayMode.compact
              //     ? TextView('')
              //     : fu.IconButton(
              //         icon: const fu.Icon(
              //           Icons.menu_outlined,
              //           size: 18,
              //         ),
              //         onPressed: () {
              //           model.setDisplayMode(fu.PaneDisplayMode.compact);
              //         },
              //       ),
              items: model.homeItems,
              footerItems: SysUtils.useNavi()
                  ? [
                      fu.PaneItemAction(
                        icon: const Icon(Icons.home),
                        title: const Text('返回导航页面'),
                        onTap: () {
                          IntentUtils.share.gotoNav(context, showDialog: false);
                        },
                      ),
                      fu.PaneItemAction(
                        icon: const Icon(fu.FluentIcons.sign_out),
                        title: const Text('登出'),
                        onTap: () {
                          IntentUtils.share.gotoLogin(context);
                        },
                      ),
                    ]
                  : [
                      fu.PaneItemAction(
                        icon: const Icon(fu.FluentIcons.sign_out),
                        title: const Text('登出'),
                        onTap: () {
                          IntentUtils.share.gotoLogin(context);
                        },
                      )
                    ],
            ),
            transitionBuilder: null,
          );
        });
  }
}
