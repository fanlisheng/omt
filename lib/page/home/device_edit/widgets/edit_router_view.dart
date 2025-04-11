import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/utils/color_utils.dart';
import '../../../../bean/common/id_name_value.dart';
import '../view_models/edit_router_viewmodel.dart';

class EditRouterView extends StatelessWidget {
  final EditRouterViewModel model;

  const EditRouterView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditRouterViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return routerView(model);
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
                "修改路由器信息",
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
                        ui.ComboBox<IdNameValue>(
                          isExpanded: true,
                          value: model.selectedRouterInOut,
                          items: model.inOutList
                              .map<ui.ComboBoxItem<IdNameValue>>((e) {
                            return ui.ComboBoxItem<IdNameValue>(
                              value: e,
                              child: SizedBox(
                                child: Text(
                                  e.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (a) {
                            model.selectedRouterInOut = a!;
                            model.notifyListeners();
                          },
                          placeholder: const Text(
                            "请选择进/出口",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorBlackLiteLite),
                          ),
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
                        ui.ComboBox<IdNameValue>(
                          isExpanded: true,
                          value: model.selectedRouterType,
                          items: model.routerTypeList
                              .map<ui.ComboBoxItem<IdNameValue>>((e) {
                            return ui.ComboBoxItem<IdNameValue>(
                              value: e,
                              child: SizedBox(
                                child: Text(
                                  e.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (a) {
                            model.selectedRouterType = a!;
                            model.notifyListeners();
                          },
                          placeholder: const Text(
                            "请选择有线/无线",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorBlackLiteLite),
                          ),
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
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Clickable(
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorUtils.colorGreen,
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
                  model.saveRouterEdit();
                },
              ),
              const SizedBox(width: 10),
              Clickable(
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorUtils.colorGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "确认修改",
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
        ),
      ],
    );
  }
}
