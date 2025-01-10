import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:omt/page/home/device_add/widgets/add_ai_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/widgets/add_nvr_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_box_view.dart';
import '../view_models/device_add_viewmodel.dart';
import '../view_models/second_step_viewmodel.dart';

class SecondStepView extends StatelessWidget {
  final SecondStepViewModel model;

  const SecondStepView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    switch (model.deviceType) {
      case DeviceType.port:
        return Container();
      case DeviceType.ai:
        return AddAiView(model.deviceType, model.stepNumber);
      case DeviceType.nvr:
        return AddNvrView(model.deviceType, model.stepNumber);
      case DeviceType.powerBox:
        return AddPowerBoxView(model.deviceType, model.stepNumber);
      case DeviceType.battery:
      case DeviceType.exchange:
        return AddBatteryExchangeView(model.deviceType, model.stepNumber);
      case DeviceType.camera:
    }
    return Container();
  }
}
