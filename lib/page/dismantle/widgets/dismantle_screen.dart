import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/page/home/bind_device/widgets/device_list_view.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/combobox.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../view_models/dismantle_viewmodel.dart';

class DismantleScreen extends StatelessWidget {
  const DismantleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DismantleViewModel>(
        model: DismantleViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: DNavigationView(
                  title: "安装",
                  titlePass: "",
                  hasReturn: false,
                ),
              ),
              content: contentView(context, model),
            ),
          );
        });
  }

  Widget contentView(BuildContext context1, DismantleViewModel model) {
    return Column(
      children: [
        searchView(model),
        deviceList(model),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                const Text(
                  '已选设备：',
                  style: TextStyle(color: ColorUtils.colorGreenLiteLite),
                ),
                Text(
                  model.dismantleDeviceList.length.toString(),
                  style: const TextStyle(
                    color: ColorUtils.colorGreen,
                  ),
                ),
              ],
            ),
            Clickable(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                color: ColorUtils.colorRed,
                alignment: Alignment.center,
                child: const Text(
                  "拆除设备",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
              onTap: () {
                fu.showDialog(
                  context: context1,
                  barrierDismissible: false, // 禁止点击外部关闭
                  builder: (BuildContext context) {
                    return DismantleDialog(model: model);
                  },
                );
              },
            ),
            const SizedBox(width: 120),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget deviceList(DismantleViewModel model) {
    if (model.noDismantleDeviceList.isEmpty &&
        model.dismantleDeviceList.isEmpty) {
      if (model.isSearchResult) {
        return const Expanded(
            child: Center(
          child: Text(
            "无满足条件的设备，请您重新筛选拆除对象",
            style:
                TextStyle(fontSize: 14, color: ColorUtils.colorGreenLiteLite),
          ),
        ));
      } else {
        return const Spacer();
      }
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        color: ColorUtils.colorBackgroundLine,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "已选择拆除设备",
                    style: TextStyle(
                        fontSize: 12,
                        color: ColorUtils.colorWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 2),
            Expanded(
              child: deviceShowList1(model.dismantleDeviceList, onTap: (index) {
                model.selectedItemEventAction(false, index);
              }),
            ),
            if (model.noDismantleDeviceList.isNotEmpty) ...[
              DashLine(
                height: 1,
                width: double.infinity,
                color: "#678384".toColor(),
                gap: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "不拆除设备",
                      style: TextStyle(
                          fontSize: 12,
                          color: ColorUtils.colorWhite,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: deviceShowList1(model.noDismantleDeviceList,
                    onTap: (index) {
                  model.selectedItemEventAction(true, index);
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget searchView(DismantleViewModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      color: ColorUtils.colorBackgroundLine,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "选择拆除对象",
            style: TextStyle(
              fontSize: 14,
              color: ColorUtils.colorGreenLiteLite,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          EquallyRow(
            one: FComboBox(
                selectedValue: model.selectedInstall,
                items: model.installList,
                placeholder: "请选择实例",
                onChanged: (a) {
                  model.selectedInstall = a!;
                  model.notifyListeners();
                }),
            two: FComboBox(
                selectedValue: model.selectedGateNumber,
                items: model.gateNumberList,
                placeholder: "请选择大门编号",
                onChanged: (a) {
                  model.selectedGateNumber = a!;
                  model.notifyListeners();
                }),
          ),
          const SizedBox(height: 10),
          EquallyRow(
            one: FComboBox(
                selectedValue: model.selectedEntryExit,
                items: model.entryExitList,
                placeholder: "请选择进/出口",
                onChanged: (a) {
                  model.selectedEntryExit = a!;
                  model.notifyListeners();
                }),
            two: Clickable(
              child: Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                color: ColorUtils.colorGreen,
                alignment: Alignment.center,
                child: const Text(
                  "搜索",
                  style: TextStyle(fontSize: 12, color: ColorUtils.colorWhite),
                ),
              ),
              onTap: () {
                model.searchEventAction();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DismantleDialog extends StatefulWidget {
  final DismantleViewModel model;

  const DismantleDialog({super.key, required this.model});

  @override
  _DismantleDialogState createState() {
    return _DismantleDialogState();
  }
}

class _DismantleDialogState extends State<DismantleDialog> {
  @override
  Widget build(BuildContext context) {
    bool hasText = widget.model.selectedDismantleCause == "其它";
    return Dialog(
      // insetPadding:
          // const EdgeInsets.only(left: 110, right: 110, top: 100, bottom: 100),
      child: Container(
        padding: const EdgeInsets.all(0),
        width: 500,
        height: hasText ? 410 : 240,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: ColorUtils.colorBackground,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '拆除设备',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorUtils.colorGreenLiteLite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const RowTitle(name: "拆除原因"),
                const SizedBox(height: 5),
                FComboBox(
                  selectedValue: widget.model.selectedDismantleCause,
                  items: widget.model.dismantleCauseList,
                  onChanged: (e) {
                    setState(() {
                      widget.model.selectedDismantleCause = e;
                    });
                  },
                  placeholder: "请选择拆除原因",
                ),
                const SizedBox(height: 20),
                if(hasText)...[
                  const RowTitle(name: "其他描述"),
                  const SizedBox(height: 5),
                  TextBox(
                    placeholder: "请输入描述...",
                    controller: widget.model.controller,
                    maxLength: 100,
                    maxLines: 8,
                  ),
                  const Spacer(),
                ],
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fu.FilledButton(
                      style: const fu.ButtonStyle(
                          backgroundColor:
                          fu.WidgetStatePropertyAll(ColorUtils.colorRed)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          "返回",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorGreenLiteLite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    fu.FilledButton(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          "提交",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorGreenLiteLite),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
