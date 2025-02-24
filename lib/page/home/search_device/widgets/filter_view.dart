import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/widget/checkbox.dart';
import 'package:omt/widget/combobox.dart';

import '../../../../routing/routes.dart';
import '../view_models/search_device_viewmodel.dart';

class FilterView extends StatefulWidget {
  final SearchDeviceViewModel viewModel;

  const FilterView({super.key, required this.viewModel});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    SearchDeviceViewModel model = widget.viewModel;
    return buildContainer(model, context);
  }

  Container buildContainer(SearchDeviceViewModel model, BuildContext context2) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Expanded(
          //   flex: 2, // 0.5 的比例
          //   child: _buildMenu(
          //     model: model,
          //     selectedValue: model.selectedInstance?.name ?? "",
          //     options: model.instanceList,
          //     onSelected: (value) {
          //       model.selectedInstance = value;
          //       model.notifyListeners();
          //     },
          //   ),
          // ),

          // InkWell(child: Text(
          //   "搜索",
          //   style: TextStyle(fontSize: 12, color: ColorUtils.colorGreenLiteLite),
          // ),onTap: model.searchEventAction,),

          // Expanded(
          //     flex: 2, // 0.5 的比例
          //     child: FComboBox<IdNameValue>(
          //         selectedValue: model.selectedInstance,
          //         items: model.instanceList,
          //         onChanged: (a) {
          //           model.selectedInstance = a;
          //           model.notifyListeners();
          //         },
          //         placeholder: "请选择实例")),
          Expanded(
            flex: 2, // 0.5 的比例
            child: Expanded(
              flex: 2, // 0.5 的比例
              child: AutoSuggestBox<IdNameValue>(
                key: model.asgbKey,
                enabled: model.searchState != DeviceSearchState.searching,
                placeholder: "请选择",
                focusNode: model.focusNode,
                controller: model.controller,
                onChanged: (text, reason) {
                  if (reason == TextChangedReason.cleared) {
                    model.selectedInstance = null;
                    model.notifyListeners();
                  }
                },
                items: model.instanceList
                    .map<AutoSuggestBoxItem<IdNameValue>>(
                      (instance) => AutoSuggestBoxItem<IdNameValue>(
                          value: instance,
                          label: instance.name ?? "",
                          onFocusChange: (focused) {
                            if (focused) debugPrint('Focused ${instance.name}');
                          },
                          onSelected: () {
                            model.selectedInstance = instance;
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
                  setState(() => model.selectedInstance = item.value);
                },
                onOverlayVisibilityChanged: (visible) {
                  debugPrint('Overlay is visible: $visible');
                  setState(() {});
                },
              ),
            ),
          ),

          const SizedBox(width: 15),
          // Expanded(
          //   flex: 1, // 0.25 的比例
          //   child: _buildMenu(
          //     model: model,
          //     selectedValue: model.selectedDoor?.name ?? '',
          //     options: model.doorList,
          //     onSelected: (value) {
          //       model.selectedDoor = value;
          //       model.notifyListeners();
          //     },
          //   ),
          // ),
          Expanded(
              flex: 1, // 0.5 的比例
              child: FComboBox<IdNameValue>(
                  selectedValue: model.selectedDoor,
                  items: model.doorList,
                  onChanged: (a) {
                    model.selectedDoor = a;
                    model.notifyListeners();
                  },
                  placeholder: "请选择大门编号")),
          const SizedBox(width: 15),
          // Expanded(
          //   flex: 1, // 0.25 的比例
          //   child: _buildMenu(
          //     model: model,
          //     selectedValue: model.selectedInOut?.name ?? '',
          //     options: model.inOutList,
          //     onSelected: (value) {
          //       model.selectedInOut = value;
          //       model.notifyListeners();
          //     },
          //   ),
          // ),
          Expanded(
              flex: 1, // 0.5 的比例
              child: FComboBox<IdNameValue>(
                  selectedValue: model.selectedInOut,
                  items: model.inOutList,
                  onChanged: (a) {
                    model.selectedInOut = a;
                    model.notifyListeners();
                  },
                  placeholder: "请选择进/出口")),
          const SizedBox(width: 15),
          TextView(
            "搜索",
            bgColor: ColorUtils.colorGreen,
            color: BaseColorUtils.white,
            textDarkOnlyOpacity: true,
            textAlign: TextAlign.center,
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, left: 24, right: 24),
            radius: 0,
            onTap: () {
              model.searchEventAction();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenu2({
    required SearchDeviceViewModel model,
    required String selectedValue,
    required List<IdNameValue> options,
    required void Function(IdNameValue) onSelected,
  }) {
    bool simpleDisabled = model.searchState == DeviceSearchState.searching;
    LogUtils.info(msg: simpleDisabled, tag: "========");
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        // 设置高度，与其他控件一致
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: "#4E5353".toColor(), // 深灰色背景
          // border: Border.all(color: Colors.grey),
          // borderRadius: BorderRadius.circular(4),
        ),
        child: PopupMenuTheme(
            data: const PopupMenuThemeData(
              color: ColorUtils.colorBlack, // 设置背景颜色
            ),
            child: PopupMenuButton<IdNameValue>(
              onSelected: onSelected,
              position: PopupMenuPosition.under,
              enabled: !simpleDisabled,
              tooltip: "",
              itemBuilder: (context) {
                return options
                    .map((option) => PopupMenuItem(
                          value: option,
                          child: SizedBox(
                            // width:  constraints.maxWidth,
                            child: Text(option.name ?? ""),
                          ),
                        ))
                    .toList();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedValue,
                      style: TextStyle(
                          color: simpleDisabled == true
                              ? ColorUtils.colorBlackLiteLite
                              : ColorUtils.colorWhite),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down,
                      color: simpleDisabled == true
                          ? ColorUtils.colorBlackLiteLite
                          : ColorUtils.colorWhite),
                ],
              ),
            )),
      );
    });
  }
}
