import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_sys_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/common/name_value.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/page/home/device_add/view_models/add_camera_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/page/home/device_detail/widgets/detail_ai_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../router_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../utils/log_utils.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';
import '../view_models/detail_camera_viewmodel.dart';

class DetailCameraView extends StatelessWidget {
  final String nodeCode;

  const DetailCameraView({super.key, required this.nodeCode});

  // final AddCameraViewModel model;
  // const AddCameraView(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DetailCameraViewModel>(
        model: DetailCameraViewModel(nodeCode)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return cameraView(context, model);
        });
  }

  Column cameraView(BuildContext context, DetailCameraViewModel model) {
    var windowWidth = BaseSysUtils.getWidth(context);
    var row = windowWidth > 600 * 2 + 200;
    var showDraw = windowWidth > 600 + 200;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          color: ColorUtils.colorBackgroundLine,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 576,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "摄像头信息",
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorUtils.colorGreenLiteLite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                  border: Border.all(
                                    width: 1,
                                    color: (getException(0).valueColor ?? "")
                                        .toColor(),
                                  ),
                                  color: (getException(0).valueColor ?? "")
                                      .toColor()
                                      .withOpacity(0.1)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              child: Text(
                                getException(0).value ?? "",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: (getException(0).valueColor ?? "")
                                      .toColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "这里显示设备名称",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorGreenLiteLite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _videoView(model),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 234,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        CupertinoSegmentedControl(
                          //子标签
                          children: <int, Widget>{
                            0: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                "背景照片",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: model.photoCurrentIndex == 0
                                      ? ColorUtils.colorWhite
                                      : "#A7C3C2".toColor(),
                                ),
                              ),
                            ),
                            1: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                "抓拍照片",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: model.photoCurrentIndex == 1
                                      ? ColorUtils.colorWhite
                                      : "#A7C3C2".toColor(),
                                ),
                              ),
                            ),
                          },
                          //当前选中的索引
                          groupValue: model.photoCurrentIndex,
                          //点击回调
                          onValueChanged: (int index) {
                            model.photoCurrentIndex = index;
                            model.notifyListeners();
                          },
                          //选中的背景颜色
                          selectedColor: ColorUtils.colorGreen,
                          //未选中的背景颜色
                          unselectedColor: ColorUtils.transparent,
                          //边框颜色
                          borderColor: "#678384".toColor(),
                          //按下的颜色
                          pressedColor: ColorUtils.colorGreen.withOpacity(0.4),
                        ),
                        if (model.photoCurrentIndex == 0 &&
                            (model.deviceInfo.lastBgPhotos ?? [])
                                .isNotEmpty) ...[
                          const SizedBox(height: 22),
                          ...model.deviceInfo.lastBgPhotos!
                              .where((photo) =>
                                  photo.url != null &&
                                  photo.url!.isNotEmpty) // 过滤掉 url 为空的项
                              .take(2) // 只取前两个
                              .expand((photo) => [
                                    imageTimeView(model.context!, photo.url!,
                                        photo.snapAt ?? ""),
                                    const SizedBox(height: 10),
                                  ]),
                        ] else if (model.photoCurrentIndex == 1 &&
                            (model.deviceInfo.lastSnapPhotos ?? [])
                                .isNotEmpty) ...[
                          const SizedBox(height: 22),
                          ...model.deviceInfo.lastSnapPhotos!
                              .where((photo) =>
                                  photo.url != null &&
                                  photo.url!.isNotEmpty) // 过滤掉 url 为空的项
                              .take(2) // 只取前两个
                              .expand((photo) => [
                                    imageTimeView(model.context!, photo.url!,
                                        photo.snapAt ?? ""),
                                    const SizedBox(height: 10),
                                  ]),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "实例", value: model.deviceInfo.instanceName),
                  RowItemInfoView(
                      name: "大门编号", value: model.deviceInfo.gateName),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "进/出口", value: model.deviceInfo.passName),
                  RowItemInfoView(
                      name: "标签", value: model.deviceInfo.labelName),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "设备编码", value: model.deviceInfo.deviceCode),
                  RowItemInfoView(
                      name: "RTSP", value: model.deviceInfo.rtspUrl),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "AI设备编码", value: model.deviceInfo.aiDeviceCode),
                  RowItemInfoView(
                      name: "摄像头类型", value: model.deviceInfo.cameraTypeText),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItemInfoView(
                      name: "是否纳入监管",
                      value: model.deviceInfo.controlStatusText),
                  RowItemInfoView(
                      name: "视频接入ID", value: model.deviceInfo.cameraCode),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Clickable(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 6, bottom: 6),
                color: ColorUtils.colorGreen,
                child: const Text(
                  "重启主程",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Clickable(
              onTap: () {
                model.gotoPhotoPreviewScreen();
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 6, bottom: 6),
                color: ColorUtils.colorGreen,
                child: const Text(
                  "图片预览",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _videoView(DetailCameraViewModel model) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(model.context!).size;
    final width = (screenSize.width - 160) * 0.54;
    final height = screenSize.height * 0.43;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Video(controller: model.controller),
        ],
      ),
    );
  }

  //获取异常信息
  NameValue getException(int exception) {
    return NameValue(value: "在线无数据", valueColor: "#FF4D4F");
  }

  Widget imageTimeView(BuildContext context, String? url, String leftStr,
      {String? rightStr , GestureTapCallback? onTap}) {
    final screenSize = MediaQuery.of(context).size;
    return Clickable(
      // color: "#5B6565".toColor(),
      width: 234 / (1050 - 160) * screenSize.width,
      // width: 234 ,
      height: screenSize.height * 0.43 / 2,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: (url ?? "").isNotEmpty
                ? ImageView(
              url: url,
              // src: source(''),
              // width: 234,
              // height: 131,
            )
                : const Center(
              child: Text(
                "没有照片",
                style: TextStyle(
                    fontSize: 12, color: ColorUtils.colorGreenLiteLite),
              ),
            ),
          ),
          // Container(
          //   width: 234 / (1050 - 160) * screenSize.width,
          //   // width: 234 ,
          //   color: ColorUtils.colorGreenLiteLite,
          // ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  leftStr,
                  style: const TextStyle(
                      fontSize: 12, color: ColorUtils.colorGreenLiteLite),
                ),
              ),
              Text(
                rightStr ?? "",
                style: const TextStyle(
                    fontSize: 12, color: ColorUtils.colorGreenLiteLite),
              ),
            ],
          )
        ],
      ),
    );
  }
}


