import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import '../../../bean/common/id_name_value.dart';
import '../../../bean/remove/device_list_entity.dart';
import '../../../http/http_query.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/dialog_utils.dart';
import '../../../widget/combobox.dart';
import '../../home/device_add/widgets/add_camera_view.dart';

class RemoveDialogPage {
  static Future<void> showAndSubmit({
    required BuildContext context,
    required List<int> removeIds,
    required VoidCallback onSuccess,
    required String instanceId,
    int? gateId,
    int? passId,
    List<String> dismantleCauseList = const ["业主通知", "运营通知", "其它"],
  }) async {
    // 显示拆除对话框
    await showDialog(
      context: context,
      barrierDismissible: false, // 禁止点击外部关闭
      builder: (BuildContext dialogContext) {
        return RemoveDialog(
          onSubmit: (BuildContext dialogContext, String dismantleCause,
              String description) async {
            // 验证拆除原因
            if (dismantleCause.isEmpty) {
              LoadingUtils.showToast(data: "请选择拆除原因");
              return;
            } else if (dismantleCause == "其它" && description.isEmpty) {
              LoadingUtils.showToast(data: "请填写其它描述");
              return;
            }

            // 关闭对话框
            Navigator.of(dialogContext).pop();

            // 显示确认对话框
            final result = await DialogUtils.showContentDialog(
              context: context,
              title: "提交拆除设备申请",
              content: "您确定提交拆除这些设备申请,提交后等待\n审核",
              deleteText: "确定",
            );

            if (result == '确定') {
              // 提取设备 ID

              // 调用拆除设备接口
              HttpQuery.share.removeService.removeDevice(
                nodeIds: removeIds,
                instanceId: instanceId ?? "",
                gateId: gateId,
                passId: passId,
                reason: dismantleCause,
                remark: description,
                onSuccess: (data) {
                  // 重新请求数据
                  onSuccess();
                },
              );
            }
          },
        );
      },
    );
  }
}

// RemoveDialog 保持不变
class RemoveDialog extends StatefulWidget {
  final Function(BuildContext, String, String) onSubmit;

  const RemoveDialog({super.key, required this.onSubmit});

  @override
  _RemoveDialogState createState() => _RemoveDialogState();
}

class _RemoveDialogState extends State<RemoveDialog> {
  String selectedDismantleCause = "";
  List dismantleCauseList = ["业主通知", "运营通知", "其它"];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool hasText = selectedDismantleCause == "其它";
    return Dialog(
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
                  fu.TextBox(
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
                            fu.WidgetStatePropertyAll(ColorUtils.colorRed),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          "返回",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorGreenLiteLite,
                          ),
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
                            color: ColorUtils.colorGreenLiteLite,
                          ),
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
