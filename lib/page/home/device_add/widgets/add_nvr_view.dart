import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/view_models/add_nvr_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../view_models/device_add_viewmodel.dart';

class AddNvrView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool? showInstall;

  const AddNvrView(
      {super.key, required this.deviceType, required this.stepNumber, this.showInstall});

  // AddNvrViewModel model;
  // AddNvrView(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddNvrViewModel>(
        model: AddNvrViewModel(deviceType, stepNumber,showInstall ?? false)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model1, child) {
          return nvrView(model1);
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
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "第${(model.showInstall == false) ? "二" : "四"}步：添加Nvr设备",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.showInstall) ...[
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
                      },
                    ),
                    Text("需要",
                        style: TextStyle(
                            fontSize: 12,
                            color: model.isNvrNeeded
                                ? ColorUtils.colorGreen
                                : ColorUtils.colorWhite)),
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
                    Text("不需要",
                        style: TextStyle(
                            fontSize: 12,
                            color: model.isNvrNeeded
                                ? ColorUtils.colorWhite
                                : ColorUtils.colorGreen)),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              // NVR IP 地址选择
              if (model.isNvrNeeded) ...[
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
                          ui.ComboBox<String>(
                            isExpanded: true,
                            value: model.selectedEntryExit,
                            items: ["共用进出口", "进出口1", "进出口2"]
                                .map<ui.ComboBoxItem<String>>((e) {
                              return ui.ComboBoxItem<String>(
                                value: e,
                                child: SizedBox(
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorBlackLiteLite),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (a) {
                              model.selectedEntryExit = a!;
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
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 2, bottom: 2),
                                  color: ColorUtils.colorGreen,
                                  child: const Text(
                                    "刷新",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorWhite),
                                  ),
                                ),
                                onTap: () {
                                  model.refreshEventAction();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0, // 子元素之间的水平间距
                            children: List.generate(
                              model.nvrIpList.length, // 动态生成子元素数量
                              (index) {
                                final ip = model.nvrIpList[index];
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                      value: ip,
                                      groupValue: model.selectedNvrIp,
                                      activeColor: ColorUtils.colorGreen,
                                      onChanged: (value) {
                                        model.selectedNvrIp = value as String;
                                        model.isNvrNeeded = true;
                                        model.notifyListeners();
                                      },
                                    ),
                                    Text(
                                      ip,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: model.selectedNvrIp == ip
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
        if (model.isNvrNeeded == true && model.selectedNvrIp != null) ...[
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              color: ColorUtils.colorBackgroundLine,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("NVR信息",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          decoration: BoxDecoration(color: "#3B3F3F".toColor()),
                          dataRowHeight: 40,
                          headingRowHeight: 40,
                          dividerThickness: 0.01,
                          columns: const [
                            DataColumn(
                                label: Text("通道号",
                                    style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label: Text("是否在录像",
                                    style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label: Text("信号状态",
                                    style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label: Text("更新时间",
                                    style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label:
                                    Text("操作", style: TextStyle(fontSize: 12))),
                          ],
                          rows: model.nvrInfo.asMap().keys.map((index) {
                            Map<String, String> info = model.nvrInfo[index];
                            return DataRow(
                                color: WidgetStateProperty.all(index % 2 == 0
                                    ? "#4E5353".toColor()
                                    : "#3B3F3F".toColor()),
                                cells: [
                                  DataCell(Text(
                                    info["通道号"]!,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  DataCell(Text(
                                    info["是否在录像"]!,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  DataCell(Text(info["信号状态"]!,
                                      style: const TextStyle(fontSize: 12))),
                                  DataCell(Text(info["更新时间"]!,
                                      style: const TextStyle(fontSize: 12))),
                                  DataCell(
                                    OutlinedButton(
                                      onPressed: () {
                                        model.nvrInfo.remove(info);
                                        model.notifyListeners();
                                      },
                                      style: ButtonStyle(
                                        padding: const WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 16),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          //圆角
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        side: const WidgetStatePropertyAll(
                                            BorderSide(
                                                color: ColorUtils.colorRed,
                                                width: 1.0)),
                                      ),
                                      child: const Text(
                                        "删除通道",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorUtils.colorRed),
                                      ),
                                    ),
                                  ),
                                ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
