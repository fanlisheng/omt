import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/page/one_picture/one_picture/one_picture_page.dart';
import 'package:provider/provider.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../view_models/install_device_viewmodel.dart';
import '../view_models/preview_viewmodel.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取InstallDeviceViewModel的实例
    final installDeviceViewModel =
        Provider.of<InstallDeviceViewModel>(context, listen: false);

    return ProviderWidget<PreviewViewModel>(
        model: installDeviceViewModel.previewViewModel,
        // 使用来自InstallDeviceViewModel的PreviewViewModel
        autoLoadData: true,
        builder: (context, model, child) {
          return model.onePictureDataData != null
              ? OnePicturePage()
              : const Center(child: fu.ProgressRing());
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
