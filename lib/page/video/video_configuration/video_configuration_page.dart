import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
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
                        TfbTitleSub(
                            title: '工控机IP',
                            subTitle: '',
                            controller: model.controllerIP),
                        const Spacer(),
                        TextView(
                          null != model.videoConnectEntity ? '已连接' : '未连接',
                          color: null != model.videoConnectEntity
                              ? ColorUtils.colorGreen
                              : ColorUtils.colorRed,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '连接',
                          textDarkOnlyOpacity: true,
                          onPressed: () {
                            model.connect();
                          },
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
                              subTitle: model.videoConnectEntity?.tcpAddr,
                              // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                              title: '建委地址',
                              subTitle: model.videoConnectEntity?.httpAddr,
                              // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                              title: '建委Key',
                              subTitle: model.videoConnectEntity?.key,
                              // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                              title: '建委Secret',
                              subTitle: model.videoConnectEntity?.secret,
                              // controller: TextEditingController()
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '保存',
                          textDarkOnlyOpacity: true,
                          onPressed: () {
                            LoadingUtils.showInfo(data: '暂不开放修改');
                          },
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
                              subTitle: model.controllerIP?.text,
                              // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                              title: '掩码',
                              subTitle: '',
                              // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                                title: '网关',
                                subTitle: '',
                                // controller: TextEditingController()
                            ),
                            TfbTitleSub(
                                title: 'DNS',
                                subTitle: '',
                                // controller: TextEditingController()
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 30,
                        ),
                        ButtonView(
                          text: '保存',
                          textDarkOnlyOpacity: true,
                          onPressed: () {
                            LoadingUtils.showInfo(data: '暂不开放修改');
                          },
                        ),
                      ],
                    ))
              ]);
        });
  }
}
