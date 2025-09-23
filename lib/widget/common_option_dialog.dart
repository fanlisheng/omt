import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';

/// 通用选项弹窗数据模型
class DialogOption {
  final String iconPath;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const DialogOption({
    required this.iconPath,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });
}

/// 基础对话框容器
class BaseCommonDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final String? backgroundImagePath;

  const BaseCommonDialog({
    super.key,
    required this.title,
    required this.child,
    required this.width,
    required this.height,
    this.onClose,
    this.showCloseButton = true,
    this.backgroundImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      style: const ContentDialogThemeData(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          image: backgroundImagePath != null
              ? DecorationImage(
                  image: AssetImage(backgroundImagePath!),
                  fit: BoxFit.cover,
                )
              : null,
          color: backgroundImagePath == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // 标题
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // 关闭按钮
            if (showCloseButton)
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.chrome_close,
                    size: 16,
                    color: Colors.black,
                  ),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                ),
              ),

            // 内容区域
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              bottom: 0,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// 通用选项弹窗
class CommonOptionDialog extends StatelessWidget {
  final String title;
  final List<DialogOption> options;
  final double width;
  final double height;
  final String? backgroundImagePath;
  final double optionWidth;
  final double optionHeight;
  final double iconSize;
  final double spacing;

  const CommonOptionDialog({
    super.key,
    required this.title,
    required this.options,
    this.width = 460,
    this.height = 354,
    this.backgroundImagePath = 'assets/device_detail/ic_upgrade_bg.png',
    this.optionWidth = 160,
    this.optionHeight = 160,
    this.iconSize = 80,
    this.spacing = 30,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCommonDialog(
      title: title,
      width: width,
      height: height,
      backgroundImagePath: backgroundImagePath,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildOptions(),
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    List<Widget> widgets = [];
    for (int i = 0; i < options.length; i++) {
      widgets.add(_buildOption(options[i]));
      if (i < options.length - 1) {
        widgets.add(SizedBox(width: spacing));
      }
    }
    return widgets;
  }

  Widget _buildOption(DialogOption option) {
    return Clickable(
      onTap: option.onTap,
      child: Container(
        width: optionWidth,
        height: optionHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.asset(
                option.iconPath,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // 文字说明
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: option.labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 通用按钮样式
class CommonDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool hasBackground;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;

  const CommonDialogButton({
    super.key,
    required this.text,
    this.onPressed,
    this.hasBackground = true,
    this.backgroundColor,
    this.textColor,
    this.width = 110,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasBackground) {
      // 无背景样式，仅显示文字
      return Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            onPressed != null 
                ? (backgroundColor ?? "#4ECDC4".toColor()) 
                : Colors.grey,
          ),
          foregroundColor: WidgetStateProperty.all(
            textColor ?? Colors.white,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}