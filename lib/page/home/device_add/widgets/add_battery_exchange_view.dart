import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/utils/color_utils.dart';

import '../view_models/add_battery_exchange_viewmodel.dart';
import '../view_models/device_add_viewmodel.dart';

class AddBatteryExchangeView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;

  const AddBatteryExchangeView(this.deviceType, this.stepNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddBatteryExchangeViewModel>(
        model: AddBatteryExchangeViewModel(deviceType, stepNumber)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return batteryView(model);
        });
  }

  Column batteryView(AddBatteryExchangeViewModel model) {
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
                "第二步：添加${model.deviceType == DeviceType.battery
                    ? "电池"
                    : "交换机"}",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.deviceType == DeviceType.battery) ...[
                const SizedBox(height: 10),
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
                      "电池容量",
                      style:
                      TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                    ),
                  ],
                ),
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
                const SizedBox(height: 10),
              ],
              if (model.deviceType == DeviceType.exchange) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorRed),
                          ),
                          SizedBox(width: 2),
                          Text(
                            "电池容量",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorWhite),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorRed),
                          ),
                          SizedBox(width: 2),
                          Text(
                            "交换机供电方式",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorWhite),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Wrap(
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
                                Text(option,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: model.selectedPortNumber !=
                                            option
                                            ? ColorUtils.colorWhite
                                            : ColorUtils.colorGreen)),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Wrap(
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
                                        color:
                                        model.selectedSupplyMethod != option
                                            ? ColorUtils.colorWhite
                                            : ColorUtils.colorGreen)),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

}
