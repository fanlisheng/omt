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
import '../view_models/edit_power_box_viewmodel.dart';

class EditPowerBoxView extends StatelessWidget {
  final EditPowerBoxViewModel model;

  const EditPowerBoxView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditPowerBoxViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return powerBoxView(model);
        });
  }

  Widget powerBoxView(EditPowerBoxViewModel model) {
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              ColorUtils.colorBackgroundLine.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          model.selectedDeviceDetailPowerBox?.deviceCode ??
                              "未选择",
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                          ),
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
        ],
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    "保存",
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
        ),
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
