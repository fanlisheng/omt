import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../theme.dart';
import '../../device_detail/widgets/detail_ai_view.dart';
import '../view_models/add_ai_viewmodel.dart';
import '../view_models/device_add_viewmodel.dart';

class AddAiView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool? isInstall; //是安装 默认否
  const AddAiView(this.deviceType, this.stepNumber,
      {super.key, this.isInstall});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddAiViewModel>(
        model: AddAiViewModel(deviceType, stepNumber, isInstall ?? false)
          ..themeNotifier = true,
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
          color: ColorUtils.colorBackgroundLine,
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
                onTap: () => _showSearchDialog(context, model),
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
            children: model.deviceList.asMap().keys.map((index) {
              DeviceDetailAiData e = model.deviceList[index];
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

  void _showSearchDialog(BuildContext context, AddAiViewModel parentModel) {
    // 创建一个新的 ViewModel 实例
    final dialogModel = AddAiViewModel(
        parentModel.deviceType, parentModel.stepNumber, parentModel.isInstall);
    dialogModel.startSearch();

    ui.showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: false,
      builder: (context) {
        return ProviderWidget<AddAiViewModel>(
            model: dialogModel,
            builder: (context, model, child) {
              return Center(
                child: Container(
                  width: 400,
                  height: 300,
                  decoration: BoxDecoration(
                    color: ColorUtils.colorBackgroundLine,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "搜索AI设备",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorUtils.colorWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Clickable(
                            onTap: () {
                              Navigator.pop(context);
                              dialogModel
                                  .dispose(); // 确保在关闭对话框时 dispose 新的 ViewModel
                            },
                            child: const Icon(
                              FluentIcons.chrome_close,
                              color: ColorUtils.colorWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (model.isSearching) ...[
                        const SizedBox(height: 40),
                        const ui.CircularProgressIndicator(),
                        const SizedBox(height: 24),
                        const Text(
                          "AI设备IP搜索中...",
                          style: TextStyle(
                            color: ColorUtils.colorWhite,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () {
                            model.stopSearch();
                            Navigator.pop(context);
                            dialogModel
                                .dispose(); // 确保在关闭对话框时 dispose 新的 ViewModel
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Colors.red) // 示例：根据条件设置颜色
                              ),
                          child: const Text(
                            "取消搜索",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ] else if (model.searchResults.isEmpty) ...[
                        const Text(
                          "无AI设备",
                          style: TextStyle(
                            color: ColorUtils.colorWhite,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                              onPressed: () => model.startSearch(),
                              child: const Text(
                                "重新搜索",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                dialogModel
                                    .dispose(); // 确保在关闭对话框时 dispose 新的 ViewModel
                              },
                              child: const Text(
                                "返回",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Expanded(
                          child: ListView.builder(
                            itemCount: model.searchResults.length,
                            itemBuilder: (context, index) {
                              final result = model.searchResults[index];
                              return ui.RadioListTile<String>(
                                value: result.ip ?? "",
                                groupValue: model.selectedIp,
                                onChanged: (value) {
                                  model.selectedIp = value;
                                  model.notifyListeners();
                                },
                                title: Text(
                                  result.ip ?? "",
                                  style: const TextStyle(
                                    color: ColorUtils.colorWhite,
                                  ),
                                ),
                                subtitle: Text(
                                  "MAC: ${result.mac}",
                                  style: const TextStyle(
                                    color: ColorUtils.colorGray,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                dialogModel
                                    .dispose(); // 确保在关闭对话框时 dispose 新的 ViewModel
                              },
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.red) // 示例：根据条件设置颜色
                                  ),
                              child: const Text(
                                "返回",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            FilledButton(
                              onPressed: () {
                                if (model.selectedIp != null) {
                                  // 处理选中的IP
                                  parentModel.selectedIp =
                                      model.selectedIp; // 将选中的IP传递给父 ViewModel
                                  parentModel.handleSelectedIp();
                                  Navigator.pop(context);
                                  dialogModel
                                      .dispose(); // 确保在关闭对话框时 dispose 新的 ViewModel
                                }
                              },
                              child: const Text(
                                "确定",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
