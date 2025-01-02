import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'one_picture_view_model.dart';

///
///  omt
///  one_picture_page.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

class OnePicturePage extends StatelessWidget {


  const OnePicturePage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<OnePictureViewModel>(
        model: OnePictureViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          return ToolBar(
            title: '一张图',
            elevation: 0,
            iosBack: true,
            child: Container(),
          );
        });
  }
}
