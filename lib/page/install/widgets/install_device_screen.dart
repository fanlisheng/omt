import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/device_add/view_models/add_ai_viewmodel.dart';
import 'package:omt/page/home/device_add/view_models/device_add_viewmodel.dart';
import 'package:omt/page/home/device_add/widgets/add_ai_view.dart';
import 'package:omt/page/home/device_add/widgets/add_battery_exchange_view.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/page/home/device_add/widgets/add_nvr_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_box_view.dart';
import 'package:omt/page/home/device_add/widgets/add_power_view.dart';
import 'package:omt/page/install/widgets/preview_page.dart';
import 'package:omt/utils/color_utils.dart';
import '../../../widget/combobox.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../../../widget/searchable_dropdown.dart';
import '../../home/home/keep_alive_page.dart';
import '../view_models/install_device_viewmodel.dart';

class InstallDeviceScreen extends StatelessWidget {
  const InstallDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<InstallDeviceViewModel>(
        model: InstallDeviceViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: fu.PageHeader(
                title: DNavigationView(
                  title: "安装",
                  titlePass: "",
                  hasReturn: false,
                  rightWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: model.currentStep != 1,
                          child: Clickable(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 4, bottom: 4),
                              color: ColorUtils.colorGreen,
                              child: const Text(
                                "上一步",
                                style: TextStyle(
                                    fontSize: 12, color: ColorUtils.colorWhite),
                              ),
                            ),
                            onTap: () {
                              model.backStepEventAction();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Clickable(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 4, bottom: 4),
                            color: ColorUtils.colorGreen,
                            child: Text(
                              model.currentStep == 7 ? "添加完成" : (model.currentStep == 6 ? "生成拓扑图" : "下一步"),
                              style: const TextStyle(
                                  fontSize: 12, color: ColorUtils.colorWhite),
                            ),
                          ),
                          onTap: () {
                            model.nextStepEventAction();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(InstallDeviceViewModel model) {
    return Column(
      children: [
        if(model.currentStep < 7)...[
          topView(model),
          const SizedBox(height: 10),
        ],
        Expanded(
          child: bottomContentView(model),
        ),
      ],
    );
  }

  Widget _stepOneView(InstallDeviceViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "第一步：实例绑定",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const EquallyRow(
                one: RowTitle(name: "实例"),
                two: RowTitle(name: "大门编号"),
              ),
              const SizedBox(height: 10),
              EquallyRow(
                one: SearchableDropdown<StrIdNameValue>(
                  asgbKey: model.asgbKey,
                  focusNode: model.focusNode,
                  controller: model.controller,
                  items: model.instanceList,
                  placeholder: "请选择实例",
                  labelSelector: (item) => item.name ?? "",
                  clearButtonEnabled: true,
                  onSelected: (a) {
                    model.selectedInstance = a;
                    model.selectedDoor = null;
                    model.notifyListeners();
                  },
                ),
                two: FComboBox<IdNameValue>(
                    selectedValue: model.selectedDoor,
                    items: model.doorList,
                    disabled:  model.selectedInstance == null,
                    onChanged: (a) {
                      model.selectedDoor = a;
                      model.selectedInOut = null;
                      model.notifyListeners();
                    },
                    placeholder: "请选择大门编号"),
              ),
              const SizedBox(height: 20),
              const RowTitle(name: "标签",isMust: false),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MultiSelectComboBox(
                      availableTags: model.availableTags,
                      initialSelectedTags: model.selectedTags,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget topView(InstallDeviceViewModel model) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: ColorUtils.colorBackgroundLine,
        borderRadius: BorderRadius.circular(3),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      padding: const EdgeInsets.only(top: 23),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(model.stepTitles.length, (index) {
          return Expanded(
            child: Column(
              children: [
                // 上方线 + 圆形 + 下方线
                Row(
                  children: [
                    // 左侧线段
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index == 0
                            ? ColorUtils.transparent
                            : (index < model.currentStep
                                ? ColorUtils.colorGreen
                                : ColorUtils.colorGreenLiteLite),
                      ),
                    ),
                    // 圆形
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: index < model.currentStep
                            ? ColorUtils.colorGreen
                            : ColorUtils.colorGreenLiteLite,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: (index < model.currentStep)
                                ? ColorUtils.colorWhite
                                : ColorUtils.colorBlackLite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // 右侧线段
                    Expanded(
                      child: Container(
                        height: 2,
                        color: (index == model.stepTitles.length - 1)
                            ? ColorUtils.transparent
                            : ((index + 1) < model.currentStep
                                ? ColorUtils.colorGreen
                                : ColorUtils.colorGreenLiteLite),
                      ),
                    ),
                  ],
                ),
                // 文字
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.stepTitles[index],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: index < model.currentStep
                              ? ColorUtils.colorGreen
                              : ColorUtils.colorGreenLiteLite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget bottomContentView(InstallDeviceViewModel model) {
    return PageView(
      controller: model.pageController,
      physics: const NeverScrollableScrollPhysics(), // 禁用手动滑动
      onPageChanged: (index) {
        model.currentStep = index + 1;
        model.notifyListeners();
      },
      children: [
        KeepAlivePage(child: _stepOneView(model)),
        KeepAlivePage(child: AddAiView(model: model.aiViewModel)),
        KeepAlivePage(child: AddCameraView(model: model.cameraViewModel)),
        KeepAlivePage(child: AddNvrView(model: model.nvrViewModel)),
        KeepAlivePage(child: AddPowerBoxView(model: model.powerBoxViewModel)),
        KeepAlivePage(child: AddPowerView(model: model.powerViewModel)),
        KeepAlivePage(child: PreviewPage()),
      ],
    );
  }
}
