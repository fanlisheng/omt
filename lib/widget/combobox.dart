import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';

class FComboBox<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String placeholder;
  final TextStyle? itemStyle;
  final TextStyle? placeholderStyle;
  final Color? bgColor;
  final bool disabled;

  const FComboBox({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.placeholder,
    this.itemStyle,
    this.placeholderStyle,
    this.bgColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: bgColor ?? ColorUtils.transparent, // 动态设置背景颜色
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: ui.ComboBox<T>(
          isExpanded: true,
          value: selectedValue,
          items: items
              .map<ui.ComboBoxItem<T>>(
                (item) => ui.ComboBoxItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    textAlign: TextAlign.start,
                    style: itemStyle ??
                        const TextStyle(
                          fontSize: 12,
                          // color: ColorUtils.colorGreenLiteLite,
                        ),
                  ),
                ),
              )
              .toList(),
          onChanged: disabled ? null : onChanged,
          placeholder: Text(
            placeholder,
            textAlign: TextAlign.start,
            style: placeholderStyle ??
                const TextStyle(
                  fontSize: 12,
                  // color: ColorUtils.colorBlackLiteLite,
                ),
          ),
        ));
  }
}

class MultiSelectComboBox extends StatefulWidget {
  final List<String> availableTags; // 可选标签列表
  final List<String> initialSelectedTags; // 初始已选标签
  final String placeholder; // Placeholder 文本
  final ValueChanged<List<String>>? onSelectionChanged; // 选中项变化时回调

  const MultiSelectComboBox({
    super.key,
    required this.availableTags,
    this.initialSelectedTags = const [],
    this.placeholder = "请选择",
    this.onSelectionChanged,
  });

  @override
  _MultiSelectComboBoxState createState() => _MultiSelectComboBoxState();
}

class _MultiSelectComboBoxState extends State<MultiSelectComboBox> {
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.initialSelectedTags);
  }

  void _handleTagSelection(String? selectedTag) {
    if (selectedTag != null && !_selectedTags.contains(selectedTag)) {
      setState(() {
        _selectedTags.add(selectedTag);
      });
      widget.onSelectionChanged?.call(_selectedTags);
    }
  }

  void _handleTagDeletion(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
    widget.onSelectionChanged?.call(_selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ComboBox
        ui.ComboBox<String>(
          isExpanded: true,
          placeholder: (_selectedTags.isEmpty)
              ? Text(
                  widget.placeholder,
                  style: const TextStyle(
                      fontSize: 12, color: ColorUtils.colorGreenLiteLite),
                )
              : null,
          value: null,
          items: widget.availableTags.map((tag) {
            return ui.ComboBoxItem<String>(
              value: tag,
              child: Text(tag),
            );
          }).toList(),
          onChanged: _handleTagSelection,
        ),
        // 显示已选标签的 Wrap
        Positioned(
          left: 0,
          right: 40,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: false, // 不拦截点击事件，允许 ComboBox 功能正常
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _selectedTags.map((tag) {
                  // return Chip(
                  //   label: Text(tag),
                  //   deleteIcon: Icon(Icons.close),
                  //   onDeleted: () => _handleTagDeletion(tag),
                  // );
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        border:
                            Border.all(color: ColorUtils.colorGreenLiteLite)),
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: const TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorGreenLiteLite),
                        ),
                        const SizedBox(width: 3),
                        InkWell(
                          child: const Icon(Icons.close),
                          onTap: () {
                            _handleTagDeletion(tag);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
