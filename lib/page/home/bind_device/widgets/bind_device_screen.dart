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
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../utils/color_utils.dart';
import '../../search_device/widgets/filter_view.dart';
import '../view_models/bind_device_viewmodel.dart';

class BindDeviceScreen extends StatelessWidget {
  final List<DeviceEntity> deviceData;
  final StrIdNameValue instance;
  final List<IdNameValue> doorList;

  const BindDeviceScreen(
      {super.key,
      required this.deviceData,
      required this.instance,
      required this.doorList});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BindDeviceViewModel>(
        model: BindDeviceViewModel(deviceData, instance, doorList)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: fu.PageHeader(
                title: DNavigationView(
                  title: "绑定",
                  titlePass: "首页 / ",
                  onTap: () {
                    model.goBackEventAction();
                  },
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(BindDeviceViewModel model) {
    switch (model.pageState) {
      case BindDevicePageState.idle:
        return Column(
          spacing: 0,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: ColorUtils.colorBackgroundLine,
                borderRadius: BorderRadius.circular(3),
              ),
              // height: 400,
              child: Column(
                crossAxisAlignment: fu.CrossAxisAlignment.start,
                children: [
                  const fu.SizedBox(height: 16),
                  Padding(
                    padding: const fu.EdgeInsets.only(left: 20),
                    child: fu.Text(
                      model.instance.name ?? "",
                      style: const fu.TextStyle(
                          fontSize: 14, color: ColorUtils.colorGreenLiteLite),
                    ),
                  ),
                  //设备视频
                  DeviceListView(viewModel: model),
                  // 选择大门视图
                  GateSelectedView(viewModel: model),
                  Expanded(child: Container()),
                ],
              ),
            )),
            bottomView(model),
          ],
        );
      case BindDevicePageState.loading:
      case BindDevicePageState.success:
      case BindDevicePageState.failure:
        return StateView(
          viewModel: model,
        );
    }
  }

  Widget bottomView(BindDeviceViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "已选设备：${model.selectedCount}",
            style: const TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
          ),
          Expanded(child: Container()),
          Clickable(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: ColorUtils.colorGreen,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                "绑定",
                style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
              ),
            ),
            onTap: () {
              model.bingingEventAction();
            },
          ),
          Expanded(child: Container()),
          Container(width: 60),
        ],
      ),
    );
  }
}
