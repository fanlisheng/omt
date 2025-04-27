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
          return model.onePictureDataData != null
              ? OnePicturePage(
                  key: model.picturePageKey,
                  onePictureHttpData: model.onePictureDataData)
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fu.ProgressRing(),
                      SizedBox(height: 20),
                      Text(
                        "正在生成预览数据，请稍候...",
                        style: TextStyle(
                          color: ColorUtils.colorGreenLiteLite,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      // fu.FilledButton(
                      //   child: const Text("重新生成预览"),
                      //   onPressed: () {
                      //     // 使用公开方法重新生成预览数据
                      //     installDeviceViewModel.rebuildPreviewData();
                      //   },
                      // ),
                    ],
                  ),
                );
        });
  }

  // 显示JSON数据的对话框
  void _showJsonDialog(BuildContext context, PreviewViewModel model) {
    // final jsonString = model.getJsonString();
    // if (jsonString != null) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => fu.ContentDialog(
    //       title: const Text("预览JSON数据"),
    //       content: SizedBox(
    //         width: double.maxFinite,
    //         height: 400,
    //         child: SingleChildScrollView(
    //           child: SelectableText(jsonString),
    //         ),
    //       ),
    //       actions: [
    //         fu.Button(
    //           child: const Text("关闭"),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }
}
