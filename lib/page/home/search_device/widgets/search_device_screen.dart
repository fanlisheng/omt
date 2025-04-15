import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:omt/page/home/search_device/widgets/filter_view.dart';
import 'package:omt/page/home/search_device/widgets/device_list_view.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/lib/tfb_spinner.dart';
import 'dart:math';
import '../../../../bean/home/home_page/device_unbound_entity.dart';
import '../services/device_search_service.dart';
import '../view_models/search_device_viewmodel.dart';

class SearchDeviceScreen extends StatelessWidget {
  const SearchDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchDeviceViewModel>(
        model: SearchDeviceViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              padding: const EdgeInsets.only(top: 12, bottom: 0),
              header: fu.PageHeader(
                title: TextView(
                  '首页',
                  size: 12,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.colorBlack,
                ),
              ),
              content: Column(
                spacing: 0,
                children: [
                  // 顶部选择器部分
                  FilterView(viewModel: model),
                  // 中间扫描按钮部分
                  Expanded(
                    child: DeviceListView(viewModel: model),
                  ),
                  // 底部统计栏部分
                  Container(
                    height: 40,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 15),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: buildDeviceStatistics(
                              statistics: model.deviceStatistics),
                          // child: Text(
                          //   model.deviceStatistics,
                          //   style: const TextStyle(
                          //     color: ColorUtils.colorGreen,
                          //     fontSize: 12,
                          //   ),
                          //   maxLines: 2,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
