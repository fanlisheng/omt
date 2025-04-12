import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_ai_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_battery_exchange_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_camera_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_nvr_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_power_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_router_view.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/widget/nav/dnavigation_view.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/device_utils.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../view_models/device_detail_viewmodel.dart';
import 'detail_power_box_view.dart';

class DeviceDetailScreen extends StatelessWidget {
  // final int id;
  // final DeviceType deviceType;
  //
  // const DeviceDetailScreen(
  //     {super.key, required this.id, required this.deviceType});
  final DeviceDetailViewModel viewModel;

  const DeviceDetailScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DeviceDetailViewModel>(
        model: viewModel..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: fu.PageHeader(
                title: DNavigationView(
                  title: DeviceUtils.getDeviceTypeName(model.deviceType),
                  titlePass: "首页 / ",
                  rightWidget: const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  onTap: () {
                    IntentUtils.share.popResultOk(context);
                  },
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(DeviceDetailViewModel model) {
    //如果是电源信息
    // if (model.deviceType == DeviceType.port) {
    //   return portView(model);
    // } else {
    //   return Container();
    // }
    switch (model.deviceType) {
      case DeviceType.ai:
        return DetailAiView(
          nodeId: model.nodeId,
        );
      case DeviceType.camera:
        return DetailCameraView(
          nodeId: model.nodeId,
        );
      case DeviceType.powerBox:
        return DetailPowerBoxView(
          nodeId: model.nodeId,
        );
      case DeviceType.nvr:
        return DetailNvrView(
          nodeId: model.nodeId,
        );
      case DeviceType.power:
        return DetailPowerView(
          nodeId: model.nodeId,
        );
      case DeviceType.battery:
      case DeviceType.exchange:
        return DetailBatteryExchangeView(
          nodeId: model.nodeId,
        );
      case DeviceType.router:
        return DetailRouterView(
          nodeId: model.nodeId,
        );
    }
  }

// Widget portView(DeviceDetailViewModel model) {
//   return Column(
//     spacing: 0,
//     children: [
//       Expanded(
//         child: Container(
//           margin: const EdgeInsets.only(left: 16, right: 16),
//           color: ColorUtils.colorBackgroundLine,
//           child: Column(
//             children: [
//               DetailPowerView(
//                 nodeCode: model.nodeCode,
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomView(model),
//     ],
//   );
// }

// Widget bottomView(DeviceDetailViewModel model) {
//   return Container(
//     margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Clickable(
//           child: Container(
//             padding:
//                 const EdgeInsets.only(left: 25, right: 25, top: 6, bottom: 6),
//             color: ColorUtils.colorGreen,
//             child: const Text(
//               "确定",
//               style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
//             ),
//           ),
//           onTap: () {
//             model.confirmPowerEventAction();
//           },
//         ),
//       ],
//     ),
//   );
// }
}
