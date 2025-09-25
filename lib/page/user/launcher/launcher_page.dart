import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'launcher_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

///
///  omt
///  launcher_page.dart
///  LauncherPage
///
///  Created by kayoxu on 2024-03-05 at 15:25:38
///  Copyright © 2024 .. All rights reserved.
///

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<LauncherViewModel>(
        model: LauncherViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProgressRing(),
                  SizedBox(height: 20),
                  Text(
                    '运维工具',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '正在启动...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
