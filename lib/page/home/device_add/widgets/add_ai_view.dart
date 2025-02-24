import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_entity.dart';
import '../../device_detail/widgets/detail_ai_view.dart';
import '../view_models/add_ai_viewmodel.dart';
import '../view_models/device_add_viewmodel.dart';

class AddAiView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool? isInstall; //是安装 默认否
  const AddAiView(this.deviceType, this.stepNumber, {super.key, this.isInstall});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddAiViewModel>(
        model: AddAiViewModel(deviceType, stepNumber,isInstall ?? false)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return aiView(model);
        });
  }

  Column aiView(AddAiViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: const Text(
            "第二步：添加AI设备",
            style: TextStyle(
              fontSize: 14,
              color: ColorUtils.colorGreenLiteLite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: model.deviceList.asMap().keys.map((index) {
              DeviceEntity e = model.deviceList[index];
              return Container(
                height: (e.mac ?? "").isEmpty ? 140 : 278,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                color: ColorUtils.colorBackgroundLine,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "设备${index + 1}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorUtils.colorGreenLiteLite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          "*",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorRed,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          "AI设备IP地址",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                          ),
                        ),
                        const SizedBox(width: 130),
                        Visibility(
                          visible: (e.mac ?? "").isNotEmpty,
                          child: Text(
                            "已连接客户端",
                            style: TextStyle(
                              fontSize: 12,
                              color: "21E793".toColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SizedBox(
                          width: 280,
                          height: 32,
                          child: TextBox(
                            placeholder: '请输入AI设备IP地址',
                            controller: model.controllers[index],
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Clickable(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 6, bottom: 6),
                            color: ColorUtils.colorGreen,
                            child: const Text(
                              "连接",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ),
                          onTap: () {
                            model.connectEventAction(index);
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (e.mac ?? "").isNotEmpty,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            DashLine(
                                height: 1,
                                width: double.infinity,
                                color: "#678384".toColor(),
                                gap: 3),
                            const SizedBox(height: 20),
                            const Text(
                              "AI设备信息",
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorGreenLiteLite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RowItemInfoView(
                                    name: "编码（mac地址）", value: e.mac),
                                RowItemInfoView(
                                    name: "IOT连接状态", value: e.mac),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RowItemInfoView(
                                    name: "主程版本", value: e.mac),
                                RowItemInfoView(
                                    name: "识别版本", value: e.mac),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RowItemInfoView(
                                    name: "服务器地址", value: e.mac),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// class RowItemInfoView extends StatelessWidget {
//   const RowItemInfoView({
//     super.key,
//     required this.name,
//     this.value,
//   });
//
//   final String name;
//   final String? value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: Row(
//         children: [
//           Text(
//             name,
//             style: TextStyle(color: "A7C3C2".toColor(), fontSize: 12),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value ?? "无",
//             style: const TextStyle(
//                 color: ColorUtils.colorGreenLiteLite, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
