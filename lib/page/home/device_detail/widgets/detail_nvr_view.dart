import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/view_models/add_nvr_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../../device_add/widgets/add_nvr_view.dart';
import '../view_models/detail_nvr_viewmodel.dart';
import 'detail_ai_view.dart';

class DetailNvrView extends StatelessWidget {
  final String nodeId;
  final Function(bool) onChange;

  const DetailNvrView(
      {super.key, required this.nodeId, required this.onChange});

  // AddNvrViewModel model;
  // AddNvrView(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailNvrViewModel>(
        model: DetailNvrViewModel(nodeId, onChange: onChange)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model1, child) {
          return nvrView(model1);
        });
  }

  Widget nvrView(DetailNvrViewModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: ColorUtils.colorBackgroundLine,
        borderRadius: BorderRadius.circular(3),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            "NVR信息",
            style: TextStyle(
              fontSize: 14,
              color: ColorUtils.colorGreenLiteLite,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "实例", value: model.deviceInfo.instanceName),
              RowItemInfoView(name: "大门编号", value: model.deviceInfo.gateName),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "进/出口", value: model.deviceInfo.passName),
              RowItemInfoView(name: "标签", value: model.deviceInfo.labelName),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "IP地址", value: model.deviceInfo.ip),
              RowItemInfoView(name: "MAC地址", value: model.deviceInfo.mac),
            ],
          ),
          const SizedBox(height: 20),
          DashLine(
              height: 1,
              width: double.infinity,
              color: "#678384".toColor(),
              gap: 3),
          const SizedBox(height: 20),
          Expanded(
            child: NvrInfoWidget.buildNvrChannelsInfoContainer(
                channels: model.deviceInfo.channels,
                deviceCode: model.deviceInfo.deviceCode ?? "",
                nodeId: model.deviceInfo.nodeId,
                onRemoveSuccess: () {
                  model.requestData();
                }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Clickable(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "修改信息",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  model.editAction();
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Clickable(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: "#2F94DD".toColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "替换设备",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  model.replaceAction();
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Clickable(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorRed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "拆除设备",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  model.removeAction();
                },
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
