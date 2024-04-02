import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/refresh_tools.dart';
import 'camera_bound_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  omt
///  camera_bound_page.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraBoundPage extends StatelessWidget {
  const CameraBoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CameraBoundViewModel>(
        model: CameraBoundViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
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
                            placeholder: '输入或选择区域',
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
                                      debugPrint('Focused $e');
                                    }
                                  });
                            }).toList(),
                            focusNode: model.focusNode,
                            onSelected: (item) {
                              // setState(() => selected = item);
                            },
                          ))
                    ],
                  ),
                  Expanded(
                      child: RefreshUtils.init(
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return TextView(
                                'item',
                                height: 100,
                              );
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
                          showNoDataWidget: BaseSysUtils.empty(model.data),
                          noDataText: ''))
                ],
              ));
        });
  }
}
