// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:omt/http/service/home/home_page/home_page_service.dart';
import 'package:omt/page/home/bind_device/widgets/bind_device_screen.dart';
import 'package:omt/page/home/home/home_page.dart';
import 'package:omt/page/home/search_device/widgets/search_device_screen.dart';
import 'package:omt/page/user/user_login/user_login_page.dart';
import 'package:provider/provider.dart';

import '../bean/home/home_page/device_entity.dart';
import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router() => GoRouter(
  initialLocation: Routes.home, // 设置初始路由
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const UserLoginPage(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const SearchDeviceScreen(), // NavigationPane 包裹的页面
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
);


// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
// Future<String?> _redirect(BuildContext context, GoRouterState state) async {
//   // if the user is not logged in, they need to login
//   final bool loggedIn = await context.read<AuthRepository>().isAuthenticated;
//   final bool loggingIn = state.matchedLocation == Routes.login;
//   if (!loggedIn) {
//     return Routes.login;
//   }
//
//   // if the user is logged in but still on the login page, send them to
//   // the home page
//   if (loggingIn) {
//     return Routes.home;
//   }
//
//   // no need to redirect at all
//   return null;
// }
