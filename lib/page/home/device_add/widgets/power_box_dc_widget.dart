import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:omt/page/home/device_add/widgets/power_box_bind_device_dialog_page.dart';

import '../../../../bean/home/home_page/device_detail_power_box_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/color_utils.dart';

class PowerBoxDcWidget {
  static Widget buildPowerBoxDcContainer({
    required List<DeviceDetailPowerBoxDataDcInterfaces>? dcInterfaces,
    required String deviceCode,
    required BuildContext context,
    Function(DeviceDetailPowerBoxDataDcInterfaces)? onOpenDcSuccess,
    Function(DeviceDetailPowerBoxDataDcInterfaces)? onRecordSuccess,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "电源箱DC接口信息",
          style: TextStyle(
            fontSize: 14,
            color: ColorUtils.colorGreenLiteLite,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            decoration: BoxDecoration(
              color: "#3B3F3F".toColor(),
              borderRadius: BorderRadius.circular(3),
            ),
            dataRowHeight: 40,
            headingRowHeight: 40,
            dividerThickness: 0.01,
            columns: const [
              DataColumn(label: Text("DC", style: TextStyle(fontSize: 12))),
              DataColumn(label: Text("状态", style: TextStyle(fontSize: 12))),
              DataColumn(label: Text("电压", style: TextStyle(fontSize: 12))),
              DataColumn(label: Text("电流", style: TextStyle(fontSize: 12))),
              DataColumn(label: Text("运行设备", style: TextStyle(fontSize: 12))),
              DataColumn(label: Text("操作", style: TextStyle(fontSize: 12))),
            ],
            rows: (dcInterfaces ?? []).asMap().keys.map((index) {
              DeviceDetailPowerBoxDataDcInterfaces info = dcInterfaces![index];
              return DataRow(
                color: WidgetStateProperty.all(
                  index % 2 == 0 ? "#4E5353".toColor() : "#3B3F3F".toColor(),
                ),
                cells: [
                  DataCell(
                    Text(
                      (info.interfaceNum ?? 0).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      info.statusText ?? "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      (info.voltage ?? 0).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      (info.current ?? 0).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      info.connectDevice ?? "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            openDcAction(
                              deviceCode: deviceCode,
                              info: info,
                              onSuccess: onOpenDcSuccess,
                            );
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: -20, horizontal: 10),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            side: const WidgetStatePropertyAll(
                              BorderSide(
                                color: ColorUtils.colorRed,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            info.statusText == "关闭" ? "打开" : "关闭",
                            style: TextStyle(
                              fontSize: 12,
                              color: info.statusText == "关闭"
                                  ? ColorUtils.colorGreen
                                  : ColorUtils.colorRed,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            recordDeviceAction(
                              context: context,
                              deviceCode: deviceCode,
                              info: info,
                              onSuccess: onRecordSuccess,
                            );
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            side: const WidgetStatePropertyAll(
                              BorderSide(
                                color: ColorUtils.colorRed,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            "记录",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  static void openDcAction({
    required String deviceCode,
    required DeviceDetailPowerBoxDataDcInterfaces info,
    Function(DeviceDetailPowerBoxDataDcInterfaces)? onSuccess,
  }) {
    HttpQuery.share.homePageService.dcInterfaceControl(
      deviceCode: deviceCode,
      ids: [info.id ?? 0],
      status: info.statusText == "打开" ? 1 : 2,
      onSuccess: (data) {
        LoadingUtils.show(
            data: "${(info.statusText == "打开") ? "关闭" : "打开"}成功!");
        onSuccess?.call(info);
      },
    );
  }

  static void recordDeviceAction({
    required BuildContext context,
    required String deviceCode,
    required DeviceDetailPowerBoxDataDcInterfaces info,
    Function(DeviceDetailPowerBoxDataDcInterfaces)? onSuccess,
  }) {
    PowerBoxBindDeviceDialogPage.showAndSubmit(
      context: context,
      deviceCode: deviceCode,
      dcId: info.id ?? 0,
      onSuccess: () {
        LoadingUtils.show(data: "记录成功!");
        onSuccess?.call(info);
      },
    );
  }
}
