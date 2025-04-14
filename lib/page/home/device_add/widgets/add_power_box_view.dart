import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../device_detail/widgets/detail_ai_view.dart';
import '../view_models/add_power_box_viewmodel.dart';
import 'add_ai_view.dart';

class AddPowerBoxView extends StatelessWidget {
  final AddPowerBoxViewModel model;

  const AddPowerBoxView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return ProviderWidget<AddPowerBoxViewModel>(
        model: model..themeNotifier = true,
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
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "第${(model.isInstall == false) ? "二" : "五"}步：添加电源箱",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.isInstall == true) ...[
                const SizedBox(height: 16),
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
              ],
              if (model.isPowerBoxNeeded == true) ...[
                const SizedBox(height: 10),
                EquallyRow(
                    one: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RowTitle(name: "进/出口"),
                        const SizedBox(height: 8),
                        ui.ComboBox<IdNameValue>(
                          isExpanded: true,
                          value: model.selectedPowerBoxInOut,
                          items: model.inOutList
                              .map<ui.ComboBoxItem<IdNameValue>>((e) {
                            return ui.ComboBoxItem<IdNameValue>(
                              value: e,
                              child: SizedBox(
                                child: Text(
                                  e.name ?? "",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (a) {
                            model.selectedPowerBoxInOut = a!;
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
                    ),
                    two: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RowTitle(name: "电源箱编码"),
                        const SizedBox(height: 8),
                        ui.ComboBox<DeviceDetailPowerBoxData>(
                          isExpanded: true,
                          value: model.selectedDeviceDetailPowerBox,
                          items: model.powerBoxList
                              .map<ui.ComboBoxItem<DeviceDetailPowerBoxData>>(
                                  (e) {
                            return ui.ComboBoxItem<DeviceDetailPowerBoxData>(
                              value: e,
                              child: SizedBox(
                                child: Text(
                                  e.deviceCode ?? '',
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (a) {
                            model.selectedPowerBoxCode(a);
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
              ]
            ],
          ),
        ),
        if (model.isPowerBoxNeeded == true &&
            model.selectedDeviceDetailPowerBox != null) ...[
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              color: ColorUtils.colorBackgroundLine,
              borderRadius: BorderRadius.circular(3),
            ),
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
            decoration: BoxDecoration(
              color: ColorUtils.colorBackgroundLine,
              borderRadius: BorderRadius.circular(3),
            ),
            width: double.infinity,
            child: edInfoView(model),
          ),
        ]
      ],
    );
  }

  Widget infoView(AddPowerBoxViewModel model) {
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "电源${model.selectedDeviceDetailPowerBox?.deviceCode ?? ""}箱信息",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "电源箱DC接口信息",
          style: TextStyle(
            fontSize: 14,
            color: ColorUtils.colorGreenLiteLite,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            decoration: BoxDecoration(
              color: "#3B3F3F".toColor(),
              borderRadius: BorderRadius.circular(3),
            ),
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
            rows:
            (model.selectedDeviceDetailPowerBox?.dcInterfaces ?? []).asMap().keys.map((index) {
              DeviceDetailPowerBoxDataDcInterfaces info =
              (model.selectedDeviceDetailPowerBox?.dcInterfaces ?? [])[index];
              return DataRow(
                  color: WidgetStateProperty.all(index % 2 == 0
                      ? "#4E5353".toColor()
                      : "#3B3F3F".toColor()),
                  cells: [
                    DataCell(Text(
                      (info.interfaceNum ?? 0).toString(),
                      style: const TextStyle(fontSize: 12),
                    )),
                    DataCell(Text(
                      info.statusText ?? "",
                      style: const TextStyle(fontSize: 12),
                    )),
                    DataCell(Text((info.voltage ?? 0).toString(),
                        style: const TextStyle(fontSize: 12))),
                    DataCell(Text((info.current ?? 0).toString(),
                        style: const TextStyle(fontSize: 12))),
                    DataCell(Text(info.connectDevice ?? "",
                        style: const TextStyle(fontSize: 12))),
                    DataCell(Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            model.openDcAction(info);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: -2.0, horizontal: 10),
                            ),
                            shape: WidgetStatePropertyAll(
                              //圆角
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            side: const WidgetStatePropertyAll(BorderSide(
                                color: ColorUtils.colorRed, width: 1.0)),
                          ),
                          child: Text(
                            info.statusText == "关闭" ? "打开" : "关闭",
                            style: TextStyle(
                                fontSize: 12,
                                color: info.statusText == "关闭"
                                    ? ColorUtils.colorGreen
                                    : ColorUtils.colorRed),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            model.recordDeviceAction(info);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10),
                            ),
                            shape: WidgetStatePropertyAll(
                              //圆角
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            side: const WidgetStatePropertyAll(BorderSide(
                                color: ColorUtils.colorRed, width: 1.0)),
                          ),
                          child: const Text(
                            "记录",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorRed),
                          ),
                        ),
                      ],
                    )),
                  ]);
            }).toList(),
          ),
        )
      ],
    );
  }
}
