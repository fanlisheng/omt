import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:go_router/go_router.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import '../page/home/home/keep_alive_page.dart';
import '../page/home/search_device/widgets/search_device_screen.dart';
import '../theme.dart';
import 'routes/forms.dart' deferred as forms;
import 'routes/inputs.dart' deferred as inputs;
import 'routes/navigation.dart' deferred as navigation;
import 'routes/popups.dart' deferred as popups;
import 'routes/surfaces.dart' deferred as surfaces;
import 'routes/theming.dart' deferred as theming;
import 'theme.dart';
import 'widgets/deferred_widget.dart';
import 'package:kayo_package/kayo_package.dart';

const String appTitle = 'Win UI for Flutter';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await flutter_acrylic.Window.hideWindowControls();
    }
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setMinimumSize(const Size(500, 600));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(const MyApp());

  Future.wait([
    DeferredWidget.preload(popups.loadLibrary),
    DeferredWidget.preload(forms.loadLibrary),
    DeferredWidget.preload(inputs.loadLibrary),
    DeferredWidget.preload(navigation.loadLibrary),
    DeferredWidget.preload(surfaces.loadLibrary),
    DeferredWidget.preload(theming.loadLibrary),
  ]);
}

final _appTheme = AppTheme();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: appTitle,
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

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  late final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const ValueKey('/'),
      icon: const PaneImage(
        name: "home/ic_pane_home",
      ),
      title: Text(
        "首页",
        style: TextStyle(fontSize: 12, color: "#678384".toColor()),
      ),
      body: const SizedBox.shrink(),
      // body: const KeepAlivePage(
      //   child: SearchDeviceScreen(),
      // ),
      // onTap: () {
      //   if (GoRouterState.of(context).uri.toString() != '/') {
      //     context.go('/');
      //   }
      // },
    ),
    // PaneItem(
    //   key: const ValueKey('/navigation/navigation_view'),
    //   icon: const PaneImage(
    //     name: "home/ic_pane_delete",
    //   ),
    //   title: const Text('导航'),
    //   body: const SizedBox.shrink(),
    // ),
    // PaneItem(
    //   key: const ValueKey('/navigation/tab_view'),
    //   icon: const PaneImage(
    //     name: "home/ic_pane_delete",
    //   ),
    //   title: const Text('TabView'),
    //   body: const SizedBox.shrink(),
    // ),
    PaneItem(
      icon: const PaneImage(
        name: "home/ic_pane_add",
      ),
      title: Text(
        "安装",
        style: TextStyle(fontSize: 12, color: "#678384".toColor()),
      ),
      body: const SizedBox.shrink(),
      // body: const KeepAlivePage(
      //   child: InstallDeviceScreen(),
      // ),
      onTap: () => debugPrint('安装'),
    ),
    PaneItem(
      icon: PaneImage(
        name: "home/ic_pane_delete",
      ),
      title: Text(
        "拆除",
        style: TextStyle(fontSize: 12, color: "#678384".toColor()),
      ),
      body: const SizedBox.shrink(),
      // body: const KeepAlivePage(
      //   child: DismantleScreen(),
      // ),
      onTap: () => debugPrint('拆除'),
    ),
    PaneItemExpander(
      icon: PaneImage(
        name: "home/ic_pane_set",
      ),
      title: Text(
        "设置",
        style: TextStyle(fontSize: 12, color: "#678384".toColor()),
      ),
      body: Container(),
      items: [
        PaneItem(
          icon: Container(),
          title: Text(
            "个设备",
            style: TextStyle(fontSize: 12, color: "#678384".toColor()),
          ),
          body: const SizedBox.shrink(),
          // body: const KeepAlivePage(
          //   child: LabelManagementScreen(),
          // ),
        ),
      ],
    ),
  ].map<NavigationPaneItem>((e) {
    PaneItem buildPaneItem(PaneItem item) {
      return PaneItem(
        key: item.key,
        icon: item.icon,
        title: item.title,
        body: item.body,
        onTap: () {
          final path = (item.key as ValueKey).value;
          if (GoRouterState.of(context).uri.toString() != path) {
            context.go(path);
          }
          item.onTap?.call();
        },
      );
    }

    if (e is PaneItemExpander) {
      return PaneItemExpander(
        key: e.key,
        icon: e.icon,
        title: e.title,
        body: e.body,
        items: e.items.map((item) {
          if (item is PaneItem) return buildPaneItem(item);
          return item;
        }).toList(),
      );
    }
    if (e is PaneItem) return buildPaneItem(e);
    return e;
  }).toList();
  late final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const ValueKey('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (GoRouterState.of(context).uri.toString() != '/settings') {
          context.go('/settings');
        }
      },
    ),
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = originalItems
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return originalItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          final enabled = widget.shellContext != null && router.canPop();

          final onPressed = enabled
              ? () {
                  if (router.canPop()) {
                    context.pop();
                    setState(() {});
                  }
                }
              : null;
          return NavigationPaneTheme(
            data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
              unselectedIconColor: WidgetStateProperty.resolveWith((states) {
                if (states.isDisabled) {
                  return ButtonThemeData.buttonColor(context, states);
                }
                return ButtonThemeData.uncheckedInputColor(
                  FluentTheme.of(context),
                  states,
                ).basedOnLuminance();
              }),
            )),
            child: Builder(
              builder: (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
                title: Text(localizations.backButtonTooltip),
                body: const SizedBox.shrink(),
                enabled: enabled,
              ).build(
                context,
                false,
                onPressed,
                displayMode: PaneDisplayMode.compact,
              ),
            ),
          );
        }(),
        title: () {
          if (kIsWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }
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
          if (!kIsWeb) const WindowButtons(),
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
        items: originalItems,
        autoSuggestBox: Builder(builder: (context) {
          return AutoSuggestBox(
            key: searchKey,
            focusNode: searchFocusNode,
            controller: searchController,
            unfocusedColor: Colors.transparent,
            // also need to include sub items from [PaneItemExpander] items
            items: <PaneItem>[
              ...originalItems
                  .whereType<PaneItemExpander>()
                  .expand<PaneItem>((item) {
                return [
                  item,
                  ...item.items.whereType<PaneItem>(),
                ];
              }),
              ...originalItems
                  .where(
                    (item) => item is PaneItem && item is! PaneItemExpander,
                  )
                  .cast<PaneItem>(),
            ].map((item) {
              assert(item.title is Text);
              final text = (item.title as Text).data!;
              return AutoSuggestBoxItem(
                label: text,
                value: text,
                onSelected: () {
                  item.onTap?.call();
                  searchController.clear();
                  searchFocusNode.unfocus();
                  final view = NavigationView.of(context);
                  if (view.compactOverlayOpen) {
                    view.compactOverlayOpen = false;
                  } else if (view.minimalPaneOpen) {
                    view.minimalPaneOpen = false;
                  }
                },
              );
            }).toList(),
            trailingIcon: IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(FluentIcons.search),
              ),
            ),
            placeholder: 'Search',
          );
        }),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: searchFocusNode.requestFocus,
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

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class PaneImage extends StatelessWidget {
  final String name;

  const PaneImage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      source(name),
      width: 18,
      height: 18,
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return ui.Material(
        child: MyHomePage(
          shellContext: _shellNavigatorKey.currentContext,
          child: child,
        ),
      );
    },
    routes: <GoRoute>[
      /// Home
      GoRoute(
        path: '/',
        builder: (context, state) => const ui.Material(
          child: SearchDeviceScreen(),
        ),
      ),

      /// /// Navigation
      /// NavigationView
      GoRoute(
        path: '/navigation/navigation_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
              () => navigation.NavigationViewPage(),
        ),
      ),
      GoRoute(
        path: '/navigation_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
              () => navigation.NavigationViewShellRoute(),
        ),
      ),
    ],
  ),
]);
