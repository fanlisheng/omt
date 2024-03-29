import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/page/video/video_frame/video_frame_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/utils/color_utils.dart';
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

          VideoInfoCamEntity? theRtsp = model.findTheRtsp();
          var headerLeft = Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              runSpacing: 0,
              spacing: 10,
              children: (model.rtspList ?? []).map((e) {
                var index = model.rtspList?.indexOf(e) ?? 0;
                if (-1 == index) {
                  index = 0;
                }
                return TextView(
                  width: 120,
                  maxLine: 2,
                  model.rtspList![index].name,
                  color: index == model.rtspIndex
                      ? ColorUtils.colorAccent
                      : ColorUtils.colorBlackLite,
                  size: index == model.rtspIndex ? 14 : 14,
                  fontWeight: index == model.rtspIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 6, bottom: 6),
                  alignment: Alignment.center,
                  onTap: () {
                    model.onTapIndex(index);
                  },
                );
              }).toList(),
            ),
          ).addExpanded(flex: _row ? 2 : null);
          var headerRight = Row(
            children: [
              EditView(
                showLine: false,
                padding: const EdgeInsets.only(left: 20, right: 20),
                maxLines: 1,
                alignment: Alignment.centerLeft,
                controller: model.controllerRtsp,
                hintText: '清输入rtsp地址',
              ).addExpanded(flex: 10),
              EditView(
                showLine: false,
                maxLines: 1,
                alignment: Alignment.centerLeft,
                controller: model.controllerDeviceName,
                hintText: '清输入设备名称',
              ).addExpanded(flex: 8),
              Container(
                width: 100,
                margin: const EdgeInsets.only(left: 16),
                child: ButtonView(
                  textDarkOnlyOpacity: true,
                  text: '新增',
                  onPressed: () {
                    model.onTapAdd();
                  },
                ),
              )
            ],
          ).addExpanded(flex: _row ? 2 : null);

          return fu.ScaffoldPage.scrollable(
              header: const fu.PageHeader(
                title: Text('视频画框'),
              ),
              children: [
                _row
                    ? Row(
                        children: [headerLeft, headerRight],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: headerLeft,
                          ),
                          headerRight,
                        ],
                      ),
                const LineView(
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                ),
                Row(
                  children: [
                    TitleMsgVideoFrame('RTSP：', theRtsp?.rtsp, flex: 1),
                    TitleMsgVideoFrame('设备编码：', theRtsp?.value, flex: 1),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // TfbComboBox(
                    //     width: 140,
                    //     datas: [
                    //       IdNameValue(id: 1, name: '第一个框'),
                    //       IdNameValue(id: 2, name: '第二个框')
                    //     ],
                    //     selectedIndex: 0),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    SizedBox(
                      width: 345,
                      child: EditView(
                        hintText: '请输入NVR地址',
                        controller: model.controllerNvr,
                        showLine: false,
                      ),
                    ).addFlexible(),
                    const SizedBox(
                      width: 20,
                    ),
                    _row != true
                        ? const SizedBox()
                        : SizedBox(
                            width: 120,
                            child: ButtonView(
                              text: '清除识别框',
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
        width: 640,
        height: 360,
        child: Stack(
          children: [
            Video(controller: model.controller),
            _row != true
                ? const SizedBox()
                : CanvasPaintWidget(
                    canvasNum: 4,
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
          ...(model.rectangles
              .asMap()
              .map((index, e) {
                var indexStr = '';
                if (index > 0) {
                  indexStr = '${index + 1}';
                }

                return MapEntry(
                    index,
                    CardView(
                      shadowRadius: 8,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 8,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 30,
                        runSpacing: 20,
                        children: [
                          TfbTitleSub(
                              title: '识别框$indexStr-X',
                              subTitle: '${model.fixShowRectNum(e.left)}',
                              width: 100),
                          TfbTitleSub(
                              title: '识别框$indexStr-Y',
                              subTitle: '${model.fixShowRectNum(e.top)}',
                              width: 100),
                          TfbTitleSub(
                              title: '识别框$indexStr-宽',
                              subTitle: '${model.fixShowRectNum(e.width)}',
                              width: 100),
                          TfbTitleSub(
                              title: '识别框$indexStr-高',
                              subTitle: '${model.fixShowRectNum(e.height)}',
                              width: 100),
                        ],
                      ),
                    ));
              })
              .values
              .toList()),
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
                TfbTitleSub(
                    title: '识别间隔/S',
                    hint: '0',
                    controller: model.controllerRecognitionInterval,
                    width: 100),
                TfbTitleSub(
                    title: '车辆漂移',
                    subTitle: '0',
                    width: 100,
                    onSelected: (data) {
                      model.selectedOffsetId = data?.id ?? -1;
                      model.notifyListeners();
                    },
                    selectedIndex:
                        model.findIndex(model.offsets, model.selectedOffsetId),
                    datas: model.offsets),
                TfbTitleSub(
                    title: '进出场',
                    subTitle: '0',
                    width: 100,
                    onSelected: (data) {
                      model.selectedInoutId = data?.id ?? -1;
                      model.notifyListeners();
                    },
                    selectedIndex:
                        model.findIndex(model.inOuts, model.selectedInoutId),
                    datas: model.inOuts),
                Container(
                  width: 100,
                  child: ButtonView(
                    textDarkOnlyOpacity: true,
                    text: '保存',
                    onPressed: () {
                      model.onTapUpdate();
                    },
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
