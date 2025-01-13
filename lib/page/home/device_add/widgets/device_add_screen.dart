import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/device_add/view_models/third_step_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/page/home/device_add/widgets/first_step_view.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/page/home/device_add/widgets/third_four_step_view.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/device_add_viewmodel.dart';
import '../view_models/second_step_viewmodel.dart';

class DeviceAddScreen extends StatelessWidget {
  final int id;
  final DeviceType deviceType;

  const DeviceAddScreen(
      {super.key, required this.id, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DeviceAddViewModel>(
        model: DeviceAddViewModel(id, deviceType)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          bool complete = //步骤四，步骤三中 ai和 camera 为完成
              !(model.stepNumber != StepNumber.four ||
                  (model.stepNumber == StepNumber.third &&
                      model.deviceType == DeviceType.ai) ||
                  (model.stepNumber == StepNumber.third &&
                      model.deviceType == DeviceType.camera));
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: fu.PageHeader(
                title: DNavigationView(
                  title: "电源",
                  titlePass: "首页 / ",
                  rightWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: model.stepNumber != StepNumber.first,
                          child: Clickable(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 4, bottom: 4),
                              color: ColorUtils.colorGreen,
                              child: const Text(
                                "上一步",
                                style: TextStyle(
                                    fontSize: 12, color: ColorUtils.colorWhite),
                              ),
                            ),
                            onTap: () {
                              model.backStepEventAction();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Clickable(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 4, bottom: 4),
                            color: ColorUtils.colorGreen,
                            child: Text(
                              complete ? "添加完成" : "下一步",
                              style: const TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ),
                          onTap: () {
                            model.nextStepEventAction();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(DeviceAddViewModel model) {
    //如果是电源信息
    if (model.deviceType == DeviceType.port) {
      return portView(model);
    } else {
      switch (model.stepNumber) {
        case StepNumber.first:
          return FirstStepView(model: model);
        case StepNumber.second:
          return SecondStepView(
              model: SecondStepViewModel()..deviceType = model.deviceType);
        case StepNumber.third:
          var a = ThirdFourStepViewModel(deviceType: model.deviceType, stepNumber: model.stepNumber);
          return ThirdFourStepView(model: a,);
        case StepNumber.four:
          var a = ThirdFourStepViewModel(deviceType: model.deviceType, stepNumber: model.stepNumber);
          return ThirdFourStepView(model: a,);
      }
      return FirstStepView(model: model);
    }

    // switch (model.deviceType){
    //   case  DeviceType.port:
    //   case  DeviceType.ai:
    //   case  DeviceType.nvr:
    //   case  DeviceType.powerBox:
    //   case  DeviceType.battery:
    //   case  DeviceType.exchange:
    // }
  }

  Widget portView(DeviceAddViewModel model) {
    return Column(
      spacing: 0,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            color: ColorUtils.colorBackgroundLine,
            child: Column(
              children: [
                AddPowerView(viewModel: model),
              ],
            ),
          ),
        ),
        bottomView(model),
      ],
    );
  }

  Widget bottomView(DeviceAddViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Clickable(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 6, bottom: 6),
              color: ColorUtils.colorGreen,
              child: const Text(
                "确定",
                style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
              ),
            ),
            onTap: () {
              model.confirmPowerEventAction();
            },
          ),
        ],
      ),
    );
  }
}
