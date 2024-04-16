import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/widget/canvas/canvas_paint_widget.dart';
import 'label_me_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:open_filex/open_filex.dart';

///
///  omt
///  label_me_page.dart
///  数据标注
///
///  Created by kayoxu on 2024-04-15 at 16:39:19
///  Copyright © 2024 .. All rights reserved.
///

class LabelMePage extends StatelessWidget {
  const LabelMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<LabelMeViewModel>(
        model: LabelMeViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.ScaffoldPage.scrollable(
            // header: Text('标注'),
            children: [
              Row(
                children: [
                  fu.Button(
                    onPressed: () {
                      model.setSelectedDir();
                    },
                    child: TextView('选择标注文件夹'),
                  ),
                  TextView(
                    model.selectedDir,
                    margin: const EdgeInsets.only(left: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageView(
                        height: model.theImgHeight,
                        width: model.theImgWidth,
                        src: model.theFileSystemEntity?.path,
                      ),
                      SizedBox(
                        height: model.theImgHeight,
                        width: model.theImgWidth,
                        child: CanvasPaintWidget(
                          canvasNum: 10,
                          rectangles: model.rectangles,
                          onRectangles: (List<Rect> value) {
                            model.updateRectangles(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          TextView('删除'),
                          TextView(
                            '上一张',
                            onTap: () {
                              model.nextIndex(pre: true);
                            },
                          ),
                          TextView(
                            '下一张',
                            onTap: () {
                              model.nextIndex();
                            },
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              )
            ],
          );
        });
  }
}
