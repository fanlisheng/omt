import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/view_models/add_nvr_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../view_models/device_add_viewmodel.dart';

class AddRouterView extends StatelessWidget {
  final DeviceAddViewModel model;

  const AddRouterView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return nvrView(model);
  }

  Widget nvrView(DeviceAddViewModel model) {
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
                "第二：添加路由器信息",
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
                        ui.TextBox(
                          readOnly: true,
                          enabled: false,
                          controller: model.routerIpController,
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
      ],
    );
  }
}
