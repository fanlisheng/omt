import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/views/_index_views.dart';
import 'package:kayo_package/views/widget/_index_widget.dart';
import 'package:kayo_package/views/widget/base/_index_widget_base.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/lib/widgets.dart';
import 'video_configuration_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  omt
///  video_configuration_page.dart
///  视频配置
///
///  Created by kayoxu on 2024-03-08 at 11:44:33
///  Copyright © 2024 .. All rights reserved.
///

class VideoConfigurationPage extends StatelessWidget {
  const VideoConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<VideoConfigurationViewModel>(
        model: VideoConfigurationViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.ScaffoldPage.scrollable(
              header: const fu.PageHeader(
                title: Text('视频配置'),
              ),
              children: [
                CardView(
                    shadowRadius: 8,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    elevation: 8,
                    child: Row(
                      children: [
                        TfbTitleSub(title: '中控机器IP', subTitle: '192.168.3.91'),
                        const Spacer(),
                        TextView(
                          '未连接',
                          color: ColorUtils.colorRed,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '连接',
                          textDarkOnlyOpacity: true,
                          onPressed: () {},
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                CardView(
                    shadowRadius: 8,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    elevation: 8,
                    child: Row(
                      children: [
                        Expanded(
                            child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 16,
                          children: [
                            TfbTitleSub(
                                title: '服务器地址',
                                subTitle: '192.168.3.91',
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: '建委地址',
                                subTitle: '192.168.3.91',
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: '建委Key',
                                subTitle: SysUtils.randomString(10),
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: '建委Secret',
                                subTitle: SysUtils.randomString(10),
                                controller: TextEditingController())
                          ],
                        )),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '保存',
                          textDarkOnlyOpacity: true,
                          onPressed: () {},
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                CardView(
                    shadowRadius: 8,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    elevation: 8,
                    child: Row(
                      children: [
                        Expanded(
                            child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          clipBehavior: Clip.hardEdge,
                          runSpacing: 16,
                          children: [
                            TfbTitleSub(
                                title: '修改IP',
                                subTitle: '192.168.3.91',
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: '掩码',
                                subTitle: '255.255.255.0',
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: '网关',
                                subTitle: '192.168.3.18',
                                controller: TextEditingController()),
                            TfbTitleSub(
                                title: 'DNS',
                                subTitle: '114.114.114.114',
                                controller: TextEditingController())
                          ],
                        )),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '保存',
                          textDarkOnlyOpacity: true,
                          onPressed: () {},
                        ),
                      ],
                    ))
              ]);
        });
  }
}
