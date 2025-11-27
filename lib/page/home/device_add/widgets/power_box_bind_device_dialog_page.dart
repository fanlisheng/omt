import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:omt/bean/common/id_name_value.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/color_utils.dart';
import '../../../../widget/combobox.dart';

class PowerBoxBindDeviceDialogPage {
  static Future<void> showAndSubmit({
    required BuildContext context,
    required String deviceCode,
    required int dcId, // dc接口id
    required VoidCallback onSuccess,
  }) async {
    List<IdNameValue> deviceTypeList = [];
    // 显示绑定设备对话框
    await showDialog(
      context: context,
      barrierDismissible: false, // 禁止点击外部关闭
      builder: (BuildContext dialogContext) {
        return BindDeviceDialog(
          deviceCode: deviceCode,
          dcId: dcId,
          onGetDeviceTypes: (list) {
            deviceTypeList = list;
          },
          onSubmit:
              (BuildContext dialogContext, IdNameValue? deviceType1) async {
            // 验证设备类型
            if (deviceType1 == null) {
              LoadingUtils.showToast(data: "请选择设备类型");
              return;
            }

            // 关闭对话框
            Navigator.of(dialogContext).pop();

            // 调用绑定设备接口
            HttpQuery.share.homePageService.dcInterfaceBindDevice(
              deviceCode: deviceCode,
              id: dcId,
              deviceType: (deviceType1.value ?? "0").toInt(),
              onSuccess: (data) {
                // 成功后执行回调
                onSuccess();
              },
            );
          },
        );
      },
    );
  }
}

class BindDeviceDialog extends StatefulWidget {
  final String deviceCode;
  final int dcId;
  final Function(List<IdNameValue>) onGetDeviceTypes;
  final Function(BuildContext, IdNameValue?) onSubmit;

  const BindDeviceDialog(
      {super.key,
      required this.deviceCode,
      required this.dcId,
      required this.onGetDeviceTypes,
      required this.onSubmit});

  @override
  _BindDeviceDialogState createState() => _BindDeviceDialogState();
}

class _BindDeviceDialogState extends State<BindDeviceDialog> {
  IdNameValue? selectedDeviceType;
  List<IdNameValue> deviceTypeList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceTypes();
  }

  void _loadDeviceTypes() {
    HttpQuery.share.homePageService.getDcInterfaceDeviceTypeMap(
      onSuccess: (list) {
        setState(() {
          deviceTypeList = list ?? [];
          isLoading = false;
          widget.onGetDeviceTypes(deviceTypeList);
        });
      },
      onError: (error) {
        setState(() {
          isLoading = false;
        });
        LoadingUtils.showToast(data: error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(0),
        width: 500,
        height: 240,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: ColorUtils.colorBackground,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(35),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '记录运行设备',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorUtils.colorGreenLiteLite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Text(
                            "*",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorRed,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            "设备类型",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorWhite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      FComboBox<IdNameValue>(
                        selectedValue: selectedDeviceType,
                        items: deviceTypeList,
                        onChanged: (value) {
                          setState(() {
                            selectedDeviceType = value;
                          });
                        },
                        placeholder: "请选择设备类型",
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          fu.FilledButton(
                            style: const fu.ButtonStyle(
                              backgroundColor: fu.WidgetStatePropertyAll(
                                  ColorUtils.colorRed),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                "取消",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                "确认",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.colorGreenLiteLite,
                                ),
                              ),
                            ),
                            onPressed: () {
                              widget.onSubmit(context, selectedDeviceType);
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
