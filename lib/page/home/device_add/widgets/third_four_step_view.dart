import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/page/home/device_add/view_models/add_camera_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/add_ai_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/page/home/device_add/widgets/add_nvr_view.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/device_add_viewmodel.dart';
import '../view_models/third_step_viewmodel.dart';
import 'add_power_box_view.dart';

class ThirdFourStepView extends StatelessWidget {
  final ThirdFourStepViewModel model;

  const ThirdFourStepView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ThirdFourStepViewModel>(
      model: model..themeNotifier = true,
      autoLoadData: false,
      builder: (context, model1, child) {
        print(
            'ProviderWidget model1: ${model1.stepNumber}, ${model1.deviceType}');
        model1.stepNumber = model.stepNumber;
        return contentView(model1);
      },
    );
  }

  Widget contentView(ThirdFourStepViewModel model) {
    print(
        'contentView : stepNumber = ${model.stepNumber}, deviceType = ${model.deviceType}');
    switch (model.deviceType) {
      case DeviceType.power:
        return Container();
      case DeviceType.ai:
      case DeviceType.camera:
        if (model.stepNumber == StepNumber.third) {
          return AddCameraView(
            deviceType: model.deviceType,
            stepNumber: model.stepNumber,
          );
        } else if (model.stepNumber == StepNumber.four) {
          return fourView(model);
        } else {
          return Container();
        }
      case DeviceType.powerBox:
        return AddPowerBoxView(model.deviceType, model.stepNumber);
      case DeviceType.nvr:
      case DeviceType.battery:
      case DeviceType.exchange:
        return fourView(model);
    }
  }

  Column fourView(ThirdFourStepViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
          color: ColorUtils.colorBackgroundLine,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "第${(model.stepNumber == StepNumber.third) ? "三" : "四"}步：现场网络环境",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text(
                    "*",
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorRed,
                    ),
                  ),
                  SizedBox(width: 2),
                  Text(
                    "现场网络环境",
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ComboBox<String>(
                isExpanded: false,
                value: model.selectedNetworkEnv,
                items: model.networkEnvList.map<ComboBoxItem<String>>((e) {
                  return ComboBoxItem<String>(
                    value: e.name,
                    child: SizedBox(
                      child: Text(
                        e.name,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (a) {
                  // model.selectedNetworkEnv = a!;
                },
                placeholder: const Text(
                  "现场网络环境",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
