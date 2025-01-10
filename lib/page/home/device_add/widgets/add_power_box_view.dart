import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/local_device_entity.dart';
import '../view_models/add_ai_viewmodel.dart';
import '../view_models/add_power_box_viewmodel.dart';
import '../view_models/device_add_viewmodel.dart';
import 'add_ai_view.dart';

class AddPowerBoxView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;

  const AddPowerBoxView(this.deviceType, this.stepNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddPowerBoxViewModel>(
        model: AddPowerBoxViewModel(deviceType, stepNumber)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return powerBoxView(model);
        });
  }

  Widget powerBoxView(AddPowerBoxViewModel model) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "第二步：添加AI设备",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "*",
                    style: TextStyle(fontSize: 12, color: ColorUtils.colorRed),
                  ),
                  SizedBox(width: 2),
                  Text(
                    "现场是否需要安装电源箱",
                    style:
                        TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: model.isPowerBoxNeeded,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.isPowerBoxNeeded = value as bool;
                      model.notifyListeners();
                    },
                  ),
                  Text("需要",
                      style: TextStyle(
                          fontSize: 12,
                          color: model.isPowerBoxNeeded
                              ? ColorUtils.colorGreen
                              : ColorUtils.colorWhite)),
                  const SizedBox(width: 16),
                  Radio(
                    value: false,
                    groupValue: model.isPowerBoxNeeded,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.isPowerBoxNeeded = value as bool;
                      model.notifyListeners();
                    },
                  ),
                  Text("不需要",
                      style: TextStyle(
                          fontSize: 12,
                          color: model.isPowerBoxNeeded
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen)),
                ],
              ),
              if (model.isPowerBoxNeeded == true) ...[
                const SizedBox(height: 10),
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
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ui.ComboBox<String>(
                              isExpanded: false,
                              value: model.selectedEntryExit,
                              items: model.entryExitList
                                  .map<ui.ComboBoxItem<String>>((e) {
                                return ui.ComboBoxItem<String>(
                                  value: e,
                                  child: SizedBox(
                                    width: 300,
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.start,
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
                          ],
                        )),
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
                                  "电源箱编码",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ui.ComboBox<String>(
                              isExpanded: false,
                              value: model.selectedPowerBoxCoding,
                              items: model.powerBoxCodingList
                                  .map<ui.ComboBoxItem<String>>((e) {
                                return ui.ComboBoxItem<String>(
                                  value: e,
                                  child: SizedBox(
                                    width: 300,
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (a) {
                                model.selectedPowerBoxCoding = a!;
                                model.notifyListeners();
                              },
                              placeholder: const Text(
                                "请选择电源箱编码",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorUtils.colorBlackLiteLite),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ]
            ],
          ),
        ),
        if (model.isPowerBoxNeeded == true &&
            model.selectedPowerBoxCoding.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            color: ColorUtils.colorBackgroundLine,
            width: double.infinity,
            child: infoView(model),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            color: ColorUtils.colorBackgroundLine,
            width: double.infinity,
            child: edInfoView(model),
          ),
        ]
      ],
    );
  }

  Widget infoView(AddPowerBoxViewModel model) {
    return Container(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "电源${model.selectedPowerBoxCoding}箱信息",
            style: const TextStyle(
              fontSize: 14,
              color: ColorUtils.colorGreenLiteLite,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "电池电压）", value: "电池电压"),
              RowItemInfoView(name: "电量", value: "100%"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "供电状态", value: "供电状态"),
              RowItemInfoView(name: "工作时长", value: "工作时长"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "进风口温度", value: "进风口温度"),
              RowItemInfoView(name: "出风口温度", value: "出风口温度"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "版本", value: "版本"),
              RowItemInfoView(name: "IOT状态", value: "在线"),
            ],
          ),
        ],
      ),
    );
  }

  Widget edInfoView(AddPowerBoxViewModel model) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        decoration: BoxDecoration(color: "#3B3F3F".toColor()),
        dataRowHeight: 40,
        headingRowHeight: 40,
        dividerThickness: 0.01,
        columns: const [
          DataColumn(label: Text("DC", style: TextStyle(fontSize: 12))),
          DataColumn(label: Text("状态", style: TextStyle(fontSize: 12))),
          DataColumn(label: Text("电压", style: TextStyle(fontSize: 12))),
          DataColumn(label: Text("电流", style: TextStyle(fontSize: 12))),
          DataColumn(label: Text("运行设备", style: TextStyle(fontSize: 12))),
          DataColumn(label: Text("操作", style: TextStyle(fontSize: 12))),
        ],
        rows: model.edPortInfo.asMap().keys.map((index) {
          Map<String, String> info = model.edPortInfo[index];
          return DataRow(
              color: WidgetStateProperty.all(
                  index % 2 == 0 ? "#4E5353".toColor() : "#3B3F3F".toColor()),
              cells: [
                DataCell(Text(
                  info["DC"]!,
                  style: const TextStyle(fontSize: 12),
                )),
                DataCell(Text(
                  info["状态"]!,
                  style: const TextStyle(fontSize: 12),
                )),
                DataCell(
                    Text(info["电压"]!, style: const TextStyle(fontSize: 12))),
                DataCell(
                    Text(info["电流"]!, style: const TextStyle(fontSize: 12))),
                DataCell(
                    Text(info["运行设备"]!, style: const TextStyle(fontSize: 12))),
                DataCell(Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        model.edPortInfo.remove(info);
                        model.notifyListeners();
                      },
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                        ),
                        shape: WidgetStatePropertyAll(
                          //圆角
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        side: const WidgetStatePropertyAll(
                            BorderSide(color: ColorUtils.colorRed, width: 1.0)),
                      ),
                      child: const Text(
                        "关闭",
                        style:
                            TextStyle(fontSize: 12, color: ColorUtils.colorRed),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        model.edPortInfo.remove(info);
                        model.notifyListeners();
                      },
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                        ),
                        shape: WidgetStatePropertyAll(
                          //圆角
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        side: const WidgetStatePropertyAll(
                            BorderSide(color: ColorUtils.colorRed, width: 1.0)),
                      ),
                      child: const Text(
                        "记录",
                        style:
                            TextStyle(fontSize: 12, color: ColorUtils.colorRed),
                      ),
                    ),
                  ],
                )),
              ]);
        }).toList(),
      ),
    );
  }
}
