import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/page/home/bind_device/widgets/device_list_view.dart';
import 'package:omt/page/home/device_add/widgets/add_camera_view.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/combobox.dart';
import '../../../bean/remove/device_list_entity.dart';
import '../../../utils/device_utils.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../view_models/remove_viewmodel.dart';

class RemoveScreen extends StatelessWidget {
  const RemoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<RemoveViewModel>(
        model: RemoveViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: DNavigationView(
                  title: "拆除",
                  titlePass: "",
                  hasReturn: false,
                ),
              ),
              content: contentView(context, model),
            ),
          );
        });
  }

  Widget contentView(BuildContext context1, RemoveViewModel model) {
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
                  model.remainingDeviceList.length.toString(),
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
                model.dismantleEventAction();
                // fu.showDialog(
                //   context: context1,
                //   barrierDismissible: false, // 禁止点击外部关闭
                //   builder: (BuildContext context) {
                //     return RemoveDialog(
                //       onSubmit: (context, dismantleCause, description) {
                //         // 比如调用 ViewModel 的方法
                //
                //       },
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(width: 120),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget deviceList(RemoveViewModel model) {
    // 检查是否有任何设备数据
    bool hasAnyDevices = model.approvedFailedDeviceList.isNotEmpty ||
        model.pendingApprovalDeviceList.isNotEmpty ||
        model.remainingDeviceList.isNotEmpty;

    if (!hasAnyDevices) {
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
        decoration: BoxDecoration(
          color: ColorUtils.colorBackgroundLine,
          borderRadius: BorderRadius.circular(3),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 已选择拆除设备
            if (model.remainingDeviceList.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "已选择拆除设备",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorUtils.colorWhite,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                child: _deviceShowList1(model.remainingDeviceList, onTap: (index) {
                  model.selectedItemEventAction(false, index);
                }),
              ),
              const SizedBox(height: 16),
            ],
            
            // 已申请拆除，审核通过，删除失败
            if (model.approvedFailedDeviceList.isNotEmpty) ...[
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
                      "已申请拆除，审核通过，删除失败",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorUtils.colorRed,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                child: _deviceShowList1(model.approvedFailedDeviceList, readOnly: true),
              ),
              const SizedBox(height: 16),
            ],
            
            // 已申请拆除，待审核
            if (model.pendingApprovalDeviceList.isNotEmpty) ...[
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
                      "已申请拆除，待审核",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorUtils.colorYellow,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                child: _deviceShowList1(model.pendingApprovalDeviceList, readOnly: true),
              ),
              const SizedBox(height: 16),
            ],
            
            // 剩余待绑定设备
            if (model.remainingDeviceList.isNotEmpty) ...[
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
                      "剩余待绑定设备",
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorUtils.colorGreen,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _deviceShowList1(model.remainingDeviceList, onTap: (index) {
                  model.selectedItemEventAction(true, index, listType: 'remaining');
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget searchView(RemoveViewModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: ColorUtils.colorBackgroundLine,
        borderRadius: BorderRadius.circular(3),
      ),
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
            one: AutoSuggestBox<StrIdNameValue>(
              key: model.asgbKey,
              placeholder: "请选择",
              focusNode: model.focusNode,
              controller: model.instanceController,
              placeholderStyle: const TextStyle(fontSize: 12),
              decoration: WidgetStateProperty.resolveWith<BoxDecoration>(
                (Set<WidgetState> states) {
                  return const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorUtils.transparent,
                        width: 2.0,
                      ),
                    ),
                  );
                },
              ),
              onChanged: (text, reason) {
                if (reason == TextChangedReason.cleared) {
                  model.selectedInstance = null;
                  model.notifyListeners();
                }
              },
              items: model.instanceList
                  .map<AutoSuggestBoxItem<StrIdNameValue>>(
                    (instance) => AutoSuggestBoxItem<StrIdNameValue>(
                        value: instance,
                        label: instance.name ?? "",
                        onFocusChange: (focused) {
                          if (focused) debugPrint('Focused ${instance.name}');
                        },
                        onSelected: () {
                          model.selectedInstance = null;
                          model.selectedInstance = instance;
                          model.selectedDoor = null;
                          model.selectedInOut = null;
                          model.notifyListeners();
                        }),
                  )
                  .toList(),
              itemBuilder:
                  (BuildContext context, AutoSuggestBoxItem<dynamic> item) {
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text(
                          item.value?.name ?? "", // 假设你想展示 item 的某个字段
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (item.onSelected != null) {
                      model.focusNode.unfocus();
                      item.onSelected!();
                    }
                  },
                );
              },
              onSelected: (item) {
                model.selectedInstance = item.value;
                model.notifyListeners();
              },
              onOverlayVisibilityChanged: (visible) {
                model.notifyListeners();
              },
            ),
            two: FComboBox<IdNameValue>(
                selectedValue: model.selectedDoor,
                items: model.doorList,
                disabled: model.selectedInstance == null,
                onChanged: (a) {
                  model.selectedDoor = a;
                  model.notifyListeners();
                },
                placeholder: "请选择大门编号"),
          ),
          const SizedBox(height: 10),
          EquallyRow(
            one: FComboBox<IdNameValue>(
                selectedValue: model.selectedInOut,
                items: model.inOutList,
                disabled: model.selectedDoor == null,
                onChanged: (a) {
                  model.selectedInOut = a;
                  model.notifyListeners();
                },
                placeholder: "请选择进/出口"),
            two: Clickable(
              child: Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: ColorUtils.colorGreen,
                  borderRadius: BorderRadius.circular(3),
                ),
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

  Widget _deviceShowList1(
    List<DeviceListData> deviceData, {
    Function(int)? onTap,
    bool readOnly = false,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
      child: Wrap(
        spacing: 10, // 水平间距
        runSpacing: 10, // 垂直间距
        children: List.generate(deviceData.length, (index) {
          String? imageUrl;
          Color? color;
          if (deviceData[index].selected == true) {
            imageUrl = "home/ic_device_remove";
            color = "#FF4D4F".toColor();
          }
          return Clickable(
              onTap: readOnly ? null : (onTap != null
                  ? () {
                      onTap(index);
                    }
                  : null),
            child: Container(
              width: 90, // 固定宽度
              height: 76, // 固定高度
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: color ?? "#5D6666".toColor(),
                ),
                borderRadius: BorderRadius.circular(3),
                color: color?.withOpacity(0.1) ?? ColorUtils.transparent,
                boxShadow: [
                  BoxShadow(
                    color: '#82FFFC'.toColor(opacity: .05),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 5,
                          child: ImageView(
                            src: source(DeviceUtils.getDeviceImage(
                                deviceData[index].type ?? 0)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              deviceData[index].typeText ?? "-",
                              style:
                                  const TextStyle(color: ColorUtils.colorWhite),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 4),
                              child: Text(
                                deviceData[index].ip.defaultStr(
                                    data: deviceData[index].desc ?? ''),
                                style: const TextStyle(
                                    color: ColorUtils.colorWhite, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Positioned(
                      top: 2,
                      right: 2,
                      width: 16,
                      height: 16,
                      child: ImageView(
                        src: source(imageUrl ?? "home/ic_device_add"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RemoveDialog extends StatefulWidget {
  final Function(BuildContext, String, String) onSubmit; // 添加回调函数

  const RemoveDialog({super.key, required this.onSubmit}); // 构造函数中传入回调);

  @override
  _RemoveDialogState createState() {
    return _RemoveDialogState();
  }
}

class _RemoveDialogState extends State<RemoveDialog> {
  //拆除原因
  String selectedDismantleCause = "";
  List dismantleCauseList = ["业主通知", "运营通知", "其它"];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool hasText = selectedDismantleCause == "其它";
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
                  selectedValue: selectedDismantleCause,
                  items: dismantleCauseList,
                  onChanged: (e) {
                    setState(() {
                      selectedDismantleCause = e;
                    });
                  },
                  placeholder: "请选择拆除原因",
                ),
                const SizedBox(height: 20),
                if (hasText) ...[
                  const RowTitle(name: "其它描述"),
                  const SizedBox(height: 5),
                  TextBox(
                    placeholder: "请输入描述...",
                    controller: controller,
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
                        widget.onSubmit(
                            context, selectedDismantleCause, controller.text);
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
