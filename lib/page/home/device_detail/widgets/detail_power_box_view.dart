import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../../device_add/widgets/add_ai_view.dart';
import '../view_models/detail_power_box_viewmodel.dart';
import 'detail_ai_view.dart';

class DetailPowerBoxView extends StatelessWidget {
  final String nodeId;

  const DetailPowerBoxView({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailPowerBoxViewModel>(
        model: DetailPowerBoxViewModel(nodeId)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return powerBoxView(model);
        });
  }

  Widget powerBoxView(DetailPowerBoxViewModel model) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            // crossAxisAlignment: CrossAxisAlignment.start,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorBackgroundLine,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  width: double.infinity,
                  child: infoView(model),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorBackgroundLine,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: edInfoView(model),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Clickable(
              onTap: () {
                model.restartAction();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorUtils.colorGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "重启主程",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Clickable(
              onTap: () {
                model.openDcAllAction();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorUtils.colorGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "打开所有DC",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            ),
            Expanded(child: Container()),
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
                  "拆除信息",
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
    );
  }

  Widget infoView(DetailPowerBoxViewModel model) {
    return Container(
      // height: 140,
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
              RowItemInfoView(name: "编码", value: model.deviceInfo.deviceCode),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(
                  name: "电池电压", value: "${model.deviceInfo.batteryVoltage}"),
              RowItemInfoView(
                  name: "电量", value: "${model.deviceInfo.batteryCapacity}"),
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
              const RowItemInfoView(name: "", value: ""),
            ],
          ),
        ],
      ),
    );
  }

  Widget edInfoView(DetailPowerBoxViewModel model) {
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
                            model.changeDeviceStateAction(info);
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
                            model.openDcAction(info);
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
