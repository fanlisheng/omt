import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/video/video_frame/video_frame_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/canvas/canvas_paint_widget.dart';
import 'package:omt/widget/lib/widgets.dart';

///
///  omt
///  video_frame_page.dart
///  视频画框
///
///  Created by kayoxu on 2024-03-08 at 11:47:54
///  Copyright © 2024 .. All rights reserved.
///

class VideoFramePage extends StatelessWidget {
  const VideoFramePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<VideoFrameViewModel>(
        model: VideoFrameViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          var windowWidth = BaseSysUtils.getWidth(context);

          var _row = windowWidth > 600 * 2 + 200;

          return fu.ScaffoldPage.scrollable(
              header: const fu.PageHeader(
                title: Text('视频画框'),
              ),
              children: [
                Row(
                  children: [
                    Container().addExpanded(flex: _row ? 2 : null),
                    EditView(
                      showLine: false,
                      maxLines: 1,
                      alignment: Alignment.centerLeft,
                      hintText: '清填写',
                    ).addExpanded(flex: 1),
                    EditView(
                      showLine: false,
                      maxLines: 1,
                      alignment: Alignment.centerLeft,
                      hintText: '清填写',
                    ).addExpanded(flex: 1),
                    Container(
                      width: 100,
                      child: ButtonView(
                        textDarkOnlyOpacity: true,
                        text: '新增',
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                const LineView(
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                ),
                Row(
                  children: [
                    TitleMsgVideoFrame('RTSP：', '192.168.3.62', flex: 1),
                    TitleMsgVideoFrame('设备编码：', SysUtils.randomString(8),
                        flex: 1),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TfbComboBox(datas: [
                      IdNameValue(id: 1, name: '第一个框'),
                      IdNameValue(id: 2, name: '第二个框')
                    ], selectedIndex: 0),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 320,
                      child: EditView(
                        hintText: '请输入NVR地址',
                        showLine: false,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 120,
                      child: ButtonView(
                        text: '清除',
                        textDarkOnlyOpacity: true,
                        onPressed: () {
                          model.clearRectangles();
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: Container(),
                    //   flex: _row ? 3 : 0,
                    // )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                _row
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _views(model, _row),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _views(model, _row),
                      )
              ]);
        });
  }

  List<Widget> _views(VideoFrameViewModel model, bool _row) {
    return [
      SizedBox(
        width: 600,
        height: 360,
        child: Stack(
          children: [
            Video(controller: model.controller),
            CanvasPaintWidget(
              canvasNum: 1,
              rectangles: model.rectangles,
              onRectangles: (List<Rect> value) {
                model.updateRectangles(value);
              },
            ).setVisible2(visible: true)
          ],
        ),
      ),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardView(
            shadowRadius: 8,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            elevation: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                TfbTitleSub(title: '识别框X', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框Y', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框宽', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框高', subTitle: '0', width: 100),
              ],
            ),
          ),
          const SizedBox(height: 12, width: 12),
          CardView(
            shadowRadius: 8,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            elevation: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                TfbTitleSub(title: '识别框2X', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框2Y', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框2宽', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框2高', subTitle: '0', width: 100),
              ],
            ),
          ),
          const SizedBox(height: 12, width: 12),
          CardView(
            shadowRadius: 8,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            elevation: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                TfbTitleSub(title: '识别框3X', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框3Y', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框3宽', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框3高', subTitle: '0', width: 100),
              ],
            ),
          ),
          const SizedBox(height: 12, width: 12),
          CardView(
            shadowRadius: 8,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            elevation: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                TfbTitleSub(title: '识别框4X', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框4Y', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框4宽', subTitle: '0', width: 100),
                TfbTitleSub(title: '识别框4高', subTitle: '0', width: 100),
              ],
            ),
          ),
          const SizedBox(height: 12, width: 12),
          CardView(
            shadowRadius: 8,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            elevation: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                TfbTitleSub(title: '识别间隔/S', subTitle: '0', width: 100),
                TfbTitleSub(
                    title: '车辆漂移',
                    subTitle: '0',
                    width: 100,
                    selectedIndex: 1,
                    datas: [
                      IdNameValue(id: 1, name: '前'),
                      IdNameValue(id: 2, name: '后')
                    ]),
                TfbTitleSub(title: '进出场', subTitle: '0', width: 100, datas: [
                  IdNameValue(id: 1, name: '进'),
                  IdNameValue(id: 2, name: '出')
                ]),
                Container(
                  width: 100,
                  child: ButtonView(
                    textDarkOnlyOpacity: true,
                    text: '保存',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ).addExpanded(flex: _row ? 1 : null),
    ];
  }
}
