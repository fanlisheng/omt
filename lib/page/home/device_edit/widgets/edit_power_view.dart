import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/checkbox.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_power_entity.dart';
import '../../../../theme.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../view_models/edit_power_viewmodel.dart';
import '../../device_add/widgets/add_camera_view.dart';

class EditPowerView extends StatefulWidget {
  final DeviceDetailPowerData model;

  const EditPowerView({super.key, required this.model});

  @override
  State<EditPowerView> createState() => _EditPowerViewState();
}

class _EditPowerViewState extends State<EditPowerView> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditPowerViewModel>(
        model: EditPowerViewModel(widget.model)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return DHeaderPage(
            title: "编辑电源信息",
            titlePath: "首页 / 电源 / ",
            content: contentView(model),
          );
        });
  }

  Widget contentView(EditPowerViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: ColorUtils.colorBackgroundLine,
            borderRadius: BorderRadius.circular(3),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "编辑电源信息",
                style: TextStyle(
                    fontSize: 16,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 37),
              const Row(
                children: [
                  Text(
                    "*",
                    style: TextStyle(
                        fontSize: 12,
                        color: ColorUtils.colorRed,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 2),
                  Text(
                    "进/出口",
                    style: TextStyle(
                        fontSize: 12,
                        color: ColorUtils.colorWhite,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              EquallyRow(
                one: ComboBox<IdNameValue>(
                  isExpanded: true,
                  value: model.selectedPowerInOut,
                  items: model.inOutList.map<ComboBoxItem<IdNameValue>>((e) {
                    return ComboBoxItem<IdNameValue>(
                      value: e,
                      child: SizedBox(
                        child: Text(
                          e.name ?? "",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 12, color: ColorUtils.colorWhite),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (a) {
                    model.selectedPowerInOut = a!;
                    model.notifyListeners();
                  },
                  placeholder: const Text(
                    "请选择进/出口",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                  ),
                ),
                two: Container(),
              ),
              const SizedBox(height: 38),
              DashLine(
                color: "#5D6666".toColor(),
                height: 1,
                width: double.infinity,
              ),
              const SizedBox(height: 37),
              EquallyRow(
                one: const Row(
                  children: [
                    Text(
                      "*",
                      style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorRed,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 2),
                    Text(
                      "电源类型",
                      style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorWhite,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                two: model.battery
                    ? const Row(
                        children: [
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorRed,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 2),
                          Text(
                            "电池容量",
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorUtils.colorWhite,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    : Container(),
              ),
              const SizedBox(height: 17),
              EquallyRow(
                one: Wrap(
                  spacing: 30.0,
                  children: [
                    FCheckbox(
                      checked: model.batteryMains,
                      label: '市电',
                      onChanged: (isChecked) {
                        model.batteryMains = isChecked;
                        model.notifyListeners();
                      },
                    ),
                    FCheckbox(
                      checked: model.battery,
                      label: '电池',
                      onChanged: (isChecked) {
                        model.battery = isChecked;
                        model.notifyListeners();
                      },
                    ),
                  ],
                ),
                two: model.battery
                    ? Wrap(
                        spacing: 30.0,
                        children: [
                          FCheckbox(
                            checked: model.isCapacity80,
                            label: '80',
                            onChanged: (isChecked) {
                              model.isCapacity80 = isChecked;
                              model.notifyListeners();
                            },
                          ),
                          FCheckbox(
                            checked: !model.isCapacity80,
                            label: '160',
                            onChanged: (isChecked) {
                              model.isCapacity80 = !isChecked;
                              model.notifyListeners();
                            },
                          ),
                        ],
                      )
                    : Container(),
              ),
              const SizedBox(height: 37),
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
                model.savePowerEdit();
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
