import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/device_add/widgets/add_ai_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/page/home/device_add/widgets/add_nvr_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_box_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/page/home/device_add/widgets/add_router_view.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/device_add_viewmodel.dart';

class DeviceAddScreen extends StatelessWidget {
  // 父节点code
  final String pNodeCode;

  const DeviceAddScreen({super.key, required this.pNodeCode});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DeviceAddViewModel>(
        model: DeviceAddViewModel(pNodeCode)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          bool complete =
              (model.stepNumber == StepNumber.second &&
                  model.deviceType != DeviceType.ai &&
                  model.deviceType != DeviceType.camera) ||
                  (model.stepNumber == StepNumber.third);
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
    switch (model.stepNumber) {
      case StepNumber.first:
        return firstStepView(model);
      case StepNumber.second:
        return secondStepView(model);
      case StepNumber.third:
      case StepNumber.four:
        return thirdFourStepView(model);
      default:
        return firstStepView(model);
    }
    //如果是电源信息
    // if (model.deviceType == DeviceType.power) {
    //   return portView(model);
    // } else {
    //
    // }
  }

  // 第一步视图
  Widget firstStepView(DeviceAddViewModel model) {
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
                "第一步：选择设备",
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
                    "设备类型",
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
                value: model.deviceTypeSelected,
                items: model.deviceTypes.map<ComboBoxItem<IdNameValue>>((e) {
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
                  model.selectedDeviceType(a);
                  model.deviceTypeSelected = a!;
                  model.notifyListeners();
                },
                placeholder: const Text(
                  "请选择设备类型",
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

  // 第二步视图
  Widget secondStepView(DeviceAddViewModel model) {
    switch (model.deviceType) {
      case DeviceType.ai:
      case DeviceType.camera:
        return AddAiView(model: model);
      case DeviceType.nvr:
        return AddNvrView(model: model);
      case DeviceType.powerBox:
        return AddPowerBoxView(model: model);
      case DeviceType.power:
        return AddPowerView(model: model);
      case DeviceType.exchange:
        return AddBatteryExchangeView(model: model);
      case DeviceType.router:
        return AddRouterView(model: model);
      default:
        return Container();
    }
  }

  // 第三、四步视图
  Widget thirdFourStepView(DeviceAddViewModel model) {
    switch (model.deviceType) {
      case DeviceType.power:
        return Container();
      case DeviceType.ai:
      case DeviceType.camera:
        if (model.stepNumber == StepNumber.third) {
          return AddCameraView(model: model);
        } else if (model.stepNumber == StepNumber.four) {
          return fourView(model);
        } else {
          return Container();
        }
      case DeviceType.powerBox:
        return AddPowerBoxView(model: model);
      case DeviceType.nvr:
      case DeviceType.battery:
      case DeviceType.exchange:
        return fourView(model);
      default:
        return Container();
    }
  }

  // 第四步视图
  Column fourView(DeviceAddViewModel model) {
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
                        e.name ?? "",
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (a) {
                  model.selectedNetworkEnv = a!;
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
                AddPowerView(model: model),
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
