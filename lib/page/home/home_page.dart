import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/main.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:window_manager/window_manager.dart';
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
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<HomeViewModel>(
        model: HomeViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.NavigationView(
            appBar: fu.NavigationAppBar(
                title: Text('运维工具'),
                automaticallyImplyLeading: false,
                actions: SysUtils.appBarAction(context),
                leading: null),
            onDisplayModeChanged: (mode) {
              debugPrint('Changed to $mode');
            },
            pane: fu.NavigationPane(
              selected: model.topIndex,
              onChanged: (index) {
                model.topIndex = index;
                model.notifyListeners();
              },
              displayMode: fu.PaneDisplayMode.auto,
              indicator: const fu.StickyNavigationIndicator(),
              header: const Text(''),
              items: model.items,
              footerItems: [
                // fu.PaneItem(
                //   icon: const Icon(fu.FluentIcons.settings),
                //   title: const Text('设置'),
                //   body: const NavigationBodyItem(),
                // ),
                fu.PaneItemAction(
                  icon: const Icon(fu.FluentIcons.sign_out),
                  title: const Text('登出'),
                  onTap: () {
                    IntentUtils.share.gotoLogin(context);
                  },
                ),
              ],
            ),
            transitionBuilder: null,
          );
        });
  }
}
