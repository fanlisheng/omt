import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ma;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/bind_device/view_models/missing_device_add_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/page/home/device_add/widgets/add_router_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/view_models/add_power_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_router_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';

class MissingDeviceAddScreen extends StatefulWidget {
  final List<String> missingDevices;
  final String pNodeCode;
  final int gateId;
  final String instanceId;

  const MissingDeviceAddScreen({
    super.key,
    required this.missingDevices,
    required this.pNodeCode,
    required this.gateId,
    required this.instanceId,
  });

  @override
  State<MissingDeviceAddScreen> createState() => _MissingDeviceAddScreenState();
}

class _MissingDeviceAddScreenState extends State<MissingDeviceAddScreen> {
  AddPowerViewModel? powerViewModel;
  AddRouterViewModel? routerViewModel;
  AddBatteryExchangeViewModel? exchangeViewModel;

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MissingDeviceAddViewModel>(
      model: MissingDeviceAddViewModel(
        missingDevices: widget.missingDevices,
        pNodeCode: widget.pNodeCode,
        gateId: widget.gateId,
        instanceId: widget.instanceId,
      )..themeNotifier = true,
      autoLoadData: true,
      builder: (context, model, child) {
        // 初始化子ViewModels
        if (model.missingDevices.contains("电源信息") && powerViewModel == null) {
          powerViewModel = AddPowerViewModel(model.pNodeCode, isInstall: false);
        }
        if (model.missingDevices.contains("网络信息") && routerViewModel == null) {
          routerViewModel =
              AddRouterViewModel(model.pNodeCode, isInstall: false);
        }
        if (model.missingDevices.contains("交换机信息") &&
            exchangeViewModel == null) {
          exchangeViewModel = AddBatteryExchangeViewModel(model.pNodeCode,
              isInstall: false, isBattery: false);
        }

        // 将子ViewModels传递给主ViewModel
        model.setPowerViewModel(powerViewModel);
        model.setRouterViewModel(routerViewModel);
        model.setExchangeViewModel(exchangeViewModel);

        return Container(
          color: "#3B3F3F".toColor(),
          child: ScaffoldPage(
            header: PageHeader(
              title: DNavigationView(
                title: "添加设备",
                titlePass: "首页 / 绑定 / ",
                onTap: () {
                  model.goBackEventAction();
                },
              ),
            ),
            content: contentView(model),
          ),
        );
      },
    );
  }

  Widget contentView(MissingDeviceAddViewModel model) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (model.missingDevices.contains("电源信息") &&
                    powerViewModel != null)
                  AddPowerView(
                    model: powerViewModel!,
                  ),
                const ma.SizedBox(
                  height: 20,
                ),
                if (model.missingDevices.contains("网络信息") &&
                    routerViewModel != null)
                  AddRouterView(
                    model: routerViewModel!,
                  ),
                const ma.SizedBox(
                  height: 20,
                ),
                if (model.missingDevices.contains("交换机信息") &&
                    exchangeViewModel != null)
                  AddBatteryExchangeView(
                    model: exchangeViewModel!,
                    title: "添加交换机信息",
                  ),
                const ma.SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        _buildBottomButtons(model),
      ],
    );
  }

  Widget _buildBottomButtons(MissingDeviceAddViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            onPressed: () {
              model.goBackEventAction();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              child: const Text(
                "取消",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorUtils.colorWhite,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          FilledButton(
            onPressed: model.isLoading
                ? null
                : () {
                    model.submitDeviceInfo();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              child: model.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: ProgressRing(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "完成",
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorUtils.colorWhite,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
