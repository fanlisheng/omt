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
import '../../../../theme.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../../device_detail/view_models/detail_power_box_viewmodel.dart';
import '../../device_detail/widgets/detail_ai_view.dart';
import '../view_models/edit_power_box_viewmodel.dart';

class EditPowerBoxView extends StatelessWidget {
  final DeviceDetailPowerBoxData model;
  final bool? isReplace; //是替换 默认否

  const EditPowerBoxView({super.key, required this.model, this.isReplace});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditPowerBoxViewModel>(
        model: EditPowerBoxViewModel(model, isReplace ?? false)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return DHeaderPage(
            title: "编辑电源箱",
            titlePath: "首页 / 电源箱 / ",
            content: replaceBoxView(model),
          );
        });
  }

  Widget editPowerBoxView(EditPowerBoxViewModel model) {
    return ListView(
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
                "编辑电源箱",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                            fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (model.selectedDeviceDetailPowerBox != null) ...[
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
        ],
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
                model.savePowerBoxEdit();
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget replaceBoxView(EditPowerBoxViewModel model) {
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
                "替换",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              EquallyRow(
                  one: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RowTitle(name: "电源箱编码"),
                  const SizedBox(height: 8),
                  ui.ComboBox<DeviceDetailPowerBoxData>(
                    isExpanded: true,
                    value: model.selectedDeviceDetailPowerBox,
                    items: model.powerBoxList
                        .map<ui.ComboBoxItem<DeviceDetailPowerBoxData>>((e) {
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
                          fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        if (model.selectedDeviceDetailPowerBox != null) ...[
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

  Widget edInfoView(EditPowerBoxViewModel model) {
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
                (model.deviceInfo.dcInterfaces ?? []).asMap().keys.map((index) {
              DeviceDetailPowerBoxDataDcInterfaces info =
                  (model.deviceInfo.dcInterfaces ?? [])[index];
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

  Widget infoView(EditPowerBoxViewModel model) {
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
              RowItemInfoView(
                  name: "电池电压", value: "${model.deviceInfo.batteryVoltage}"),
              RowItemInfoView(
                  name: "电量", value: "${model.deviceInfo.batteryCapacity}%"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(
                  name: "供电状态", value: model.deviceInfo.powerStatus),
              RowItemInfoView(name: "工作时长", value: model.deviceInfo.workTime),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(
                  name: "进风口温度", value: "${model.deviceInfo.inletTemperature}"),
              RowItemInfoView(
                  name: "出风口温度",
                  value: "${model.deviceInfo.outletTemperature}"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "版本", value: model.deviceInfo.version),
              RowItemInfoView(
                name: "IOT状态",
                value: model.deviceInfo.iotConnectStatus,
                hasState: true,
                stateColor: model.deviceInfo.iotConnectStatus == "连接成功"
                    ? ColorUtils.colorGreen
                    : ColorUtils.colorRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
