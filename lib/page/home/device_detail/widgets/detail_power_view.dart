import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/page/home/device_detail/view_models/device_detail_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/checkbox.dart';

import '../view_models/detail_power_viewmodel.dart';
import 'detail_ai_view.dart';

class DetailPowerView extends StatelessWidget {
  const DetailPowerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailPowerViewModel>(
        model: DetailPowerViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView(model);
        });
  }

  Widget contentView(DetailPowerViewModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 58),
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
              RowItemInfoView(name: "实例", value: model.deviceInfo.instanceName),
              RowItemInfoView(name: "大门编号", value: model.deviceInfo.gateName),
            ],
          ),
          const SizedBox(height: 12),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "进/出口", value: model.deviceInfo.passName),
              RowItemInfoView(name: "标签", value: model.deviceInfo.labelName),
            ],
          ),
          const SizedBox(height: 12),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowItemInfoView(name: "现场接电方式", value: model.deviceInfo.powerType),
              RowItemInfoView(name: "电池容量", value: "${model.deviceInfo.batteryCapacity}"),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
