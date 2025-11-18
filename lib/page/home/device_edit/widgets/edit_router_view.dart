import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/combobox.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_router_entity_entity.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../view_models/edit_router_viewmodel.dart';

class EditRouterView extends StatelessWidget {
  final DeviceDetailRouterData model;

  const EditRouterView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditRouterViewModel>(
        model: EditRouterViewModel(model)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return DHeaderPage(
            title: "修改信息",
            titlePath: "首页 / 路由器 / ",
            content: routerView(model),
          );
        });
  }

  Widget routerView(EditRouterViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "修改信息",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorRed),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "进/出口",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FComboBox<IdNameValue>(
                          selectedValue: model.selectedRouterInOut,
                          items: model.inOutList,
                          onChanged: (a) {
                            model.selectedRouterInOut = a;
                            model.notifyListeners();
                          },
                          placeholder: "请选择进/出口",
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorRed),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "路由器IP",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: ui.TextBox(
                            placeholder: "路由器IP地址",
                            controller: model.routerIpController,
                            style: const TextStyle(fontSize: 12),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorRed),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "有线/无线",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FComboBox<IdNameValue>(
                          selectedValue: model.selectedRouterType,
                          items: model.routerTypeList,
                          onChanged: (a) {
                            model.selectedRouterType = a;
                            model.notifyListeners();
                          },
                          placeholder: "请选择有线/无线",
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ui.Container(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                // width: 120,
                // height: 36,
                decoration: BoxDecoration(
                  color: ColorUtils.colorRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "取消",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                IntentUtils.share.pop(model.context!);
              },
            ),
            const SizedBox(width: 10),
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme().color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "确认",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                model.saveRouterEdit();
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
