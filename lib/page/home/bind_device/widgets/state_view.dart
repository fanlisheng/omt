import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import '../view_models/bind_device_viewmodel.dart';
import 'package:kayo_package/extension/base_string_extension.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:omt/page/user/nav/navi_view_model.dart';
import 'package:omt/utils/color_utils.dart';

class StateView extends StatelessWidget {
  final BindDeviceViewModel viewModel;

  const StateView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    var src = source("home/ic_succeed");
    var text = "正在提交";
    var text1 = "摄像头、实例绑定关系业务平台提交中";
    var text2 = "";
    var textColor = "#42CF93".toColor();
    var text2Color = ColorUtils.colorGreenLiteLite;
    var btnText = "";
    VoidCallback? action;
    if (viewModel.pageState == BindDevicePageState.loading) {
    } else if (viewModel.pageState == BindDevicePageState.success) {
      text = "提交完成";
      // text1 = "摄像头、实例绑定关系业务平台绑定成功\n实例、边缘设备、摄像头、NVR、电源箱绑定关系IOT绑定成功";
      text1 = viewModel.showText;
      src = source("home/ic_succeed");
      btnText = "返回";
      action = () {
        viewModel.goBackEventAction();
        // viewModel.pageState = BindDevicePageState.idle;
        // viewModel.notifyListeners();
      };
    } else if (viewModel.pageState == BindDevicePageState.failure) {
      text = "提交失败";
      // text1 = "摄像头、实例绑定关系业务平台绑定失败";
      // text2 = "实例、边缘设备、摄像头、NVR、电源箱绑定关系IOT更新失败";
      text1 = viewModel.showText;
      textColor = ColorUtils.colorRed;
      // text2Color = ColorUtils.colorRed;
      src = source("home/ic_failure");
      btnText = "手动更新";
      action = () {
        viewModel.handBindingEventAction();
      };
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: btnText.isNotEmpty,
            child: ImageView(
              width: 72,
              height: 72,
              src: src,
            ),
          ),
          Visibility(
            visible: btnText.isEmpty,
            child: ProgressRing(activeColor: textColor),
          ),
          const SizedBox(height: 20),
          // 提交失败标题
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // 提示描述
          Text(
            text1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ColorUtils.colorWhite, fontSize: 12, height: 1.5),
          ),
          // Text(
          //   text2,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: text2Color, fontSize: 12, height: 2),
          // ),
          const SizedBox(height: 20),

          // 手动更新按钮
          Visibility(
            visible: btnText.isNotEmpty,
            child: ElevatedButton(
              onPressed: action,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DD0E1), // 按钮背景颜色
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  color: ColorUtils.colorWhite,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 失败原因
          Visibility(
            visible: viewModel.pageState == BindDevicePageState.failure,
            child: Container(
              height: 86,
              margin: const EdgeInsets.only(left: 100, right: 100),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: "#000000".toColor().withOpacity(0.05),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '失败原因：',
                      style: TextStyle(
                        color: ColorUtils.colorGreenLiteLite.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.error,
                          color: ColorUtils.colorRed,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '请联系后台管理员处理。',
                            style: TextStyle(
                              color: ColorUtils.colorGreenLiteLite
                                  .withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
