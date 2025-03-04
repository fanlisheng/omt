import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/page/camera/camera_bound/camera_bound_page.dart';
import 'package:omt/page/camera/camera_bound_delete/camera_bound_delete_page.dart';
import 'package:omt/page/camera/camera_unbound/camera_un_bound_page.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/install/widgets/install_device_screen.dart';
import 'package:omt/page/label/label_me/label_me_page.dart';
import 'package:omt/page/label_management/widgets/label_management_screen.dart';
import 'package:omt/page/one_picture/one_picture/one_picture_page.dart';
import 'package:omt/page/tools/terminal/terminal_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/utils/auth_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/combobox.dart';

import '../../dismantle/widgets/dismantle_screen.dart';
import '../search_device/widgets/search_device_screen.dart';
import 'keep_alive_page.dart';

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
    super.key,
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
  PaneDisplayMode displayMode = PaneDisplayMode.open;

  List<NavigationPaneItem> get homeItems {
    return [
      PaneItem(
        key: const ValueKey('/'),
        icon: PaneImage(
          name: "home/ic_pane_home",
          selectedName: 'home/ic_pane_home_s',
          index: 0,
          selectedIndex: topIndex,
        ),
        title: Text(
          "首页",
          style: TextStyle(
              fontSize: 12,
              color: 0 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
        ),
        body: const KeepAlivePage(
          child: SearchDeviceScreen(),
        ),
        onTap: () => debugPrint('首页'),
      ),
      // PaneItem(
      //   icon: PaneImage(
      //     name: "home/ic_pane_add",
      //     selectedName: 'home/ic_pane_add_s',
      //     index: 1,
      //     selectedIndex: topIndex,
      //   ),
      //   title: Text(
      //     "安装",
      //     style: TextStyle(
      //         fontSize: 12,
      //         color: 1 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
      //   ),
      //   body: const KeepAlivePage(
      //     child: InstallDeviceScreen(),
      //   ),
      //   onTap: () => debugPrint('安装'),
      // ),
      // PaneItem(
      //   icon: PaneImage(
      //     name: "home/ic_pane_delete",
      //     selectedName: 'home/ic_pane_delete',
      //     index: 2,
      //     selectedIndex: topIndex,
      //   ),
      //   title: Text(
      //     "拆除",
      //     style: TextStyle(
      //         fontSize: 12,
      //         color: 2 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
      //   ),
      //   body: const KeepAlivePage(
      //     child: DismantleScreen(),
      //   ),
      //   onTap: () => debugPrint('拆除'),
      // ),
      PaneItemExpander(
        icon: PaneImage(
          name: "home/ic_pane_set",
          selectedName: 'home/ic_pane_set',
          index: 3,
          selectedIndex: topIndex,
        ),
        title: Text(
          "设置",
          style: TextStyle(
              fontSize: 12,
              color: 3 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
        ),
        body: Container(),
        items: [
          // PaneItem(
          //   icon: Container(),
          //   title: Text(
          //     "个设备",
          //     style: TextStyle(
          //         fontSize: 12,
          //         color: 4 == topIndex
          //             ? "#F3FFFF".toColor()
          //             : "#678384".toColor()),
          //   ),
          //   body: const KeepAlivePage(
          //     child: LabelManagementScreen(),
          //   ),
          // ),
          PaneItem(
            icon: Container(),
            title: Text(
              "一张图",
              style: TextStyle(
                  fontSize: 12,
                  color: 5 == topIndex
                      ? "#F3FFFF".toColor()
                      : "#678384".toColor()),
            ),
            body: const KeepAlivePage(
              child: OnePicturePage(),
            ),
          ),
        ],
      ),
    ];
  }

  List<NavigationPaneItem> videoItems = [
    PaneItemHeader(header: const Text('视频配置')),
    PaneItem(
      icon: const Icon(Icons.video_settings),
      title: const Text('视频配置'),
      body: const VideoConfigurationPage(),
      onTap: () => debugPrint('视频配置'),
    ),
    PaneItem(
      icon: const Icon(Icons.video_library),
      title: const Text('视频画框'),
      body: const VideoFramePage(),
      onTap: () => debugPrint('视频画框'),
    ),
    PaneItem(
      icon: const Icon(Icons.settings_input_svideo),
      title: const Text('操作中心'),
      body: const VideoOperationsCenterPage(),
      onTap: () => debugPrint('操作中心'),
    ),
  ];
  List<NavigationPaneItem> cameraItems = [
    PaneItemHeader(header: const Text('摄像头配置')),
    PaneItem(
      icon: const Icon(FluentIcons.t_v_monitor_selected),
      title: const Text('已绑定矿区'),
      body: const CameraBoundPage(),
      onTap: () => debugPrint('已绑定矿区'),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.t_v_monitor),
      title: const Text('未绑定矿区'),
      body: const CameraUnBoundPage(),
      onTap: () => debugPrint('未绑定矿区'),
    ),
    PaneItem(
      icon: const Icon(Icons.delete),
      title: const Text('绑定到已删除矿区'),
      body: const CameraBoundDeletePage(),
      onTap: () => debugPrint('绑定到已删除矿区'),
    ),
  ];
  List<NavigationPaneItem> toolsItems = [
    PaneItemHeader(header: const Text('小工具')),
    PaneItem(
      icon: const Icon(Icons.terminal_outlined),
      title: const Text('终端'),
      body: const TerminalPage(),
      onTap: () => debugPrint('小工具'),
    ),
  ];
  List<NavigationPaneItem> labelMeItems = [
    PaneItemHeader(header: const Text('标注')),
    PaneItem(
      icon: const Icon(FluentIcons.label),
      title: const Text('标注'),
      body: const LabelMePage(),
      onTap: () => debugPrint('标注'),
    ),
  ];
  List<NavigationPaneItem> onePictureItems = [
    PaneItemHeader(header: const Text('一张图')),
    PaneItem(
      icon: const Icon(FluentIcons.picture),
      title: const Text('一张图'),
      body: const OnePicturePage(),
      onTap: () => debugPrint('一张图'),
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
        } else if (value?.id == AuthEnum.menuOnePicture) {
          items.addAll(onePictureItems);
        }
        notifyListeners();
      });
    } else {
      items.addAll(homeItems);
      // if (AuthUtils.share.hasAuth(authId: AuthEnum.menuVideoConfiguration)) {
      //   items.addAll(videoItems);
      // }
      // if (AuthUtils.share.hasAuth(authId: AuthEnum.menuCameraConfiguration)) {
      //   items.addAll(cameraItems);
      // }
      notifyListeners();
    }
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

class PaneImage extends StatelessWidget {
  final String name;
  final String selectedName;
  final int index;
  final int selectedIndex;

  const PaneImage(
      {super.key,
      required this.name,
      required this.selectedName,
      required this.index,
      required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      index == selectedIndex ? source(selectedName) : source(name),
      width: 18,
      height: 18,
    );
  }
}
