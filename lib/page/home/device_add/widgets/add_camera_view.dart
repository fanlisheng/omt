import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_sys_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/home/home_page/camera_device_entity.dart';
import 'package:omt/page/home/device_add/view_models/add_camera_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/second_step_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/home/home_page/local_device_entity.dart';
import '../view_models/add_ai_viewmodel.dart';
import '../view_models/device_add_viewmodel.dart';

class AddCameraView extends StatelessWidget {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool? isInstall; //是安装 默认否

  const AddCameraView({super.key, required this.deviceType, required this.stepNumber, this.isInstall});
  // final AddCameraViewModel model;
  // const AddCameraView(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddCameraViewModel>(
        model: AddCameraViewModel(deviceType,stepNumber,isInstall ?? false)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return cameraView(context, model);
        });
  }

  Column cameraView(BuildContext context, AddCameraViewModel model) {
    var windowWidth = BaseSysUtils.getWidth(context);
    var row = windowWidth > 600 * 2 + 200;
    var showDraw = windowWidth > 600 + 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          color: ColorUtils.colorBackgroundLine,
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
        Expanded(
            child: ListView(
          children: model.deviceList.asMap().keys.map((index) {
            CameraDeviceEntity e = model.deviceList[index];
            double height = 194;
            if ((e.rtsp ?? "").isNotEmpty) {
              height = 237;
              if (e.isOpen == true) {
                height = 990;
              }
            }
            return Container(
              height: height,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              color: ColorUtils.colorBackgroundLine,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(e.readOnly)...[
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
                        Button(
                          onPressed: () {
                            model.deleteEventAction(index);
                          },
                          child: Row(
                            children: [
                              ImageView(
                                src: source(
                                  "home/ic_camera_delete",
                                ),
                                width: 10,
                                height: 18,
                                color: ColorUtils.colorRed,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                "删除设备",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorRed,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Button(
                            child: Row(
                              children: [
                                ImageView(
                                  width: 10,
                                  height: 18,
                                  src: source(
                                    "home/ic_camera_edit",
                                  ),
                                  color: ColorUtils.colorGreen,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  "编辑",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorUtils.colorGreen,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              model.editEventAction(index);
                            }),
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
                            ComboBox<String>(
                              isExpanded: true,
                              value: model.selectedAiIp,
                              items: model.aiDeviceList
                                  .map<ComboBoxItem<String>>((e) {
                                return ComboBoxItem<String>(
                                  value: e.ipAddress,
                                  child: Text(
                                    e.ipAddress ?? "",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorBlackLiteLite),
                                  ),
                                );
                              }).toList(),
                              onChanged: (a) {
                                model.selectedAiIp = a!;
                                model.notifyListeners();
                              },
                              placeholder: const Text(
                                "请选择已添加AI设备IP",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorBlackLiteLite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "*",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorRed,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        "RTSP地址",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorWhite,
                        ),
                      ),
                      SizedBox(width: 130),
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
                            enabled: !e.readOnly,
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
                        onTap: e.readOnly
                            ? null
                            : () {
                                model.connectEventAction();
                              },
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
                      ),
                    ],
                  ),
                  if ((e.rtsp ?? "").isNotEmpty) ...[
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
                    if (e.isOpen ?? false) ...[
                      const SizedBox(height: 16),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Text(
                                  "设备编码:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorBlackLiteLite),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "设备编码",
                                  style: TextStyle(
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
                                Text(
                                  "RTSP:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorBlackLiteLite),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "rtsp://admin:flm2020hb@192.168.101.236:554/Streaming/Channels/101",
                                    maxLines: 2,
                                    style: TextStyle(
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
                      _videoView(model),
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
                        two: ComboBox<String>(
                          isExpanded: true,
                          value: e.selectedCameraType,
                          items: model.cameraTypeList
                              .map<ComboBoxItem<String>>((e) {
                            return ComboBoxItem<String>(
                              value: e,
                              child: Text(
                                e,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorGreenLiteLite,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: e.readOnly
                              ? null
                              : (a) {
                                  e.selectedCameraType = a!;
                                  model.notifyListeners();
                                },
                          placeholder: const Text(
                            "请选择摄像头类型",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorBlackLiteLite),
                          ),
                        ),
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
                        one: ComboBox<String>(
                          isExpanded: true,
                          value: e.selectedEntryExit,
                          items: model.entryExitList
                              .map<ComboBoxItem<String>>((e) {
                            return ComboBoxItem<String>(
                              value: e,
                              child: Text(
                                e,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorGreenLiteLite,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: e.readOnly
                              ? null
                              : (a) {
                                  e.selectedEntryExit = a!;
                                  model.notifyListeners();
                                },
                          placeholder: const Text(
                            "请选择进/出口",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorBlackLiteLite),
                          ),
                        ),
                        two: ComboBox<String>(
                          isExpanded: true,
                          value: e.isRegulation,
                          items: model.regulationList
                              .map<ComboBoxItem<String>>((e) {
                            return ComboBoxItem<String>(
                              value: e,
                              child: Text(
                                e,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: ColorUtils.colorGreenLiteLite),
                              ),
                            );
                          }).toList(),
                          onChanged: e.readOnly
                              ? null
                              : (a) {
                                  e.selectedEntryExit = a!;
                                  model.notifyListeners();
                                },
                          placeholder: const Text(
                            "请选择是否纳入监管",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorBlackLiteLite),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      EquallyRow(
                        one: const RowTitle(
                          name: "视频接入ID",
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
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!e.readOnly) ...[
                              Clickable(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 8, bottom: 8),
                                  color: ColorUtils.colorGreen,
                                  child: const Text(
                                    "完成",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorWhite),
                                  ),
                                ),
                                onTap: () {
                                  model.completeEventAction();
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
                                        width: 1, color: ColorUtils.colorGreen),
                                  ),
                                  child: const Text(
                                    "重启识别",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorGreen),
                                  ),
                                ),
                                onTap: () {
                                  model.restartRecognitionEventAction();
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
                                        width: 1, color: ColorUtils.colorGreen),
                                  ),
                                  child: const Text(
                                    "图片预览",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorUtils.colorGreen),
                                  ),
                                ),
                                onTap: () {
                                  model.photoPreviewEventAction();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _videoView(AddCameraViewModel model) {
    return Center(
        child: SizedBox(
      width: 640,
      height: 360,
      child: Stack(
        children: [
          Video(controller: model.controller),
        ],
      ),
    ));
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
  final Widget two;

  const EquallyRow({super.key, required this.one, required this.two});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: one),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: two),
        const SizedBox(width: 20),
      ],
    );
  }
}
