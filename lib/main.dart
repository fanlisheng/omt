import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit/media_kit.dart';
import 'package:omt/http/api.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/test/test.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {

  KeyboardNumber.register();
  KeyboardCarNum.register();
  KeyboardPhone.register();
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  MediaKit.ensureInitialized();
  KayoPackage.share.init(
      enableDark: true,
      onTapToolbarBack: (context) {
        print(context.toString());
        IntentUtils.share.pop(context);
      },
      reLoginCode: 401);

  Widget homePage = const MyHomePage();

  if (isDesktop || kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }
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
    var isWindows = defaultTargetPlatform == TargetPlatform.windows;

    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      if (isWindows) {
        // await windowManager.setTitle('');
      }

      await windowManager.setMinimumSize(const Size(1050, 718));
      await windowManager.setMaximumSize(const Size(1050, 718));
      // await windowManager.setResizable(false);
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
      await windowManager.setMovable(true);
      await windowManager.center(animate: true);
      await windowManager.show();
    });
  }

  API.share.init();


  // Widget appPage = const MyApp();
  // runApp(appPage);
  // return;

  if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
    runMockApp(KeyboardRootWidget(child: homePage));
  } else {
    runApp(homePage);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, WindowListener {
  StreamSubscription? stream;
  StreamSubscription? streamBaseViewModelBusEvent;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
    stream = BaseCode.eventBus.on<BaseHttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
    streamBaseViewModelBusEvent = BaseViewModelBusEvent.eventBus
        .on<BaseViewModelBusEvent>()
        .listen((event) {
      if (BaseViewModelBusEvent.BASE_VIEW_MODEL_PUSH == event.type) {
        // AnalyticsUtils.startPageTracking(pageName: event.viewModel);
        // VersionUtils.canShowDialogUpdate = true;
      } else if (BaseViewModelBusEvent.BASE_VIEW_MODEL_POP == event.type) {
        // AnalyticsUtils.stopPageTracking(pageName: event.viewModel);
        // VersionUtils.canShowDialogUpdate = true;
      }
    });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && KayoPackage.share.context.mounted) {
      fu.showDialog(
        context: KayoPackage.share.context,
        builder: (_) {
          return fu.ContentDialog(
            title: const Text('关闭窗口'),
            content: const Text('你确定要关闭窗口？'),
            actions: [
              fu.FilledButton(
                child: TextView('确定',
                    textDarkOnlyOpacity: true, color: ColorUtils.colorWhite),
                onPressed: () {
                  Navigator.pop(KayoPackage.share.context);
                  windowManager.destroy();
                },
              ),
              fu.Button(
                child: TextView('取消', color: ColorUtils.colorBlack),
                onPressed: () {
                  Navigator.pop(KayoPackage.share.context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        API.share.appInactive = true;
        //  应用程序处于闲置状态并且没有收到用户的输入事件。
        //注意这个状态，在切换到后台时候会触发，所以流程应该是先冻结窗口，然后停止UI
        print('YM----->AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
//      应用程序处于不可见状态
        print('YM----->AppLifecycleState.paused');
        API.share.appInactive = true;
        break;
      case AppLifecycleState.resumed:
        API.share.appInactive = false;
        //    进入应用时候不会触发该状态
        //  应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume。
        print('YM----->AppLifecycleState.resumed');
        // SocketService.sendHeart();
        // SocketService.wsLogin();

        // if (VersionUtils.canShowDialogUpdate) {
        //   var context =
        //       KayoPackage.share.navigatorKey.currentState!.overlay!.context;
        //   VersionUtils.checkVerInfo(context, showNoUpdate: false);
        // }
        break;
      case AppLifecycleState.detached:
        //当前页面即将退出
        // API.share.appInactive = true;
        print('YM----->AppLifecycleState.detached');
        break;

      case AppLifecycleState.hidden:
        print('YM----->AppLifecycleState.hidden');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); //添加观察者
    windowManager.addListener(this);

    super.dispose();
    // SocketService.socketClose();

    stream?.cancel();
    stream = null;
    streamBaseViewModelBusEvent?.cancel();
    streamBaseViewModelBusEvent = null;
  }

  Widget appBuilder() {
    return materialApp();
  }

  Widget materialApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return AppTheme();
          },
        ),
      ],
      child: Consumer<AppTheme>(
        builder: (BuildContext context, AppTheme appTheme, Widget? child) {
          return fu.FluentApp(
            title: '运维工具',
            debugShowCheckedModeBanner: false,
            navigatorKey: KayoPackage.share.navigatorKey,
            navigatorObservers: [BotToastNavigatorObserver()],
            localizationsDelegates: const [
              RefreshLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FallbackCupertinoLocalisationsDelegate(),
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
            darkTheme: fu.FluentThemeData(
              brightness: Brightness.dark,
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              focusTheme: fu.FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
            ),
            theme: fu.FluentThemeData(
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              focusTheme: fu.FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
            ),
            locale: appTheme.locale,
            themeMode: appTheme.mode,
            onGenerateRoute: generateRoute,
            initialRoute: RouterPage.LauncherPage,
            builder: LoadingUtils.init(),
          );
        },
      ),
    );
  }

  bool is10footScreen(BuildContext context) {
    final width = View.of(context).physicalSize.width;
    return width >= 11520;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      hideFooterWhenNotFull: false,
      child: appBuilder(),
    );
  }

  errorHandleFunction(int code, message) {
    switch (code) {
      case BaseCode.RESULT_ERROR_NETWORK_ERROR:

        ///网络错误
        // DialogUtils.showToast(msg: message, timeInSecForIos: 2);
        if (API.share.appInactive != true) {
          LoadingUtils.showError(data: message);
        }

        break;

      case BaseCode.RESULT_ERROR_NETWORK_TIMEOUT:

        ///超时
        // DialogUtils.showToast(msg: message, timeInSecForIos: 2);
        LoadingUtils.showError(data: message);

        break;

      case BaseCode.RESULT_ERROR_NETWORK_JSON_EXCEPTION:

        ///json解析失败
        LoadingUtils.showError(data: message);

        break;

      case BaseCode.RESULT_ERROR_SIGN_ERROR:

        ///签名错误
        LoadingUtils.showToast(data: message, timeInSecForIosWeb: 2);
        showDialogLogin();

        break;

      case BaseCode.RESULT_OK:
        break;

      default:
        LoadingUtils.showToast(data: message);
        break;
    }
  }

  bool _dialogLoginShow = false;

  void showDialogLogin() async {
    var context = KayoPackage.share.navigatorKey.currentState?.overlay?.context;
    if (_dialogLoginShow == false) {
      _dialogLoginShow = true;
      showDialog<int>(
        context: context!,
        barrierDismissible: false,
        builder: (c) {
          var dialog = CupertinoAlertDialog(
            title: TextView(
              '登陆已失效，请重新登陆',
              alignment: Alignment.center,
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () async {
                    _dialogLoginShow = false;
                    // IntentUtils.share.finish(c);
                    IntentUtils.share.gotoLogin(context, noAlert: true);
                  },
                  child: const Text('确定')),
            ],
          );

          return dialog;
        },
      ).then((value) {
        _dialogLoginShow = false;
      });
    }
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final fu.FluentThemeData theme = fu.FluentTheme.of(context);

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
