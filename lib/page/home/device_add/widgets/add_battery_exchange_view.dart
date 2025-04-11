import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/common/id_name_value.dart';
import '../view_models/add_battery_exchange_viewmodel.dart';

class AddBatteryExchangeView extends StatelessWidget {
  final AddBatteryExchangeViewModel model;

  const AddBatteryExchangeView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddBatteryExchangeViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView(model);
        });
  }

  Column contentView(AddBatteryExchangeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "第${model.isInstall ? "六" : "二"}步：添加${model.isBattery ? "电池" : "交换机"}",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.isInstall && model.isBattery) ...batteryView(model),
              if (model.isInstall && !model.isBattery) ...exchangeView(model),
              if (!model.isInstall && model.isBattery) ...batteryView(model),
              if (!model.isInstall && !model.isBattery) ...exchangeView(model),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> batteryView(AddBatteryExchangeViewModel model) {
    return [
      const SizedBox(height: 10),
      const RowTitle(name: "电池容量"),
      Row(
        children: [
          Radio(
            value: true,
            groupValue: model.isCapacity80,
            activeColor: ColorUtils.colorGreen,
            onChanged: (value) {
              model.isCapacity80 = value as bool;
              model.notifyListeners();
            },
          ),
          Text("80AH",
              style: TextStyle(
                  fontSize: 12,
                  color: model.isCapacity80
                      ? ColorUtils.colorGreen
                      : ColorUtils.colorWhite)),
          const SizedBox(width: 16),
          Radio(
            value: false,
            groupValue: model.isCapacity80,
            activeColor: ColorUtils.colorGreen,
            onChanged: (value) {
              model.isCapacity80 = value as bool;
              model.notifyListeners();
            },
          ),
          Text("160AH",
              style: TextStyle(
                  fontSize: 12,
                  color: model.isCapacity80
                      ? ColorUtils.colorWhite
                      : ColorUtils.colorGreen)),
        ],
      ),
      // const SizedBox(height: 10),
    ];
  }

  List<Widget> exchangeView(AddBatteryExchangeViewModel model) {
    return [
      const SizedBox(height: 20),
      const Row(
        children: [
          Text(
            "*",
            style: TextStyle(
                fontSize: 12,
                color: ColorUtils.colorRed,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 2),
          Text(
            "进/出口",
            style: TextStyle(
                fontSize: 12,
                color: ColorUtils.colorWhite,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(height: 5),
      EquallyRow(
        one: ComboBox<IdNameValue>(
          isExpanded: true,
          value: model.selectedInOut,
          items: model.inOutList.map<ComboBoxItem<IdNameValue>>((e) {
            return ComboBoxItem<IdNameValue>(
              value: e,
              child: SizedBox(
                child: Text(
                  e.name ?? "",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            );
          }).toList(),
          onChanged: (a) {
            model.selectedInOut = a!;
            model.notifyListeners();
          },
          placeholder: const Text(
            "请选择进/出口",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 12, color: ColorUtils.colorBlackLiteLite),
          ),
        ),
        two: Container(),
      ),
      const SizedBox(height: 20),
      const RowTitle(name: "交换机接口数量"),
      EquallyRow(
        one: Wrap(
          spacing: 20.0,
          children: List.generate(
            model.portNumber.length,
            (index) {
              final option = model.portNumber[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: option,
                    groupValue: model.selectedPortNumber,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.selectedPortNumber = value;
                      model.notifyListeners();
                    },
                  ),
                  Text("$option口",
                      style: TextStyle(
                          fontSize: 12,
                          color: model.selectedPortNumber != option
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen)),
                ],
              );
            },
          ),
        ),
        two: Wrap(
          spacing: 20.0,
          children: List.generate(
            model.supplyMethod.length,
            (index) {
              final option = model.supplyMethod[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: option,
                    groupValue: model.selectedSupplyMethod,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.selectedSupplyMethod = value;
                      model.notifyListeners();
                    },
                  ),
                  Text(option,
                      style: TextStyle(
                          fontSize: 12,
                          color: model.selectedSupplyMethod != option
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen)),
                ],
              );
            },
          ),
        ),
      ),
    ];
  }
}
