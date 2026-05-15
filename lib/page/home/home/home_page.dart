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
                actions: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (model.selectedAreaName != null) _buildAreaSelectionButton(model, context),
                    const SizedBox(width: 16),
                    SysUtils.appBarAction(context),
                  ],
                ),
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

  Widget _buildAreaSelectionButton(HomeViewModel model, BuildContext context) {
    return _AreaDropdownButton(model: model);
  }
}

class _AreaDropdownButton extends StatefulWidget {
  final HomeViewModel model;

  const _AreaDropdownButton({required this.model});

  @override
  __AreaDropdownButtonState createState() => __AreaDropdownButtonState();
}

class __AreaDropdownButtonState extends State<_AreaDropdownButton> {
  final _flyoutController = fu.FlyoutController();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _flyoutController.addListener(_onFlyoutChanged);
  }

  void _onFlyoutChanged() {
    if (mounted) {
      setState(() {
        _isOpen = _flyoutController.isOpen;
      });
    }
  }

  @override
  void dispose() {
    _flyoutController.removeListener(_onFlyoutChanged);
    _flyoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fu.FlyoutTarget(
      controller: _flyoutController,
      child: GestureDetector(
        onTap: () {
          if (widget.model.areaList.isEmpty) return;
          _flyoutController.showFlyout(
            autoModeConfiguration:  fu.FlyoutAutoConfiguration(
              preferredMode: fu.FlyoutPlacementMode.bottomCenter,
            ),
            builder: (context) {
              return fu.FlyoutContent(
                padding: EdgeInsets.zero,
                color: const Color(0xFF384F4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SizedBox(
                  width: 122,
                  height: widget.model.areaList.length * 36.0 > 400 ? 400 : widget.model.areaList.length * 36.0 + 8,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: widget.model.areaList.length,
                    itemBuilder: (context, index) {
                      var area = widget.model.areaList[index];
                      bool isSelected = area.fullName == widget.model.selectedAreaName;
                      return GestureDetector(
                        onTap: () {
                          widget.model.onAreaChanged(area);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 36,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          color: isSelected ? const Color(0xFF3E8480) : fu.Colors.transparent,
                          child: Text(
                            area.fullName ?? '',
                            style: TextStyle(
                              color: isSelected ? fu.Colors.white : const Color(0xFF90A4A3),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          width: 122,
          height: 30,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/home/ic_location.png',
                      width: 12,
                      height: 14,
                      color: const Color(0xFFFFFFFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.model.selectedAreaName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                        height: 18 / 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.15),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: _isOpen ? 3.141592653589793 : 0,
                    child: Image.asset(
                      'assets/home/ic_down_outlined.png',
                      width: 14,
                      height: 14,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

