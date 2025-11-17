import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide showDialog, FilledButton, ButtonStyle, Colors;
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/page/camera/camera_bound/camera_bound_page.dart';
import 'package:omt/page/camera/camera_bound_delete/camera_bound_delete_page.dart';
import 'package:omt/page/camera/camera_unbound/camera_un_bound_page.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/install/widgets/install_device_screen.dart';
import 'package:omt/page/label/label_me/label_me_page.dart';
import 'package:omt/page/label_management/widgets/label_management_screen.dart';
import 'package:omt/page/one_picture/one_picture/one_picture_page.dart';
import 'package:omt/page/remove/widgets/remove_screen.dart';
import 'package:omt/page/tools/terminal/terminal_page.dart';
import 'package:omt/page/video/video_configuration/video_configuration_page.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import 'package:omt/page/video/video_operations_center/video_operations_center_page.dart';
import 'package:omt/utils/auth_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/combobox.dart';
import 'package:omt/widget/common_option_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:omt/widget/update/update_manager.dart';
import 'package:omt/http/service/update/update_service.dart';
import 'package:omt/utils/context_utils.dart';
import 'package:omt/http/service/home/home_page/home_page_service.dart';

import '../../../http/service/install/install_cache_service.dart';
import '../../../test/select_detail_page.dart';
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
// final rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
  
  // 版本信息相关
  String currentVersion = '';
  bool hasNewVersion = false;
  final UpdateService _updateService = UpdateService();
  
  // 加载当前版本信息
  Future<void> _loadVersionInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;
      notifyListeners();
    } catch (e) {
      print('获取版本信息失败: $e');
    }
  }
  
  // 检查更新状态
  Future<void> _checkUpdateStatus() async {
    try {
      // 检查是否有本地保存的更新信息（用户点击了"稍后再说"）
      final localUpdateInfo = await _updateService.getLocalUpdateInfo();
      if (localUpdateInfo != null) {
        hasNewVersion = true;
        notifyListeners();
        return;
      }
      
      // 检查远程更新
      final updateInfo = await _updateService.checkForUpdate();
      if (updateInfo != null) {
        hasNewVersion = true;
        // 保存更新信息到本地
        await _updateService.saveUpdateInfo(updateInfo);
        notifyListeners();
      }
    } catch (e) {
      print('检查更新状态失败: $e');
    }
  }

  // 处理新版本标识点击事件
  Future<void> onNewVersionTap() async {
    try {
      final localUpdateInfo = await _updateService.getLocalUpdateInfo();
      if (localUpdateInfo != null) {
        // 清除本地更新信息
        await _updateService.clearLocalUpdateInfo();
        hasNewVersion = false;
        notifyListeners();
        
        // 显示更新对话框
        final context = ContextUtils.instance.getGlobalContext();
        if (context != null) {
          UpdateManager().showUpdateDialog(context, localUpdateInfo);
        }
      }
    } catch (e) {
      print('处理新版本点击失败: $e');
    }
  }

  List<NavigationPaneItem> get homeItems {
    return [
      PaneItem(
        key: const ValueKey('/'),
        icon: PaneImage(
          name: "home/ic_home",
          selectedName: 'home/ic_home_s',
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
      //   key: const ValueKey('/'),
      //   icon: PaneImage(
      //     name: "home/ic_pane_add",
      //     selectedName: 'home/ic_pane_add_s',
      //     index: 0,
      //     selectedIndex: topIndex,
      //   ),
      //   title: Text(
      //     "测试详情",
      //     style: TextStyle(
      //         fontSize: 12,
      //         color: 0 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
      //   ),
      //   body: const KeepAlivePage(
      //     child: SelectDetailPage(),
      //   ),
      //   onTap: () => debugPrint('测试详情'),
      // ),

      PaneItem(
        icon: PaneImage(
          name: "home/ic_install",
          selectedName: 'home/ic_install_s',
          index: 1,
          selectedIndex: topIndex,
        ),
        title: Text(
          "安装",
          style: TextStyle(
              fontSize: 12,
              color: 1 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
        ),
        body: const KeepAlivePage(
          child: InstallDeviceScreen(),
        ),
        onTap: () => debugPrint('安装'),
      ),
      PaneItem(
        icon: PaneImage(
          name: "home/ic_dismantle",
          selectedName: 'home/ic_dismantle_s',
          index: 2,
          selectedIndex: topIndex,
        ),
        title: Text(
          "拆除",
          style: TextStyle(
              fontSize: 12,
              color: 2 == topIndex ? "#F3FFFF".toColor() : "#678384".toColor()),
        ),
        body: const KeepAlivePage(
          child: RemoveScreen(),
        ),
        onTap: () => debugPrint('拆除'),
      ),
      PaneItemExpander(
        icon: PaneImage(
          name: "home/ic_set",
          selectedName: 'home/ic_set',
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
          PaneItem(
            icon: Container(),
            title: Text(
              "标签管理",
              style: TextStyle(
                  fontSize: 12,
                  color: 4 == topIndex
                      ? "#F3FFFF".toColor()
                      : "#678384".toColor()),
            ),
            body: const KeepAlivePage(
              child: LabelManagementScreen(),
            ),
          ),
          // PaneItem(
          //   icon: Container(),
          //   title: Text(
          //     "一张图",
          //     style: TextStyle(
          //         fontSize: 12,
          //         color: 5 == topIndex
          //             ? "#F3FFFF".toColor()
          //             : "#678384".toColor()),
          //   ),
          //   body: KeepAlivePage(
          //     child: OnePicturePage(),
          //   ),
          // ),
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
      body: OnePicturePage(),
      onTap: () => debugPrint('一张图'),
    ),
  ];
  List<NavigationPaneItem> items = [];

  @override
  void initState() async {
    super.initState();

    // 加载版本信息和检查更新状态
    await _loadVersionInfo();
    // await _checkUpdateStatus();

    // 检查安装缓存
    _checkInstallCache();

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

  /// 检查安装缓存
  void _checkInstallCache() async {
    final hasCache = await InstallCacheService.instance.hasCacheData();
    if (hasCache) {
      // 延迟一下确保UI已经构建完成
      await Future.delayed(const Duration(milliseconds: 500));
      _showCacheDialog();
    }
  }

  /// 显示缓存恢复对话框
  void _showCacheDialog() {
    var context = ContextUtils.instance.getGlobalContext();
    if (context == null) return;

    showDialog<void>(
      context: context,
      builder: (context) => BaseCommonDialog(
        title: '安装提醒',
        width: 460,
        height: 260,
        showCloseButton: false,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                '检测到上次的安装流程尚未完成，请确认是否继续安装。\n点击"继续安装"即可从中断的地方继续安装，或者点击"取消安装"重新开始。',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF678384),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(0xFFE74C3C)),
                    ),
                    onPressed: () {
                      HomePageService().cancelInstall(
                        onSuccess: (data) {
                          Navigator.of(context).pop();
                          _clearCache();
                        },
                        onError: (msg) {
                          print('取消安装失败: $msg');
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: const Text(
                        '取消安装',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(0xFF4ECDC4)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _continueInstall();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: const Text(
                        '继续安装',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 清除缓存
  void _clearCache() {
    InstallCacheService.instance.clearCacheData();
  }

  /// 继续安装
  void _continueInstall() {
    final context = ContextUtils.instance.getGlobalContext();
    if (context == null) return;

    _triggerCacheRestore();
    // 切换到安装设备的tab
    topIndex = 1; // 安装设备是第二个tab (index=1)
    notifyListeners();

    // 延迟一下确保页面切换完成后触发缓存恢复
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   // 通过全局标志触发缓存恢复
    //   _triggerCacheRestore();
    // });
  }

  /// 触发缓存恢复
  void _triggerCacheRestore() {
    // 设置全局标志，让InstallDeviceScreen知道需要恢复缓存
    InstallCacheService.instance.setShouldRestoreFromHome(true);
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
