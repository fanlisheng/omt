import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/theme.dart';
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
  final double? height;
  final Widget? icon; // ✅ 新增：自定义下拉图标

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
    this.height,
    this.icon, // 接收外部传入图标
  });

  String _getDisplayText(T item) {
    if (item is IdNameValue) {
      return item.name ?? "";
    }
    return item.toString();
  }

  // 根据内容查找匹配的项目
  T? _findMatchingItem() {
    if (selectedValue == null) return null;
    
    // 如果是IdNameValue类型，根据name进行匹配
    if (selectedValue is IdNameValue) {
      final selectedName = (selectedValue as IdNameValue).name;
      for (var item in items) {
        if (item is IdNameValue && item.name == selectedName) {
          return item;
        }
      }
    }
    
    // 其他类型直接返回selectedValue
    return selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 35,
      decoration: BoxDecoration(
        color: bgColor ?? ColorUtils.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ui.ComboBox<T>(
        isExpanded: true,
        value: _findMatchingItem(),
        icon: icon ?? const Icon(ui.FluentIcons.chevron_down), // 默认图标
        items: items
            .map<ui.ComboBoxItem<T>>(
              (item) => ui.ComboBoxItem<T>(
                value: item,
                child: Text(
                  _getDisplayText(item),
                  textAlign: TextAlign.start,
                  style: itemStyle ??
                      const TextStyle(
                        fontSize: 12,
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
                color: ColorUtils.colorBlackLiteLite,
              ),
        ),
      ),
    );
  }
}

class MultiSelectComboBox extends StatefulWidget {
  final List<StrIdNameValue> availableTags; // 可选标签列表
  final List<StrIdNameValue> initialSelectedTags; // 初始已选标签
  final String placeholder; // Placeholder 文本
  final ValueChanged<List<StrIdNameValue>>? onSelectionChanged; // 选中项变化时回调

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
  late List<StrIdNameValue> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.initialSelectedTags);
  }

  @override
  void didUpdateWidget(MultiSelectComboBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部传入的initialSelectedTags发生变化时，更新内部状态
    if (widget.initialSelectedTags != oldWidget.initialSelectedTags) {
      _selectedTags = List.from(widget.initialSelectedTags);
    }
  }

  void _handleTagSelection(StrIdNameValue? selectedTag) {
    if (selectedTag != null && !_selectedTags.contains(selectedTag)) {
      setState(() {
        _selectedTags.add(selectedTag);
      });
      widget.onSelectionChanged?.call(_selectedTags);
    }
  }

  void _handleTagDeletion(StrIdNameValue tag) {
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
        ui.ComboBox<StrIdNameValue>(
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
            return ui.ComboBoxItem<StrIdNameValue>(
              value: tag,
              child: Text(tag.name ?? ""),
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
                          tag.name ?? "",
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
