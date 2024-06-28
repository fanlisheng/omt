import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/refresh_tools.dart';
import 'camera_bound_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  omt
///  camera_bound_delete_page.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraBoundPage extends StatelessWidget {
  const CameraBoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CameraBoundViewModel>(
        model: CameraBoundViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          var noteMessage =
              // 'IP标记为红色，说明该条IP在NVR上有重复配置；\nID标记为红色，说明NVR当前没有配置此设备到国标配置中；\nIP、ID全是红色，可能是NVR离线了。';
              '红色ID：设备离线\n红色IP：有重复配置';

          return fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: Text('已绑定矿区摄像头管理'),
              ),
              content: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 300,
                          child: fu.AutoSuggestBox<IdNameValue>(
                            placeholder: '输入或选择矿区',
                            key: model.asbKey,
                            items: model.points.map((e) {
                              return fu.AutoSuggestBoxItem<IdNameValue>(
                                  value: e,
                                  label: e.name ?? '',
                                  child: TextView(
                                    e.name,
                                    maxLine: 1,
                                    color: ColorUtils.colorBlackLite,
                                    size: 12,
                                  ),
                                  onFocusChange: (focused) {
                                    if (focused) {
                                      // debugPrint('Focused $e -- ${model.asbKey.currentState?.widget.controller?.text}',);
                                    }
                                  });
                            }).toList(),
                            focusNode: model.focusNode,
                            onSelected: (item) {
                              model.onPointSelected(item);
                            },
                            onChanged: (text, TextChangedReason r) {
                              if (r == TextChangedReason.cleared) {
                                model.onPointSelected(null);
                              }
                              model.sgText = text;
                              LogUtils.info(
                                  tag: 'TextChangedReason', msg: r.toString());
                            },
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      fu.Tooltip(
                        message: noteMessage,
                        displayHorizontally: true,
                        useMousePosition: true,
                        style: const fu.TooltipThemeData(preferBelow: true),
                        child: fu.IconButton(
                          icon: const Icon(Icons.info, size: 24.0),
                          onPressed: () {
                            fu.showDialog<String>(
                              context: context,
                              builder: (context) => ContentDialog(
                                title: const Text('备注'),
                                content: Text(
                                  noteMessage,
                                ),
                                actions: [
                                  Button(
                                    child: const Text('确定'),
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                      // Delete file here
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      TextView('IP').addExpanded(flex: 2),
                      TextView('名称').addExpanded(flex: 3),
                      TextView('ID').addExpanded(flex: 3),
                      TextView(
                        '操作',
                        alignment: Alignment.center,
                      ).addExpanded(flex: 1)
                    ],
                  ).addContainer(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      color: ColorUtils.colorCCC.dark,
                      margin: const EdgeInsets.only(top: 6, bottom: 6)),
                  RefreshUtils.init(
                          notApp: true,
                          page: model.getPageIndex(),
                          size: model.getPageSize(),
                          total: model.cameraHttpEntity?.page?.total,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              var data = model.data[index];
                              return Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? ColorUtils.colorWhite.dark
                                          : ColorUtils.transparent),
                                  child: Row(
                                    children: [
                                      TextView(
                                        data.ip_address,
                                        color: data.duplicateIP(model.data,data) != true
                                            ? ColorUtils.colorBlack
                                            : ColorUtils.colorRed,
                                        maxLine: 2,
                                      ).addExpanded(flex: 2),
                                      TextView(
                                        data.name,
                                        maxLine: 2,
                                      ).addExpanded(flex: 3),
                                      TextView(
                                        data.gb_id,
                                        maxLine: 2,
                                        color: data.online == 1
                                            ? ColorUtils.colorBlack
                                            : ColorUtils.colorRed,
                                      ).addExpanded(flex: 3),
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextView(
                                          '删除',
                                          padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                              top: 4,
                                              bottom: 4),
                                          onTap: () {
                                            if (model.selectedPoint?.id ==
                                                null) {
                                              LoadingUtils.showToast(
                                                  data: '请先选择矿区');
                                            } else {
                                              model.deleteDevice(data);
                                            }
                                          },
                                        ),
                                      ).addExpanded(flex: 1)
                                    ],
                                  ));
                            },
                            itemCount: model.data.length,
                          ),
                          controller: model.refreshController,
                          onLoad: () {
                            model.loadMore();
                          },
                          onRefresh: () {
                            model.refresh();
                          },
                          onLoadPageWithIndex: (index) {
                            model.loadDataWithPageIndex(index + 1);
                          },
                          showNoDataWidget: BaseSysUtils.empty(model.data),
                          noDataText: '')
                      .addExpanded()
                ],
              ));
        });
  }
}
