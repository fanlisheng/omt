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
                    color: const Color(0xFF4E5353), // 深灰色背景
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Text(
                          '设备统计：',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          model.deviceStatistics,
                          style: const TextStyle(
                            color: ColorUtils.colorGreen,
                          ),
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
}
