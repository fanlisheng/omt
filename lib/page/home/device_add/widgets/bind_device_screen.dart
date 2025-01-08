import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:kayo_package/views/widget/base/text_view.dart';
import 'package:omt/page/home/bind_device/widgets/device_list_view.dart';
import 'package:omt/page/home/bind_device/widgets/gate_selected_view.dart';
import 'package:omt/page/home/bind_device/widgets/state_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../bean/home/home_page/local_device_entity.dart';
import '../../../../utils/color_utils.dart';
import '../../search_device/widgets/filter_view.dart';
import '../view_models/bind_device_viewmodel.dart';

class DeviceAddScreen extends StatelessWidget {
  final int id;
  final int deviceType;

  const DeviceAddScreen(
      {super.key, required this.id, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DeviceAddViewModel>(
        model: DeviceAddViewModel(id, deviceType)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: DNavigationView(
                  title: "电源",
                  titlePass: "首页 / ",
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(DeviceAddViewModel model) {
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
