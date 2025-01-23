import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;
import 'package:omt/utils/color_utils.dart';

class DialogUtils {
  /// 显示内容对话框的通用方法
  static Future<String?> showContentDialog({
    required BuildContext context,
    required String title,
    required String content,
    String deleteText = '确定',
    String cancelText = '取消',
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context, '确定');
              // 这里可以增加删除逻辑
            },
            child: Text(
              deleteText,
              style: const TextStyle(
                color: ColorUtils.colorGreenLiteLite,
                fontSize: 12.0,
              ),
            ),
          ),
          Button(
            onPressed: () {
              Navigator.pop(context, '取消');
            },
            child: Text(
              cancelText,
              style: const TextStyle(
                color: ColorUtils.colorGreenLiteLite,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    required String placeholder,
    String text = "",
    String deleteText = '确定',
    String cancelText = '取消',
  }) async {
    final TextEditingController textController = TextEditingController();
    if (text.isNotEmpty){
      textController.text = text;
    }
      return await showDialog<String>(
        context: context,
        builder: (context) => ContentDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          content: SizedBox(
            height: 40,
            child: TextBox(
              placeholder: placeholder,
              controller: textController,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context, textController.text);
                // 这里可以增加删除逻辑
              },
              child: Text(
                deleteText,
                style: const TextStyle(
                  color: ColorUtils.colorGreenLiteLite,
                  fontSize: 12.0,
                ),
              ),
            ),
            Button(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: ColorUtils.colorGreenLiteLite,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      );
  }
}
