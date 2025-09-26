import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:kayo_package/views/widget/base/image_view.dart';
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
    // 使用ChangeNotifierProvider.value来监听状态变化，但不管理生命周期
    return ChangeNotifierProvider<AddAiViewModel>.value(
      value: model,
      child: Consumer<AddAiViewModel>(
        builder: (context, model, child) {
          return aiView(model, context);
        },
      ),
    );
  }

  Column aiView(AddAiViewModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: model.aiDeviceList.asMap().keys.map((index) {
              DeviceDetailAiData e = model.aiDeviceList[index];
              return Container(
                height: (e.mac ?? "").isEmpty
                    ? 120
                    : ((e.enabled == true) ? 285 : 155),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: ColorUtils.colorBackgroundLine,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Row(
                        children: [
                          Text(
                            index == 0 ? "第二步：添加AI设备" : "继续添加AI设备$index",
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorUtils.colorGreenLiteLite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const ui.SizedBox(width: 10),
                          Clickable(
                            onTap: (e.enabled ?? true)
                                ? () {
                                    model.selectedAiIp = null;
                                    model.startAiSearch(index);
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (e.enabled ?? true)
                                      ? AppTheme().color
                                      : AppTheme().color.darker,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: ((e.enabled ?? true)
                                        ? AppTheme().color
                                        : AppTheme().color.darker)
                                    .withOpacity(0.2),
                              ),
                              child: Text(
                                "快速搜索IP",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (e.enabled ?? true)
                                      ? AppTheme().color
                                      : AppTheme().color.darker,
                                ),
                              ),
                            ),
                          ),
                          ui.Expanded(child: ui.Container()),
                          if (model.aiDeviceList.length > 1) ...[
                            Button(
                              onPressed: () {
                                model.deleteAiAction(index);
                              },
                              child: Row(
                                children: [
                                  ImageView(
                                    src: source(
                                      "home/ic_camera_delete",
                                    ),
                                    width: 10,
                                    height: 18,
                                    color: ColorUtils.colorRed,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    "删除设备",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorRed,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                            (e.end ?? false) ? "已添加" : "已连接客户端",
                            style: TextStyle(
                              fontSize: 12,
                              color: (e.end ?? false)
                                  ? "#F9871E".toColor()
                                  : "21E793".toColor(),
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
                            enabled: e.enabled ?? true,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Button(
                          onPressed: (e.enabled ?? true)
                              ? () {
                                  model.connectAiDeviceAction(index);
                                }
                              : null,
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  (e.enabled ?? true)
                                      ? AppTheme().color
                                      : Colors.teal.darkest)),
                          child: const Text(
                            "连接",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorWhite),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (e.mac ?? "").isNotEmpty,
                      child: (e.enabled == true)
                          ? Expanded(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RowItemInfoView(
                                          name: "主程版本",
                                          value: e.programVersion),
                                      RowItemInfoView(
                                          name: "识别版本",
                                          value: e.identityVersion),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RowItemInfoView(
                                          name: "服务器地址", value: e.serverHost),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                Clickable(
                                  onTap: () {
                                    e.enabled = !(e.enabled ?? false);
                                    model.notifyListeners();
                                  },
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(top: 8),
                                  child: const Text(
                                    "展开详情",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorGreenLiteLite),
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (model.isInstall == true) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 16),
              Clickable(
                child: Text(
                  "+继续添加",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme().color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  model.addAiAction();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ]
      ],
    );
  }
}
