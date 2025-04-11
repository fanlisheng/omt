import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/page/home/device_detail/view_models/device_detail_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/checkbox.dart';

import '../view_models/detail_Router_viewmodel.dart';
import '../view_models/detail_router_viewmodel.dart';
import 'detail_ai_view.dart';

class DetailRouterView extends StatelessWidget {
  final String nodeCode;

  const DetailRouterView({super.key, required this.nodeCode});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailRouterViewModel>(
        model: DetailRouterViewModel(nodeCode)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView(model);
        });
  }

  Column contentView(DetailRouterViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "电源信息",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "实例", value: model.deviceInfo.instanceName),
                  RowItemInfoView(
                      name: "大门编号", value: model.deviceInfo.gateName),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "进/出口", value: model.deviceInfo.passName),
                  RowItemInfoView(name: "IP", value: model.deviceInfo.ip),
                ],
              ),
              const SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     RowItemInfoView(name: "现场接电方式", value: model.deviceInfo.RouterType),
              //     const RowItemInfoView(name: "", value: ""),
              //   ],
              // ),
              // const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
