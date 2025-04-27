import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/bean/common/id_name_value.dart';

import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/dialog_utils.dart';
import '../../../widget/nav/dnavigation_view.dart';
import '../view_models/label_management_viewmodel.dart';

class LabelManagementScreen extends StatelessWidget {
  const LabelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<LabelManagementViewModel>(
        model: LabelManagementViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: DNavigationView(
                  title: "标签管理",
                  titlePass: "",
                  hasReturn: false,
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(LabelManagementViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              fu.FilledButton(
                style: const fu.ButtonStyle(
                    backgroundColor:
                        fu.WidgetStatePropertyAll(ColorUtils.colorGreen)),
                onPressed: () async {
                  String? result = await DialogUtils.showInputDialog(
                      context: model.context!,
                      title: "添加标签",
                      placeholder: '请输入标签的名字');
                  if (result == null || result.isEmpty) {
                    return;
                  }
                  String? result2 = await DialogUtils.showContentDialog(
                      context: model.context!,
                      title: "添加标签",
                      content: "将添加\"$result\"标签,添加后暂时只能修改不能删除,您要添加它吗？");
                  if (result2 == '确定') {
                    model.addEventAction(result);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "新增",
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.colorGreenLiteLite),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: fu.TextBox(
                  placeholder: '请输入名称',
                  controller: model.controller,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: ColorUtils.colorGreenLiteLite,
                  ),
                  placeholderStyle: const TextStyle(
                    fontSize: 12.0,
                    color: ColorUtils.colorBlackLiteLite,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              fu.FilledButton(
                style: const fu.ButtonStyle(
                    backgroundColor:
                        fu.WidgetStatePropertyAll(ColorUtils.colorGreen)),
                onPressed: () {
                  model.searchEventAction();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "搜索",
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.colorGreenLiteLite),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: ColorUtils.colorBackgroundLine,
                borderRadius: BorderRadius.circular(3),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          decoration: BoxDecoration(color: "#3B3F3F".toColor()),
                          dataRowHeight: 40,
                          headingRowHeight: 40,
                          dividerThickness: 0.01,
                          columns: const [
                            DataColumn(
                                label: Text("序列号",
                                    style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label:
                                    Text("名称", style: TextStyle(fontSize: 12))),
                            DataColumn(
                                label:
                                    Text("操作", style: TextStyle(fontSize: 12))),
                          ],
                          rows: model.dataList.asMap().keys.map((index) {
                            StrIdNameValue info = model.dataList[index];
                            return DataRow(
                                color: WidgetStateProperty.all(index % 2 == 0
                                    ? "#4E5353".toColor()
                                    : "#3B3F3F".toColor()),
                                cells: [
                                  DataCell(Text(
                                    info.id.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  DataCell(Text(
                                    info.name ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  DataCell(
                                    OutlinedButton(
                                      onPressed: () async {
                                        String? result =
                                            await DialogUtils.showInputDialog(
                                                context: model.context!,
                                                title: "修改标签",
                                                placeholder: '请输入修改标签的名字',
                                                text: info.name!);
                                        if (result != null &&
                                            result.isNotEmpty &&
                                            info.id != null) {
                                          String? result2 = await DialogUtils
                                              .showContentDialog(
                                                  context: model.context!,
                                                  title: "修改标签",
                                                  content:
                                                      "将修改\"${info.name}\"修改为\"$result\",您要修改吗");
                                          if (result2 == '确定') {
                                            model.editEventAction(info, result);
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                        minimumSize:
                                            const WidgetStatePropertyAll(
                                                Size(0, 34)),
                                        maximumSize:
                                            const WidgetStatePropertyAll(
                                                Size(80, 34)),
                                        // 高度设置为 40
                                        padding: const WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          //圆角
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        side: const WidgetStatePropertyAll(
                                            BorderSide(
                                                color: ColorUtils.colorGreen,
                                                width: 1.0)),
                                      ),
                                      child: const Text(
                                        "编辑",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorUtils.colorGreen),
                                      ),
                                    ),
                                  ),
                                ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                '共',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                model.dataList.length.toString(),
                style: const TextStyle(
                  color: ColorUtils.colorGreen,
                ),
              ),
              const Text(
                '条',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
