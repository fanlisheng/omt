import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:omt/utils/color_utils.dart';

class FComboBox<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String placeholder;
  final TextStyle? itemStyle;
  final TextStyle? placeholderStyle;

  const FComboBox({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.placeholder,
    this.itemStyle,
    this.placeholderStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ComboBox<T>(
      isExpanded: true,
      value: selectedValue,
      items: items
          .map<ComboBoxItem<T>>(
            (item) => ComboBoxItem<T>(
              value: item,
              child: Text(
                item.toString(),
                textAlign: TextAlign.start,
                style: itemStyle ??
                    const TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorGreenLiteLite,
                    ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      placeholder: Text(
        placeholder,
        textAlign: TextAlign.start,
        style: placeholderStyle ??
            const TextStyle(
              fontSize: 12,
              color: ColorUtils.colorBlackLiteLite,
            ),
      ),
    );
  }
}
