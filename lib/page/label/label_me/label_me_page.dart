import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/canvas/canvas_paint_yolo_widget.dart';
import 'package:omt/widget/canvas/paint_yolo.dart';
import 'label_me_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'dart:math' as math;

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
            header: fu.PageHeader(
              title: Row(
                children: [
                  IconButton(
                    tooltip: '打开文件夹',
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () {
                      model.setSelectedDir();
                    },
                  ),
                  IconButton(
                    tooltip: '撤销',
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(Icons.next_plan_outlined),
                    ),
                    onPressed: () {
                      model.undo();
                    },
                  ),
                  IconButton(
                    tooltip: '上一张',
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(Icons.arrow_forward_outlined),
                    ),
                    onPressed: () {
                      model.nextIndex(pre: true);
                    },
                  ),
                  IconButton(
                    tooltip: '下一张',
                    icon: const Icon(Icons.arrow_forward_outlined),
                    onPressed: () {
                      model.nextIndex();
                    },
                  ),
                  IconButton(
                    tooltip: '保存',
                    icon: const Icon(Icons.save_outlined),
                    onPressed: () {},
                  ),
                  fu.ToggleSwitch(
                      leadingContent: false,
                      content: TextView(
                        '自动保存',
                        color: ColorUtils.colorBlack,
                      ),
                      checked: model.autoSave,
                      onChanged: (value) {
                        model.setAutoSave(value);
                      }),
                  TextView(
                    model.selectedDir,
                    size: 13,
                    margin: EdgeInsets.only(left: 20),
                  )
                ],
              ),
            ),
            children: [
              Row(
                children: [
                  Expanded(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageView(
                        height: model.theImgHeight,
                        width: model.theImgWidth,
                        srcToFile: true,
                        src: model.theFileSystemEntity?.path,
                      ),
                      SizedBox(
                        height: model.theImgHeight,
                        width: model.theImgWidth,
                        child: CanvasPaintYoloWidget(
                          canvasNum: 10,
                          rectangles: model.rectangles,
                          rectangleSelected: model.rectangleSelected,
                          onRectangleSelect: (data) {
                            model.setRectSelected(index: -1, rectangle: data);
                          },
                          onRectangles: (List<PaintYolo> value,
                              ValueChanged<IdNameValue> callback) {
                            callback(IdNameValue(id: model.rectangles.length));
                            model.updateRectangles(value);
                          },
                        ),
                      ),
                    ],
                  )),
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: 150,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              width: 400,
                              child: Scrollbar(
                                controller: model.scrollControllerRectangle,
                                child: ListView.builder(
                                  itemCount: model.rectangles.length,
                                  itemExtent: model.itemHeightImgSrc,
                                  controller: model.scrollControllerRectangle,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TextView(
                                      model.rectangles
                                          .findData<PaintYolo>(index)
                                          ?.type
                                          ?.nameShow,
                                      // maxLine: 1,
                                      alignment: Alignment.centerLeft,
                                      color: index == model.indexRectangle
                                          ? ColorUtils.colorAccent
                                          : ColorUtils.colorBlack,
                                      size: 12,
                                      onTap: () {
                                        model.setRectSelected(index: index);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        width: 150,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              width: 400,
                              child: Scrollbar(
                                controller: model.scrollControllerImg,
                                child: ListView.builder(
                                  itemCount: model.files.length,
                                  itemExtent: model.itemHeightImgSrc,
                                  controller: model.scrollControllerImg,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TextView(
                                      model.files[index].path.split('/').last,
                                      // maxLine: 1,
                                      alignment: Alignment.centerLeft,
                                      color: index == model.fileIndex
                                          ? ColorUtils.colorAccent
                                          : ColorUtils.colorBlack,
                                      size: 12,
                                      onTap: () {
                                        model.nextIndex(index: index);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}
