import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';

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
    return buildContainer(model);
  }

  Container buildContainer(SearchDeviceViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, // 0.5 的比例
            child: _buildMenu(
              model: model,
              selectedValue: model.selectedExample,
              options: ['实例1', '实例2', '实例3'],
              onSelected: (value) {
                model.selectedExample = value;
                model.notifyListeners();
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 1, // 0.25 的比例
            child: _buildMenu(
              model: model,
              selectedValue: model.selectedDoor,
              options: ['大门1', '大门2', '大门3'],
              onSelected: (value) {
                model.selectedDoor = value;
                model.notifyListeners();
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 1, // 0.25 的比例
            child: _buildMenu(
              model: model,
              selectedValue: model.selectedInOut,
              options: ['进', '出'],
              onSelected: (value) {
                model.selectedInOut = value;
                model.notifyListeners();
              },
            ),
          ),
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
          )
        ],
      ),
    );
  }
  Widget _buildMenu({
    required SearchDeviceViewModel model,
    required String selectedValue,
    required List<String> options,
    required void Function(String) onSelected,
  }) {
    bool simpleDisabled = model.searchState != DeviceSearchState.completed;
    LogUtils.info(msg: simpleDisabled,tag:  "========");
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
          child: PopupMenuButton<String>(
            onSelected: onSelected,
            position: PopupMenuPosition.under,
            enabled:  !simpleDisabled,
            tooltip: "",
            itemBuilder: (context) {
              return options
                  .map((option) => PopupMenuItem(
                value: option,
                child: SizedBox(
                  // width:  constraints.maxWidth,
                  child: Text(option),
                ),
              ))
                  .toList();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue,
                    style: TextStyle(color: simpleDisabled == true ?  ColorUtils.colorBlackLiteLite : ColorUtils.colorWhite),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                 Icon(Icons.arrow_drop_down, color: simpleDisabled == true ?  ColorUtils.colorBlackLiteLite : ColorUtils.colorWhite),
              ],
            ),
          ));
    });
  }
}


