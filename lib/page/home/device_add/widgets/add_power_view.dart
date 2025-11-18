import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ma;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/checkbox.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../theme.dart';
import '../../../../widget/combobox.dart';
import '../view_models/add_power_viewmodel.dart';
import 'add_camera_view.dart';

class AddPowerView extends StatefulWidget {
  final AddPowerViewModel model;

  const AddPowerView({super.key, required this.model});

  @override
  State<AddPowerView> createState() => _AddPowerViewState();
}

class _AddPowerViewState extends State<AddPowerView> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<AddPowerViewModel>(
        model: widget.model..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return contentView(widget.model);
        });
  }

  Widget contentView(AddPowerViewModel model) {
    double vSpace = 20;
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
              const SizedBox(height: 15),
              Text(
                model.isInstall ? "添加电源及其它信息" : "添加电源信息",
                style: const TextStyle(
                    fontSize: 14,
                    color: ColorUtils.colorWhite,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
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
                  selectedValue: model.selectedPowerInOut,
                  items: model.inOutList,
                  onChanged: (a) {
                    model.selectedPowerInOut = a;
                    model.notifyListeners();
                  },
                  placeholder: "请选择进/出口",
                ),
                two: Container(),
              ),
              SizedBox(height: vSpace),
              DashLine(
                color: "#5D6666".toColor(),
                height: 1,
                width: double.infinity,
              ),
               SizedBox(height: vSpace),
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
                      "现场接电方式",
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
              const SizedBox(height: 6),
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
                            label: '80AH',
                            onChanged: (isChecked) {
                              model.isCapacity80 = isChecked;
                              model.notifyListeners();
                            },
                          ),
                          FCheckbox(
                            checked: !model.isCapacity80,
                            label: '160AH',
                            onChanged: (isChecked) {
                              model.isCapacity80 = !isChecked;
                              model.notifyListeners();
                            },
                          ),
                        ],
                      )
                    : Container(),
              ),
               SizedBox(height: vSpace),
              DashLine(
                color: "#5D6666".toColor(),
                height: 1,
                width: double.infinity,
              ),
               SizedBox(height: vSpace),
              if (model.isInstall) ...[
                const EquallyRow(
                  one: Row(
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
                        "有线/无线",
                        style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  two: Row(
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
                        "路由器IP",
                        style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                EquallyRow(
                  one: FComboBox(
                    selectedValue: model.selectedRouterType,
                    items: model.routerTypeList,
                    onChanged: (e) {
                      setState(() {
                        model.selectedRouterType = e!;
                      });
                    },
                    placeholder: "请选择有线无线",
                  ),
                  two: TextBox(
                    readOnly: true,
                    enabled: false,
                    controller: model.routerIpController,
                  ),
                ),
                buildExchangeList(model),
              ],
            ],
          ),
        ),
        if (model.isInstall) ...[
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Clickable(
                child: Text(
                  "+继续添加",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme().color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  model.addExchangeAction();
                },
              ),
              Expanded(child: Container()),
              Button(
                onPressed: () {
                  model.removeExchangeAction();
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    const RoundedRectangleBorder(
                      side: BorderSide.none, // 去掉边框
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  // 去掉背景
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return ButtonThemeData.buttonForegroundColor(
                        context, states); // 保留前景色
                  }),
                ),
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
              const SizedBox(width: 16),
            ],
          ),
        ],
      ],
    );
  }

  Widget buildExchangeList(AddPowerViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        model.exchangeDevices.length,
        (index) {
          final device = model.exchangeDevices[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                DashLine(
                  color: "#5D6666".toColor(),
                  height: 1,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
                const EquallyRow(
                  one: RowTitle(name: "交换机接口数量"),
                  two: RowTitle(name: "交换机接供电方式"),
                ),
                EquallyRow(
                  one: Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      model.portNumber.length,
                      (i) {
                        final option = model.portNumber[i];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ma.Radio(
                              value: option,
                              groupValue: device.selectedPortNumber,
                              activeColor: ColorUtils.colorGreen,
                              onChanged: (value) {
                                device.updatePortNumber(value);
                                model.notifyListeners();
                              },
                            ),
                            Text(
                              "$option口",
                              style: TextStyle(
                                fontSize: 12,
                                color: device.selectedPortNumber != option
                                    ? ColorUtils.colorWhite
                                    : ColorUtils.colorGreen,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  two: Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      model.supplyMethod.length,
                      (i) {
                        final option = model.supplyMethod[i];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ma.Radio(
                              value: option,
                              groupValue: device.selectedSupplyMethod,
                              activeColor: ColorUtils.colorGreen,
                              onChanged: (value) {
                                device.updateSupplyMethod(value);
                                model.notifyListeners();
                              },
                            ),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 12,
                                color: device.selectedSupplyMethod != option
                                    ? ColorUtils.colorWhite
                                    : ColorUtils.colorGreen,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
