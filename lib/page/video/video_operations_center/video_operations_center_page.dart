import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:media_kit_video/media_kit_video.dart';
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
        model: VideoOperationsCenterViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          var windowWidth = BaseSysUtils.getWidth(context);

          var _row = windowWidth > 600 * 2 + 200;

          return fu.ScaffoldPage.scrollable(
              header: fu.PageHeader(
                title: Text('操作中心'),
              ),
              children: [
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

  List<Widget> _views(VideoOperationsCenterViewModel model, bool _row) {
    return [
      SizedBox(
        width: 600,
        height: 360,
        child: Video(controller: model.controller),
      ),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 300,
            height: 180,
            child: Video(controller: model.controller),
          ),
          SizedBox(
            width: 300,
            height: 180,
            child: Video(controller: model.controller),
          )
        ],
      ).addExpanded(flex: _row ? 1 : null),
    ];
  }
}
