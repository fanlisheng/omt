import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/view_models/add_nvr_viewmodel.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_nvr_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../http/http_query.dart';
import '../view_models/device_add_viewmodel.dart';

class AddNvrView extends StatelessWidget {
  final AddNvrViewModel model;

  const AddNvrView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddNvrViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return nvrView(model);
        });
  }

  Widget nvrView(AddNvrViewModel model) {
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
                "第二步：添加Nvr设备",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.pNodeCode.isEmpty) ...[
                const SizedBox(height: 16),
                // 是否需要安装NVR
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "*",
                      style:
                          TextStyle(fontSize: 12, color: ColorUtils.colorRed),
                    ),
                    SizedBox(width: 2),
                    Text(
                      "现场是否需要安装NVR",
                      style:
                          TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: model.isNvrNeeded,
                      activeColor: ColorUtils.colorGreen,
                      onChanged: (value) {
                        model.isNvrNeeded = value as bool;
                        model.notifyListeners();
                        if(model.nvrDeviceList.isEmpty){
                          model.refreshNvrAction();
                        }
                      },
                    ),
                    Text(
                      "需要",
                      style: TextStyle(
                          fontSize: 12,
                          color: (model.isNvrNeeded ?? false)
                              ? ColorUtils.colorGreen
                              : ColorUtils.colorWhite),
                    ),
                    const SizedBox(width: 16),
                    Radio(
                      value: false,
                      groupValue: model.isNvrNeeded,
                      activeColor: ColorUtils.colorGreen,
                      onChanged: (value) {
                        model.isNvrNeeded = value as bool;
                        model.notifyListeners();
                      },
                    ),
                    Text(
                      "不需要",
                      style: TextStyle(
                          fontSize: 12,
                          color: (model.isNvrNeeded ?? true)
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              // NVR IP 地址选择
              if (model.isNvrNeeded ?? false) ...[
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
                              model.selectedNarInOut = a!;
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
                          Wrap(
                            spacing: 8.0, // 子元素之间的水平间距
                            children: List.generate(
                              model.nvrDeviceList.length, // 动态生成子元素数量
                              (index) {
                                DeviceEntity device =
                                    model.nvrDeviceList[index];
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                      value: device,
                                      groupValue: model.selectedNvr,
                                      activeColor: model.selectedNvr == device
                                          ? ColorUtils.colorGreen
                                          : ColorUtils.colorWhite,
                                      onChanged: (value) {
                                        model.selectNvrIpAction(device);
                                      },
                                    ),
                                    Text(
                                      "${device.ip}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: model.selectedNvr == device
                                            ? ColorUtils.colorGreen
                                            : ColorUtils.colorWhite,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),

        // NVR 信息表格
        if (model.isNvrNeeded == true && model.selectedNvr != null) ...[
          const SizedBox(height: 10),
          Expanded(
            child: NvrInfoWidget.buildNvrInfoContainer(
                channels: model.nvrData.channels,
                deviceCode: model.selectedNvr?.deviceCode ?? "",
                onRemoveSuccess: () {
                  model.requestData(model.selectedNvr?.deviceCode ?? "");
                }),
          ),
        ],
      ],
    );
  }
}

class NvrInfoWidget {
  static Widget buildNvrInfoContainer({
    required List<DeviceDetailNvrDataChannels>? channels,
    required String deviceCode,
    String? nodeId,
    Function()? onRemoveSuccess,
  }) {
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
          const Text(
            "NVR信息",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: buildNvrChannelsInfoContainer(
              channels: channels,
              deviceCode: deviceCode,
              nodeId: nodeId,
              onRemoveSuccess: onRemoveSuccess,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildNvrChannelsInfoContainer({
    required List<DeviceDetailNvrDataChannels>? channels,
    required String deviceCode,
    String? nodeId,
    Function()? onRemoveSuccess,
  }) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          decoration: BoxDecoration(color: "#3B3F3F".toColor()),
          dataRowHeight: 40,
          headingRowHeight: 40,
          dividerThickness: 0.01,
          columns: const [
            DataColumn(
              label: Text("通道号", style: TextStyle(fontSize: 12)),
            ),
            DataColumn(
              label: Text("是否在录像", style: TextStyle(fontSize: 12)),
            ),
            DataColumn(
              label: Text("信号状态", style: TextStyle(fontSize: 12)),
            ),
            DataColumn(
              label: Text("更新时间", style: TextStyle(fontSize: 12)),
            ),
            DataColumn(
              label: Text("操作", style: TextStyle(fontSize: 12)),
            ),
          ],
          rows: (channels ?? []).asMap().keys.map((index) {
            DeviceDetailNvrDataChannels info = channels![index];
            return DataRow(
              color: WidgetStateProperty.all(
                index % 2 == 0 ? "#4E5353".toColor() : "#3B3F3F".toColor(),
              ),
              cells: [
                DataCell(
                  Text(
                    "${info.channelNum ?? 0}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    info.recordStatus ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      color: (info.recordStatus ?? "") == "正在录像"
                          ? AppTheme().color
                          : ColorUtils.colorRed,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    info.signalStatus ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    info.updatedAt ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  (info.recordStatus ?? "") == "正在录像"
                      ? Container()
                      : OutlinedButton(
                          onPressed: () {
                            removeChannelAction(
                              deviceCode: deviceCode,
                              info: info,
                              nodeId: nodeId,
                              onSuccess: onRemoveSuccess,
                            );
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            side: const WidgetStatePropertyAll(
                              BorderSide(
                                color: ColorUtils.colorRed,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            "删除通道",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorRed,
                            ),
                          ),
                        ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  static void removeChannelAction({
    required String deviceCode,
    required DeviceDetailNvrDataChannels info,
    String? nodeId,
    Function()? onSuccess,
  }) {
    HttpQuery.share.homePageService.deleteNvrChannel(
      deviceCode: deviceCode,
      nodeId: nodeId,
      channels: [
        {"id": info.id ?? 0, "channel_num": info.channelNum}
      ],
      onSuccess: (data) {
        LoadingUtils.showToast(data: "移除成功!");
        onSuccess?.call();
      },
    );
  }
}
