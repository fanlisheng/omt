import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:go_router/go_router.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package_utils.dart';
import 'package:omt/page/dismantle/widgets/dismantle_screen.dart';
import 'package:omt/page/home/bind_device/widgets/bind_device_screen.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/home/home/home_view_model.dart';
import 'package:omt/page/home/home/keep_alive_page.dart';
import 'package:omt/page/home/search_device/widgets/search_device_screen.dart';
import 'package:omt/page/install/widgets/install_device_screen.dart';
import 'package:omt/page/label_management/widgets/label_management_screen.dart';
import 'package:omt/routing/routes.dart';
import 'package:omt/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';

import 'bean/home/home_page/device_entity.dart';

final _appTheme = AppTheme();

const String appTitle = '测试';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: "测试",
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;
  int topIndex = 0;
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

  // int index = 0;
  List<NavigationPaneItem> get homeItems {
    return [
      PaneItem(
        key: const ValueKey(Routes.home),
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
        body: const SizedBox.shrink(),
        onTap: (){
          context.go(Routes.home);
        },
      ),
      PaneItem(
        key: const ValueKey(Routes.bindDevice),
        icon: PaneImage(
          name: "home/ic_pane_add",
          selectedName: 'home/ic_pane_add_s',
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
          name: "home/ic_pane_delete",
          selectedName: 'home/ic_pane_delete',
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
          child: DismantleScreen(),
        ),
        onTap: () => debugPrint('拆除'),
      ),
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
          PaneItem(
            icon: Container(),
            title: Text(
              "个设备",
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
        ],
      ),
    ];
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = homeItems
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    return indexOriginal;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: ToggleSwitch(
                content: const Text('Dark Mode'),
                checked: FluentTheme.of(context).brightness.isDark,
                onChanged: (v) {
                  if (v) {
                    appTheme.mode = ThemeMode.dark;
                  } else {
                    appTheme.mode = ThemeMode.light;
                  }
                },
              ),
            ),
          ),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        // header: SizedBox(
        //   height: kOneLineTileHeight,
        //   child: ShaderMask(
        //     shaderCallback: (rect) {
        //       final color = appTheme.color.defaultBrushFor(
        //         theme.brightness,
        //       );
        //       return LinearGradient(
        //         colors: [
        //           color,
        //           color,
        //         ],
        //       ).createShader(rect);
        //     },
        //     child: const FlutterLogo(
        //       style: FlutterLogoStyle.horizontal,
        //       size: 80.0,
        //       textColor: Colors.white,
        //       duration: Duration.zero,
        //     ),
        //   ),
        // ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
              return const StickyNavigationIndicator();
          }
        }(),
        items: homeItems,
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

// final rootNavigatorKey = KayoPackage.share.navigatorKey;
// final _shellNavigatorKey = KayoPackage.share.navigatorKey;

final rootNavigatorKey = KayoPackage.share.navigatorKey;
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return MyHomePage(
        shellContext: _shellNavigatorKey.currentContext,
        child: child,
      );
    },
    routes: <GoRoute>[
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const ui.Material(
          child: SearchDeviceScreen(),
        ), // NavigationPane 包裹的页面
        routes: [
          GoRoute(
            path: Routes.bindDevice,
            builder: (context, state) {
              // 接收参数
              final deviceData = state.extra as List<DeviceEntity>? ?? [];
              return BindDeviceScreen(deviceData: deviceData);
            },
          ),
        ],
      ),
    ],
  ),
]);
