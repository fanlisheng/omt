import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/page/one_picture/one_picture/one_picture_page.dart';
import 'package:provider/provider.dart';
import '../../../utils/color_utils.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../view_models/install_device_viewmodel.dart';
import '../view_models/preview_viewmodel.dart';

class PreviewPage extends StatelessWidget {
  final PreviewViewModel model;

  PreviewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // 获取InstallDeviceViewModel的实例
    // final installDeviceViewModel =
    //     Provider.of<InstallDeviceViewModel>(context, listen: false);

    return ProviderWidget<PreviewViewModel>(
        model: model,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView();
          // : const Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         fu.ProgressRing(),
          //         SizedBox(height: 20),
          //         Text(
          //           "正在生成预览数据，请稍候...",
          //           style: TextStyle(
          //             color: ColorUtils.colorGreenLiteLite,
          //             fontSize: 16,
          //           ),
          //         ),
          //         SizedBox(height: 20),
          //         // fu.FilledButton(
          //         //   child: const Text("重新生成预览"),
          //         //   onPressed: () {
          //         //     // 使用公开方法重新生成预览数据
          //         //     installDeviceViewModel.rebuildPreviewData();
          //         //   },
          //         // ),
          //       ],
          //     ),
          //   );
        });
  }

  Widget contentView() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: ColorUtils.colorBackgroundLine,
              borderRadius: BorderRadius.circular(3),
            ),
            width: double.infinity,
            child: OnePicturePage(
                key: model.picturePageKey,
                onePictureHttpData: model.onePictureDataData),
          ),
        ),
        const fu.SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF4E5353),
            borderRadius: BorderRadius.circular(3),
          ),
          // 深灰色背景
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text(
                '设备统计：',
                style: TextStyle(color: fu.Colors.white),
              ),
              Expanded(
                child: buildDeviceStatistics(
                    statistics: model.getDeviceStatistics()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildDeviceStatistics({
    required String statistics,
  }) {
    // 解析 statistics 字符串，拆分为设备统计项
    final stats = statistics.split(' / ').map((item) {
      final parts = item.trim().split('（');
      final nameCount = parts[0].trim();
      final abnormal = parts.length > 1 ? parts[1].replaceAll('）', '') : '';
      return {
        'nameCount': nameCount,
        'abnormal': abnormal,
      };
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...stats.asMap().entries.map((entry) {
          final stat = entry.value;
          final isLast = entry.key == stats.length - 1;
          return RichText(
            maxLines: 2, // 最多 2 行
            text: TextSpan(
              children: [
                TextSpan(
                  text: stat['nameCount'],
                  style: TextStyle(
                    fontSize: 12,
                    color: (stat['abnormal']?.isNotEmpty ?? false)
                        ? ColorUtils.colorRed
                        : ColorUtils.colorGreen,
                  ),
                ),
                if (stat['abnormal']?.isNotEmpty ?? false)
                  TextSpan(
                    text: '（${stat['abnormal']}）',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorRed,
                    ),
                  ),
                if (!isLast)
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorGreen,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
