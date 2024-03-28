import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/lib/widgets.dart';
import 'video_operations_center_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  omt
///  video_operations_center_page.dart
///  视频操作中心
///
///  Created by kayoxu on 2024-03-08 at 11:53:00
///  Copyright © 2024 .. All rights reserved.
///

class VideoOperationsCenterPage extends StatelessWidget {
  const VideoOperationsCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<VideoOperationsCenterViewModel>(
        model: VideoOperationsCenterViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          var windowWidth = BaseSysUtils.getWidth(context);

          var _row = windowWidth > 600 * 2 + 200;

          return fu.ScaffoldPage.scrollable(
              header: const fu.PageHeader(
                title: Text('操作中心'),
              ),
              children: [
                Wrap(
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
                Row(
                  children: [
                    TitleMsgVideoFrame('RTSP：', model.findTheRtsp()?.rtsp,
                        flex: 1),
                    TitleMsgVideoFrame('设备编码：', model.findTheRtsp()?.value,
                        flex: 1),
                  ],
                ).addContainer(margin: EdgeInsets.only(top: 12, bottom: 20)),
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
                      ),
                Wrap(
                  runSpacing: 20,
                  spacing: 25,
                  children: [
                    ButtonView(
                        height: 40,
                        width: 100,
                        text: '停止识别',
                        textDarkOnlyOpacity: true,
                        bgColor: ColorUtils.colorAccent,
                        onPressed: () {
                          model.stopRecognition();
                        }),
                    ButtonView(
                        height: 40,
                        width: 100,
                        text: '重新识别',
                        textDarkOnlyOpacity: true,
                        bgColor: ColorUtils.colorAccent,
                        onPressed: () {
                          model.restartRecognition();
                        }),
                    ButtonView(
                        height: 40,
                        width: 100,
                        text: '重启中控',
                        textDarkOnlyOpacity: true,
                        bgColor: ColorUtils.colorAccent,
                        onPressed: () {
                            model.restartCentralControl();
                        }),
                    ButtonView(
                        height: 40,
                        width: 100,
                        text: '重启设备',
                        textDarkOnlyOpacity: true,
                        bgColor: ColorUtils.colorAccent,
                        onPressed: () {
                          model.restartDevice();
                        }),
                    ButtonView(
                        height: 40,
                        width: 100,
                        text: '删除设备',
                        textDarkOnlyOpacity: true,
                        bgColor: ColorUtils.colorRed,
                        onPressed: () {
                          model.deleteDevice();
                        }),
                  ],
                ).addContainer(
                  margin: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                )
              ]);
        });
  }

  List<Widget> _views(VideoOperationsCenterViewModel model, bool _row) {
    return [
      SizedBox(
        width: 640,
        height: 360,
        child: Video(controller: model.controller),
      ),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 320,
                height: 180,
                child: Video(controller: model.controller2),
              ),
              SizedBox(
                width: 320,
                height: 180,
                child: Video(controller: model.controller3),
              )
            ],
          ),
          CardView(
              margin: EdgeInsets.only(top: 16),
              radius: 8,
              padding:
                  EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
              shadowRadius: 8,
              child: Column(
                children: [
                  Row(
                    children: [
                      TextView(
                        '车牌号',
                        color: ColorUtils.colorBlackLite,
                      ).addExpanded(),
                      TextView(
                        '记录时间',
                        color: ColorUtils.colorBlackLite,
                      ).addExpanded(),
                      TextView(
                        '类型',
                        color: ColorUtils.colorBlackLite,
                      ).addExpanded(),
                    ],
                  ),
                  const LineView(
                    height: 1,
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                  ),
                  true
                      ? TextView(
                          '无',
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          alignment: Alignment.centerLeft,
                        )
                      : SizedBox(
                          height: 30 * 4,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextView(
                                      '川AAC119',
                                      color: ColorUtils.colorBlack,
                                    ).addExpanded(),
                                    TextView(
                                      '2023-10-12 12:47:54:12',
                                      color: ColorUtils.colorBlack,
                                    ).addExpanded(),
                                    TextView(
                                      '渣土车',
                                      color: ColorUtils.colorBlack,
                                    ).addExpanded(),
                                  ],
                                ),
                              );
                            },
                            itemCount: 4,
                          ),
                        )
                ],
              ))
        ],
      ).addExpanded(flex: _row ? 1 : null),
    ];
  }
}
