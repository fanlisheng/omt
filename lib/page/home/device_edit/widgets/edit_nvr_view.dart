import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../view_models/edit_nvr_viewmodel.dart';

class EditNvrView extends StatelessWidget {
  final EditNvrViewModel model;

  const EditNvrView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditNvrViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return nvrView(model);
        });
  }

  Widget nvrView(EditNvrViewModel model) {
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
                "编辑NVR设备",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // NVR IP 地址选择
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
                          value: model.selectedNarInOut,
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
                            model.selectedNarInOut = a;
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
                        Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorRed),
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              "NVR IP地址",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                            const SizedBox(width: 10),
                            Clickable(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: model.isNvrSearching == false
                                      ? ColorUtils.colorGreen
                                      : ColorUtils.colorGrayLight,
                                ),
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 2, bottom: 2),
                                child: const Text(
                                  "刷新",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ),
                              onTap: () {
                                model.refreshNvrAction();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          model.selectedNvr?.ip ?? "未选择",
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                          ),
                        ),
                      ],
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "保存",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  model.saveNvrEdit();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
} 