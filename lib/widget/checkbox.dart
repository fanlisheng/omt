import 'package:fluent_ui/fluent_ui.dart';

import '../utils/color_utils.dart';

class FCheckbox extends StatelessWidget {
  final bool checked;
  final String label;
  final TextStyle? textStyle;

  final Color checkedColor;
  final Color uncheckedBorderColor;
  final BorderRadius? borderRadius;
  final ValueChanged<bool> onChanged;

  const FCheckbox({
    super.key,
    required this.checked,
    required this.label,
    this.checkedColor = ColorUtils.colorGreen,
    this.uncheckedBorderColor = ColorUtils.colorGreenLite,
    required this.onChanged,
    this.textStyle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checked: checked,
      content: Text(
        label,
        style: textStyle ??
            const TextStyle(
              fontSize: 12,
              color: ColorUtils.colorGreenLiteLite,
            ),
      ),
      style: CheckboxThemeData(
        checkedDecoration: WidgetStateProperty.all(
          BoxDecoration(
            color: checkedColor,
            borderRadius: borderRadius ?? BorderRadius.circular(2),
          ),
        ),
        uncheckedDecoration: WidgetStateProperty.all(
          BoxDecoration(
            border: Border.all(
              width: 1,
              color: uncheckedBorderColor,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(2),
          ),
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
