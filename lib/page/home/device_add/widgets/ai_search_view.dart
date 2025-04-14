import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/utils/color_utils.dart'; // 假设 ColorUtils 在这里定义
import '../view_models/ai_search_viewmodel.dart';
import "package:provider/provider.dart" show Consumer, Provider;

Future<String?> showAiSearchDialog(BuildContext context) {


  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    barrierDismissible: false,
    builder: (context) {
      return const AiSearchDialog();
    },
  );
}

class AiSearchDialog extends StatelessWidget {
  const AiSearchDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AiSearchViewModel>(
        model: AiSearchViewModel()..themeNotifier = true,
        autoLoadData: true,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
                  if (model.isAiSearching) ...[
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
                        model.stopAiSearch();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      child: const Text(
                        "取消搜索",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ] else if (model.aiSearchResults.isEmpty) ...[
                    const Text(
                      "无AI设备",
                      style: TextStyle(
                        color: ColorUtils.colorWhite,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () => model.startAiSearch(),
                          child: const Text(
                            "重新搜索",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
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
                        itemCount: model.aiSearchResults.length,
                        itemBuilder: (context, index) {
                          final result = model.aiSearchResults[index];
                          return ui.RadioListTile<String>(
                            value: result.ip ?? "",
                            groupValue: model.selectedAiIp,
                            onChanged: (value) {
                              model.selectedAiIp = value;
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
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.red),
                          ),
                          child: const Text(
                            "返回",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton(
                          onPressed: () {
                            if (model.selectedAiIp != null) {
                              Navigator.pop(context, model.selectedAiIp);
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
  }
}
