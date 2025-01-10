import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/page/home/device_add/widgets/add_ai_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/widgets/add_nvr_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_box_view.dart';
import 'package:omt/page/video/video_frame/video_frame_page.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/device_add_viewmodel.dart';
import '../view_models/third_step_viewmodel.dart';

class ThirdStepView extends StatelessWidget {
  final ThirdStepViewModel model;

  const ThirdStepView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ThirdStepViewModel>(
        model: model
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView(model);
        });
  }

  Widget contentView(ThirdStepViewModel model){
    switch (model.deviceType) {
      case DeviceType.port:
        return Container();
      case DeviceType.ai:
      case DeviceType.camera:
      case DeviceType.nvr:
      case DeviceType.powerBox:
        return AddPowerBoxView(model.deviceType, model.stepNumber);
      case DeviceType.battery:
      case DeviceType.exchange:

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
                  const Text(
                    "第三步：现场网络环境",
                    style: TextStyle(
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
                  ComboBox<IdNameValue>(
                    isExpanded: false,
                    value: model.networkEnvSelected,
                    items: model.networkEnvList.map<ComboBoxItem<IdNameValue>>((e) {
                      return ComboBoxItem<IdNameValue>(
                        value: e,
                        child: SizedBox(
                          width: 300,
                          child: Text(
                            e.name,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (a) {
                      model.networkEnvSelected = a!;
                      model.notifyListeners();
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
}