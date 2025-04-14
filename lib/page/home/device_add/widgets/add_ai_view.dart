import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../theme.dart';
import '../../../../utils/device_utils.dart';
import '../../device_detail/widgets/detail_ai_view.dart';
import '../view_models/add_ai_viewmodel.dart';
import 'ai_search_view.dart';
import 'package:provider/provider.dart';

class AddAiView extends StatelessWidget {
  final AddAiViewModel model;

  const AddAiView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddAiViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return aiView(model, context);
        });
  }

  Column aiView(AddAiViewModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Row(
            children: [
              const Text(
                "第二步：添加AI设备",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const ui.SizedBox(width: 10),
              Clickable(
                onTap: () {
                  model.selectedAiIp = null;
                  model.startAiSearch();
                  // model.selectedAiIp = null;
                  // showAiSearchDialog(context).then((ip) {
                  //   model.selectedAiIp = ip;
                  //   model.handleSelectedAiIp();
                  // });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme().color,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme().color.withOpacity(0.2),
                  ),
                  child: Text(
                    "快速搜索IP",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme().color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: model.aiDeviceList.asMap().keys.map((index) {
              DeviceDetailAiData e = model.aiDeviceList[index];
              return Container(
                height: (e.mac ?? "").isEmpty ? 140 : 278,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: ColorUtils.colorBackgroundLine,
                  borderRadius: BorderRadius.circular(3),
                ),
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
                            controller: model.aiControllers[index],
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
                            decoration: BoxDecoration(
                              color: ColorUtils.colorGreen,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              "连接",
                              style: TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ),
                          onTap: () {
                            model.connectAiDeviceAction(index);
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
                                  name: "IOT连接状态",
                                  value: e.iotConnectStatus,
                                  hasState: true,
                                  stateColor: e.iotConnectStatus == "连接成功"
                                      ? ColorUtils.colorGreen
                                      : ColorUtils.colorRed,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RowItemInfoView(
                                    name: "主程版本", value: e.programVersion),
                                RowItemInfoView(
                                    name: "识别版本", value: e.identityVersion),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RowItemInfoView(
                                    name: "服务器地址", value: e.serverHost),
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
