import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/kayo_package.dart';
import '../../../../widget/combobox.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/dash_line.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/camera_device_entity.dart';
import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../theme.dart';
import '../../../../utils/device_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../../device_add/view_models/add_camera_viewmodel.dart';
import '../view_models/edit_camera_viewmodel.dart';

class EditCameraView extends StatelessWidget {
  final DeviceDetailCameraData model;
  final bool? isReplace; //是替换 默认否
  const EditCameraView(
      {super.key, required this.model, required this.isReplace});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditCameraViewModel>(
        model: EditCameraViewModel(model, isReplace ?? false)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return DHeaderPage(
            title: "修改信息",
            titlePath: "首页 / 摄像头 / ",
            content: (model.isReplace && (model.addCameraViewModel != null))
                ? replaceView(model)
                : cameraView(model),
          );
        });
  }

  Widget cameraView(EditCameraViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 500,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),

          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "修改信息",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              EquallyRow(
                one: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowTitle(name: "摄像头名称"),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: TextBox(
                        placeholder: '请输入摄像头名称',
                        controller: model.cameraDevice.deviceNameController,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                two: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowTitle(name: "摄像头类型"),
                    const SizedBox(height: 8),
                    FComboBox<IdNameValue>(
                      selectedValue: model.cameraDevice.selectedCameraType,
                      items: model.cameraTypeList,
                      onChanged: (a) {
                        model.cameraDevice.selectedCameraType = a!;
                        model.notifyListeners();
                      },
                      placeholder: "请选择摄像头类型",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              EquallyRow(
                one: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowTitle(name: "进/出口"),
                    const SizedBox(height: 8),
                    FComboBox<IdNameValue>(
                      selectedValue: model.cameraDevice.selectedEntryExit,
                      items: model.inOutList,
                      onChanged: (a) {
                        model.cameraDevice.selectedEntryExit = a!;
                        model.notifyListeners();
                      },
                      placeholder: "请选择进/出口",
                    ),
                  ],
                ),
                two: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowTitle(name: "是否纳入监管"),
                    const SizedBox(height: 8),
                    FComboBox<IdNameValue>(
                      selectedValue: model.cameraDevice.selectedRegulation,
                      items: model.regulationList,
                      onChanged: (a) {
                        model.cameraDevice.selectedRegulation = a!;
                        model.notifyListeners();
                      },
                      placeholder: "请选择是否纳入监管",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              EquallyRow(
                one: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowTitle(name: "视频ID", isMust: false),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: TextBox(
                        placeholder: '请输入视频ID',
                        controller: model.cameraDevice.videoIdController,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                // width: 120,
                // height: 36,
                decoration: BoxDecoration(
                  color: ColorUtils.colorRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "取消",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                IntentUtils.share.pop(model.context!);
              },
            ),
            const SizedBox(width: 10),
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme().color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "确认",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                model.saveCameraEdit();
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget replaceView(EditCameraViewModel model) {
    return Column(
      children: [
        Expanded(
          child: AddCameraView(model: model.addCameraViewModel!),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                // width: 120,
                // height: 36,
                decoration: BoxDecoration(
                  color: ColorUtils.colorRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "取消",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                IntentUtils.share.pop(model.context!);
              },
            ),
            const SizedBox(width: 10),
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme().color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "确认替换",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                // model.replaceAiDevice();
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
