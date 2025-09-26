import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_sys_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/page/home/device_add/view_models/add_camera_viewmodel.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../theme.dart';
import '../../../../widget/combobox.dart';

class AddCameraView extends StatelessWidget {
  final AddCameraViewModel model;

  const AddCameraView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddCameraViewModel>(
        model: model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return cameraView(model, context);
        });
  }

  Column cameraView(AddCameraViewModel model, BuildContext context) {
    var windowWidth = BaseSysUtils.getWidth(context);
    var row = windowWidth > 600 * 2 + 200;
    var showDraw = windowWidth > 600 + 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.isReplace == false) ...[
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: ColorUtils.colorBackgroundLine,
              borderRadius: BorderRadius.circular(3),
            ),
            width: double.infinity,
            child: const Text(
              "第三步：添加摄像头",
              style: TextStyle(
                fontSize: 14,
                color: ColorUtils.colorGreenLiteLite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Expanded(
            child: ListView(
          children: model.cameraDeviceList.asMap().keys.map((index) {
            CameraDeviceEntity e = model.cameraDeviceList[index];
            double height = 194;
            if ((e.rtsp ?? "").isNotEmpty) {
              height = 248;
              if (e.isOpen == true) {
                if (model.isReplace) {
                  height = 900;
                } else {
                  height = 990;
                }
              }
            }
            String statusText;
            Color statusColor;

            if (e.playResult == null) {
              // 播放成功 - 连接成功
              statusText = '';
              statusColor = AppTheme().color;
            } else if (e.playResult == true) {
              // 播放成功 - 连接成功
              statusText = '连接成功';
              statusColor = AppTheme().color;
            } else {
              // 播放失败/超时 - 连接失败
              statusText = '连接失败';
              statusColor = Colors.red;
            }
            return Container(
              height: height,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: ColorUtils.colorBackgroundLine,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.readOnly) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "设备${index + 1}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorUtils.colorGreenLiteLite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: 12, color: ColorUtils.colorRed),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "已添加AI设备IP",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorWhite),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FComboBox<DeviceDetailAiData>(
                              selectedValue: e.selectedAi,
                              items: model.aiDeviceList,
                              onChanged: e.readOnly
                                  ? null
                                  : (a) {
                                      e.selectedAi = a!;
                                      model.notifyListeners();
                                    },
                              placeholder: "请选择已添加AI设备IP",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                        "RTSP地址",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorWhite,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 280,
                          height: 32,
                          child: TextBox(
                            placeholder: '请输入RTSP地址',
                            controller: e.rtspController,
                            enabled: model.isReplace ? true : !e.readOnly,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: ColorUtils.colorGreenLiteLite,
                            ),
                            placeholderStyle: const TextStyle(
                              fontSize: 12.0,
                              color: ColorUtils.colorBlackLiteLite,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Clickable(
                        onTap: (e.readOnly && !model.isReplace)
                            ? null
                            : () {
                                model.connectCameraAction(index);
                              },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 6, bottom: 6),
                          decoration: BoxDecoration(
                            color: ColorUtils.colorGreen,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            "连接",
                            style: TextStyle(
                                fontSize: 12, color: ColorUtils.colorWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if ((e.code ?? "").isNotEmpty) ...[
                    if (model.isReplace == false) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Clickable(
                            onTap: () {
                              e.isOpen = !(e.isOpen ?? false);
                              model.notifyListeners();
                            },
                            padding: const EdgeInsets.all(5),
                            child: const Text(
                              "展开详情",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorGreenLiteLite),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: DashLine(
                                height: 1,
                                width: double.infinity,
                                color: "#678384".toColor(),
                                gap: 3),
                          )
                        ],
                      ),
                    ],
                    if (e.isOpen ?? false) ...[
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const Text(
                                  "设备编码:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorBlackLiteLite),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  e.code ?? "",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorGreenLiteLite),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const Text(
                                  "RTSP:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorBlackLiteLite),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.rtspController.text ?? '',
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorGreenLiteLite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      _videoView(e.videoController, model, index),
                      const SizedBox(height: 16),
                      DashLine(
                          height: 1,
                          width: double.infinity,
                          color: "#678384".toColor(),
                          gap: 3),
                      const SizedBox(height: 16),
                      const Text(
                        "AI设备信息",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorGreenLiteLite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const EquallyRow(
                        one: RowTitle(
                          name: "设备名称",
                        ),
                        two: RowTitle(
                          name: "摄像头类型",
                        ),
                      ),
                      const SizedBox(height: 8),
                      EquallyRow(
                        one: TextBox(
                          placeholder: '请输入设备名称',
                          controller: e.deviceNameController,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: ColorUtils.colorGreenLiteLite,
                          ),
                          placeholderStyle: const TextStyle(
                            fontSize: 12.0,
                            color: ColorUtils.colorBlackLiteLite,
                          ),
                          enabled: !e.readOnly,
                        ),
                        two: FComboBox<IdNameValue>(
                            selectedValue: e.selectedCameraType,
                            items: model.cameraTypeList,
                            onChanged: e.readOnly
                                ? null
                                : (a) {
                                    e.selectedCameraType = a!;
                                    model.notifyListeners();
                                  },
                            placeholder: "请选择大门编号"),
                      ),
                      const SizedBox(height: 10),
                      const EquallyRow(
                        one: RowTitle(
                          name: "进/出口",
                        ),
                        two: RowTitle(
                          name: "是否纳入监管",
                        ),
                      ),
                      const SizedBox(height: 8),
                      EquallyRow(
                        one: FComboBox<IdNameValue>(
                          selectedValue: e.selectedEntryExit,
                          items: model.inOutList,
                          onChanged: e.readOnly
                              ? null
                              : (a) {
                                  e.selectedEntryExit = a!;
                                  model.notifyListeners();
                                },
                          placeholder: "请选择进/出口",
                        ),
                        two: FComboBox<IdNameValue>(
                          selectedValue: e.selectedRegulation,
                          items: model.regulationList,
                          onChanged: e.readOnly
                              ? null
                              : (a) {
                                  e.selectedRegulation = a!;
                                  model.notifyListeners();
                                },
                          placeholder: "请选择是否纳入监管",
                        ),
                      ),
                      const SizedBox(height: 10),
                      EquallyRow(
                        one: const RowTitle(
                          name: "视频接入ID(国标ID)",
                          isMust: false,
                        ),
                        two: Container(),
                      ),
                      const SizedBox(height: 8),
                      EquallyRow(
                        one: TextBox(
                          placeholder: '输入ID后，可在视频监控模块查看该设备实时视频',
                          enabled: !e.readOnly,
                          controller: e.videoIdController,
                          style: const TextStyle(
                              fontSize: 12.0,
                              color: ColorUtils.colorGreenLiteLite),
                          placeholderStyle: const TextStyle(
                              fontSize: 12.0,
                              color: ColorUtils.colorBlackLiteLite),
                        ),
                        two: Container(),
                      ),
                      const SizedBox(height: 20),
                      // 只有在非替换模式下才显示完成按钮
                      if (!model.isReplace) ...[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!e.readOnly) ...[
                                Clickable(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.colorGreen,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      model.operationType.completeButtonText,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ColorUtils.colorWhite),
                                    ),
                                  ),
                                  onTap: () {
                                    // e.readOnly = true;
                                    // model.notifyListeners();
                                    if (model.checkCameraInfo(e)) {
                                      showConfirmDialog(
                                          context, e, model, index);
                                    }
                                    // model.completeCameraAction(e);
                                  },
                                ),
                              ] else ...[
                                Clickable(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, top: 8, bottom: 8),
                                    // color: ColorUtils.colorGreen,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorUtils.colorGreen),
                                    ),
                                    child: const Text(
                                      "重启识别",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorUtils.colorGreen),
                                    ),
                                  ),
                                  onTap: () {
                                    model.restartRecognitionAction(e);
                                  },
                                ),
                                const SizedBox(width: 18),
                                Clickable(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, top: 8, bottom: 8),
                                    // color: ColorUtils.colorGreen,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorUtils.colorGreen),
                                    ),
                                    child: const Text(
                                      "图片预览",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorUtils.colorGreen),
                                    ),
                                  ),
                                  onTap: () {
                                    model.photoPreviewAction(e);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ]
                    ],
                  ],
                ],
              ),
            );
          }).toList(),
        )),
        const SizedBox(height: 10),
        // 只有在非替换模式下才显示继续添加按钮
        if (!model.isReplace) ...[
          Row(
            children: [
              const SizedBox(width: 16),
              Clickable(
                child: Text(
                  model.operationType.continueActionText,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme().color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  if (model.cameraDeviceList.last.isAddEnd == true) {
                    model.cameraDeviceList.add(CameraDeviceEntity());
                    model.notifyListeners();
                  } else {
                    LoadingUtils.showInfo(data: "请${model.operationType.displayName}完上一个设备!");
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ]
      ],
    );
  }

  Widget _videoView(
      VideoController? controller, AddCameraViewModel model, int index) {
    // 获取当前摄像头设备
    final cameraDevice = model.cameraDeviceList[index];

    // 使用设备自己的videoController
    final videoController = cameraDevice.videoController;

    // 如果有RTSP地址，则播放视频
    final rtspUrl = cameraDevice.rtsp;
    if (rtspUrl != null && rtspUrl.isNotEmpty) {
      videoController.player.open(Media(rtspUrl));
    }

    return Center(
        child: SizedBox(
      width: 640,
      height: 360,
      child: StatefulBuilder(
        builder: (context, setState) {
          return StreamBuilder<bool>(
            stream: videoController.player.stream.playing,
            builder: (context, playingSnapshot) {
              return StreamBuilder<Duration>(
                stream: videoController.player.stream.position,
                builder: (context, positionSnapshot) {
                  // 检查是否正在播放且有画面
                  bool isPlaying = playingSnapshot.data ?? false;
                  Duration position = positionSnapshot.data ?? Duration.zero;

                  // 更新CameraDeviceEntity中的播放状态
                  model.cameraDeviceList[index].isPlaying = isPlaying;
                  model.cameraDeviceList[index].position = position;

                  // 如果正在播放且有画面，直接显示视频
                  if (isPlaying && position > Duration.zero) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      model.updatePlayResult(index, true); // 播放成功
                    });
                    return Video(controller: videoController);
                  }

                  // 添加延迟判断逻辑，避免立即显示无画面
                  return FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 3)),
                    builder: (context, delaySnapshot) {
                      // 如果延迟还没结束且没有播放，显示加载状态
                      if (delaySnapshot.connectionState !=
                          ConnectionState.done) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const material.CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '正在连接...',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // 延迟结束后，设置播放失败状态并显示无画面提示
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        model.updatePlayResult(index, false); // 播放失败/超时
                      });

                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              material.Icon(
                                material.Icons.videocam_off,
                                size: 48,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '无画面',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '请检查RTSP地址是否正确',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.54),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    ));
  }

  // 显示确认弹窗
  void showConfirmDialog(
      BuildContext context,
      CameraDeviceEntity cameraDeviceEntity,
      AddCameraViewModel model,
      int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: false,
      builder: (context2) {
        return Center(
          child: Container(
            width: 980,
            height: 640,
            decoration: BoxDecoration(
              color: ColorUtils.colorBackgroundLine,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  model.operationType.confirmDialogTitle,
                  style: const TextStyle(fontSize: 16, color: ColorUtils.colorWhite),
                ),
                const SizedBox(height: 28),
                _videoView(cameraDeviceEntity.videoController, model, index),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        '设备名称: ${cameraDeviceEntity.deviceNameController.text}'),
                    Text(
                        '摄像头类型: ${cameraDeviceEntity.selectedCameraType?.name ?? ""}'),
                    Text(
                        '进/出口: ${cameraDeviceEntity.selectedEntryExit?.name ?? ""}'),
                    Text(
                        '是否纳入监管: ${cameraDeviceEntity.selectedRegulation?.name ?? ""}'),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context2);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(ColorUtils.colorRed),
                      ),
                      child: const Text(
                        "返回修改",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 24),
                    FilledButton(
                      onPressed: () => model.completeCameraAction(
                          context2, cameraDeviceEntity),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppTheme().color),
                      ),
                      child: Text(
                        model.operationType.confirmButtonText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RowTitle extends StatelessWidget {
  const RowTitle({
    super.key,
    required this.name,
    this.isMust,
  });

  final String name;
  final bool? isMust;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if ((isMust ?? true) == true) ...[
          const Text(
            "*",
            style: TextStyle(fontSize: 12, color: ColorUtils.colorRed),
          ),
          const SizedBox(width: 2),
        ],
        Text(
          name,
          style: const TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
        ),
      ],
    );
  }
}

class EquallyRow extends StatelessWidget {
  final Widget one;
  final Widget? two;

  const EquallyRow({super.key, required this.one, this.two});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: one),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: two ?? Container()),
        const SizedBox(width: 20),
      ],
    );
  }
}
