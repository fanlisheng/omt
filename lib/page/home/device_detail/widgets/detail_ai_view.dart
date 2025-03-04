import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../../bean/home/home_page/device_entity.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../view_models/detail_ai_viewmodel.dart';

class DetailAiView extends StatelessWidget {
  final String nodeCode;

  const DetailAiView({
    super.key,
    required this.nodeCode,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailAiViewModel>(
        model: DetailAiViewModel(nodeCode)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return aiView(model);
        });
  }

  Widget aiView(DetailAiViewModel model) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AI设备信息",
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
                  RowItemInfoView(
                      name: "标签", value: model.deviceInfo.labelName),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "AI设备编码", value: model.deviceInfo.deviceCode),
                  RowItemInfoView(name: "IP地址", value: model.deviceInfo.ip),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                    name: "主程版本",
                    value: model.deviceInfo.programVersion,
                    // buttonName: "升级",
                    // buttonAction: () {
                    //   LogUtils.info(msg: "点击--主程版本-升级");
                    // },
                  ),
                  RowItemInfoView(
                    name: "识别版本",
                    value: model.deviceInfo.identityVersion,
                    // buttonName: "升级",
                    // buttonAction: () {
                    //   LogUtils.info(msg: "点击--识别版本-升级");
                    // },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "摄像头编码", value: model.deviceInfo.cameraDeviceCode),
                  RowItemInfoView(
                    name: "IOT连接状态",
                    value: model.deviceInfo.iotConnectStatus,
                    hasState: true,
                    stateColor: model.deviceInfo.iotConnectStatus == "连接成功"
                        ? ColorUtils.colorGreen
                        : ColorUtils.colorRed,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            // Clickable(
            //   onTap: () {},
            //   child: Container(
            //     padding: const EdgeInsets.only(
            //         left: 25, right: 25, top: 6, bottom: 6),
            //     color: ColorUtils.colorGreen,
            //     child: const Text(
            //       "重启主程",
            //       style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
            //     ),
            //   ),
            // ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class RowItemInfoView extends StatelessWidget {
  const RowItemInfoView({
    super.key,
    required this.name,
    this.value,
    this.hasState,
    this.stateColor,
    this.buttonName,
    this.buttonAction,
  });

  final String name;
  final String? value;
  final bool? hasState; //如果有状态
  final Color? stateColor;
  final String? buttonName;
  final Function()? buttonAction;

  @override
  Widget build(BuildContext context) {
    String a = "";
    if (name.isNotEmpty) {
      a = ((value ?? "").isNotEmpty) ? value ?? "-" : "-";
    }
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 102,
            child: Text(
              name,
              style: TextStyle(color: "A7C3C2".toColor(), fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Visibility(
            visible: hasState ?? false,
            child: Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5,top: 6),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  color: stateColor ?? ColorUtils.colorRed),
            ),
          ),
          Flexible(
            child: Text(
              a,
              style: const TextStyle(
                color: ColorUtils.colorGreenLiteLite,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis, // 长文本截断显示省略号
              maxLines: 2, // 限制单行
            ),
          ),
          if ((buttonName ?? "").isNotEmpty) ...[
            const SizedBox(width: 12),
            Clickable(
              onTap: buttonAction,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 2, bottom: 2),
                color: ColorUtils.colorGreen,
                child: Text(
                  buttonName ?? "",
                  style: const TextStyle(
                      fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
