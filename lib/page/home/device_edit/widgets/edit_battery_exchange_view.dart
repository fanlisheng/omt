import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/combobox.dart';

import '../../../../bean/common/id_name_value.dart';
import '../../../../bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../theme.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../view_models/edit_battery_exchange_viewmodel.dart';

class EditBatteryExchangeView extends StatelessWidget {
  final DeviceDetailExchangeData model;

  const EditBatteryExchangeView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EditBatteryExchangeViewModel>(
        model: EditBatteryExchangeViewModel(model)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return DHeaderPage(
            title: model.isBattery ? "修改信息" : "修改信息",
            titlePath: model.isBattery ? "首页 / 电池 / " : "首页 / 交换机 / ",
            content: contentView(model),
          );
        });
  }

  Column contentView(EditBatteryExchangeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
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
              Text(
                "修改信息",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorGreenLiteLite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // if (model.isBattery) ...batteryView(model),
              if (!model.isBattery) ...exchangeView(model),
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
                model.saveExchangeEdit();
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // List<Widget> batteryView(EditBatteryExchangeViewModel model) {
  //   return [
  //     const SizedBox(height: 10),
  //     const RowTitle(name: "电池容量"),
  //     Row(
  //       children: [
  //         Radio(
  //           value: true,
  //           groupValue: model.isCapacity80,
  //           activeColor: ColorUtils.colorGreen,
  //           onChanged: (value) {
  //             model.isCapacity80 = value as bool;
  //             model.notifyListeners();
  //           },
  //         ),
  //         Text("80AH",
  //             style: TextStyle(
  //                 fontSize: 12,
  //                 color: model.isCapacity80
  //                     ? ColorUtils.colorGreen
  //                     : ColorUtils.colorWhite)),
  //         const SizedBox(width: 16),
  //         Radio(
  //           value: false,
  //           groupValue: model.isCapacity80,
  //           activeColor: ColorUtils.colorGreen,
  //           onChanged: (value) {
  //             model.isCapacity80 = value as bool;
  //             model.notifyListeners();
  //           },
  //         ),
  //         Text("160AH",
  //             style: TextStyle(
  //                 fontSize: 12,
  //                 color: model.isCapacity80
  //                     ? ColorUtils.colorWhite
  //                     : ColorUtils.colorGreen)),
  //       ],
  //     ),
  //     const SizedBox(height: 20),
  //     const Row(
  //       children: [
  //         Text(
  //           "*",
  //           style: TextStyle(
  //               fontSize: 12,
  //               color: ColorUtils.colorRed,
  //               fontWeight: FontWeight.w500),
  //         ),
  //         SizedBox(width: 2),
  //         Text(
  //           "进/出口",
  //           style: TextStyle(
  //               fontSize: 12,
  //               color: ColorUtils.colorWhite,
  //               fontWeight: FontWeight.w500),
  //         ),
  //       ],
  //     ),
  //     const SizedBox(height: 5),
  //     EquallyRow(
  //       one: ComboBox<IdNameValue>(
  //         isExpanded: true,
  //         value: model.selectedInOut,
  //         items: model.inOutList.map<ComboBoxItem<IdNameValue>>((e) {
  //           return ComboBoxItem<IdNameValue>(
  //             value: e,
  //             child: SizedBox(
  //               child: Text(
  //                 e.name ?? "",
  //                 textAlign: TextAlign.start,
  //                 style: const TextStyle(
  //                     fontSize: 12, color: ColorUtils.colorWhite),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (a) {
  //           model.selectedInOut = a!;
  //           model.notifyListeners();
  //         },
  //         placeholder: const Text(
  //           "请选择进/出口",
  //           textAlign: TextAlign.start,
  //           style: TextStyle(
  //               fontSize: 12, color: ColorUtils.colorBlackLiteLite),
  //         ),
  //       ),
  //       two: Container(),
  //     ),
  //   ];
  // }

  List<Widget> exchangeView(EditBatteryExchangeViewModel model) {
    return [
      const SizedBox(height: 20),
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
        one: FComboBox<IdNameValue>(
          selectedValue: model.selectedInOut,
          items: model.inOutList,
          onChanged: (a) {
            model.selectedInOut = a;
            model.notifyListeners();
          },
          placeholder: "请选择进/出口",
        ),
      ),
      const SizedBox(height: 20),
      // const RowTitle(name: "交换机接口数量"),
      const EquallyRow(
        one: RowTitle(name: "交换机接口数量"),
        two: RowTitle(name: "交换机供电方式"),
      ),
      EquallyRow(
        one: Wrap(
          spacing: 20.0,
          children: List.generate(
            model.portNumber.length,
            (index) {
              final option = model.portNumber[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: option,
                    groupValue: model.selectedPortNumber,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.selectedPortNumber = value;
                      model.notifyListeners();
                    },
                  ),
                  Text("$option口",
                      style: TextStyle(
                          fontSize: 12,
                          color: model.selectedPortNumber != option
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen)),
                ],
              );
            },
          ),
        ),
        two: Wrap(
          spacing: 20.0,
          children: List.generate(
            model.supplyMethod.length,
            (index) {
              final option = model.supplyMethod[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: option,
                    groupValue: model.selectedSupplyMethod,
                    activeColor: ColorUtils.colorGreen,
                    onChanged: (value) {
                      model.selectedSupplyMethod = value;
                      model.notifyListeners();
                    },
                  ),
                  Text(option,
                      style: TextStyle(
                          fontSize: 12,
                          color: model.selectedSupplyMethod != option
                              ? ColorUtils.colorWhite
                              : ColorUtils.colorGreen)),
                ],
              );
            },
          ),
        ),
      ),
    ];
  }
}
