import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:kayo_package/kayo_package.dart';
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
import '../../../../widget/nav/dnavigation_view.dart';
import '../view_models/edit_camera_viewmodel.dart';

class EditCameraView extends StatelessWidget {
  final DeviceDetailCameraData model;

  const EditCameraView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditCameraViewModel>(
        model: EditCameraViewModel(model)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: ColorUtils.colorBackgroundLine,
            child: ScaffoldPage(
              header: const PageHeader(
                title: DNavigationView(
                  title: "修改摄像头",
                  titlePass: "首页 / 摄像头 / ",
                  rightWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
              content: cameraView(model),
            ),
          );
        });
  }

  Widget cameraView(EditCameraViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            // height: 450,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            color: ColorUtils.colorBackgroundLine,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "修改摄像头信息",
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
                      ComboBox<IdNameValue>(
                        isExpanded: true,
                        value: model.cameraDevice.selectedCameraType,
                        items: model.cameraTypeList
                            .map<ComboBoxItem<IdNameValue>>((ct) {
                          return ComboBoxItem<IdNameValue>(
                            value: ct,
                            child: Text(
                              ct.name ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          );
                        }).toList(),
                        onChanged: (a) {
                          model.cameraDevice.selectedCameraType = a!;
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
                      ComboBox<IdNameValue>(
                        isExpanded: true,
                        value: model.cameraDevice.selectedEntryExit,
                        items: model.inOutList
                            .map<ComboBoxItem<IdNameValue>>((ee) {
                          return ComboBoxItem<IdNameValue>(
                            value: ee,
                            child: Text(
                              ee.name ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          );
                        }).toList(),
                        onChanged: (a) {
                          model.cameraDevice.selectedEntryExit = a!;
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
                    ],
                  ),
                  two: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RowTitle(name: "是否纳入监管"),
                      const SizedBox(height: 8),
                      ComboBox<IdNameValue>(
                        isExpanded: true,
                        value: model.cameraDevice.selectedRegulation,
                        items: model.regulationList
                            .map<ComboBoxItem<IdNameValue>>((ct) {
                          return ComboBoxItem<IdNameValue>(
                            value: ct,
                            child: Text(
                              ct.name ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          );
                        }).toList(),
                        onChanged: (a) {
                          model.cameraDevice.selectedRegulation = a!;
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
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Clickable(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "保存",
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
        ),
      ],
    );
  }
}
