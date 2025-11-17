import 'package:fluent_ui/fluent_ui.dart';
import '../../../widget/common_option_dialog.dart';

/// 通用结果弹窗
class ResultDialog {
  /// 显示结果弹窗
  static Future<void> show({
    required BuildContext context,
    required bool isSuccess,
    required String title,
    required String message,
    required String buttonText,
    VoidCallback? onButtonPressed,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BaseCommonDialog(
          title: title,
          width: 460,
          height: isSuccess ? 300 : 260,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: isSuccess ? 14 : 14,
                    color: isSuccess
                        ? const Color(0xFF678384)
                        : const Color(0xFF666666),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onButtonPressed?.call();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFF4ECDC4)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      onDismiss?.call();
    });
  }

  /// 显示成功弹窗
  static Future<void> showSuccess({
    required BuildContext context,
    String title = "删除申请提交成功！",
    String message =
        "您的拆除申请已成功提交，需等待后台审核，审核通过后，设备将正式完成拆除，请耐心等待。\n如有紧急情况，可联系负责该区域的运营人员协助处理。",
    String buttonText = "知道了",
    VoidCallback? onButtonPressed,
    VoidCallback? onDismiss,
  }) {
    return show(
      context: context,
      isSuccess: true,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      onDismiss: onDismiss,
    );
  }

  /// 显示失败弹窗
  static Future<void> showError({
    required BuildContext context,
    String title = "删除申请提交失败！",
    String message = "失败了，请尝试重新提交或联系工作人员",
    String buttonText = "重新提交",
    VoidCallback? onButtonPressed,
    VoidCallback? onDismiss,
  }) {
    return show(
      context: context,
      isSuccess: false,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      onDismiss: onDismiss,
    );
  }

  /// 测试弹窗 - 可以在外面直接调用测试
  static void testDialogs(BuildContext context) {
    // 测试成功弹窗
    showSuccess(
      context: context,
      onDismiss: () {
        // 成功弹窗关闭后，延迟1秒显示失败弹窗
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            showError(context: context);
          }
        });
      },
    );
  }
}
