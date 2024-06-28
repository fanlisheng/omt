import 'package:flutter/material.dart';
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
          return  Container();
        });
  }
}
