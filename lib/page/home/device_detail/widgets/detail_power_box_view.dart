import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/theme.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../../device_add/widgets/add_ai_view.dart';
import '../../device_add/widgets/power_box_dc_widget.dart';
import '../view_models/detail_power_box_viewmodel.dart';
import 'detail_ai_view.dart';

class DetailPowerBoxView extends StatelessWidget {
  final String nodeId;
  final Function(bool) onChange;

  const DetailPowerBoxView(
      {super.key, required this.nodeId, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailPowerBoxViewModel>(
        model: DetailPowerBoxViewModel(nodeId, onChange: onChange)
          ..themeNotifier = true,
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
                        child: PowerBoxDcWidget.buildPowerBoxDcContainer(
                            dcInterfaces: model.deviceInfo.dcInterfaces ?? [],
                            deviceCode: model.deviceInfo.deviceCode ?? "",
                            context: model.context!,
                            onOpenDcSuccess: (info) {
                              LoadingUtils.showToast(
                                  data:
                                      "${(info.statusText == "打开") ? "关闭" : "打开"}成功!");
                              model.requestData();
                            },
                            onRecordSuccess: (info) {
                              LoadingUtils.showToast(data: "记录成功!");
                              model.requestData();
                            }),
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
    );
  }

  Widget infoView(DetailPowerBoxViewModel model) {
    return Container(
      // height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "电源${model.deviceInfo.deviceCode ?? ""}箱信息",
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

}
