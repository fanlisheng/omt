import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:omt/test/select_detail_view_model.dart';

import '../page/home/device_add/view_models/device_add_viewmodel.dart';
import '../page/home/device_detail/view_models/device_detail_viewmodel.dart';
import '../router_utils.dart';
import '../utils/intent_utils.dart';
import '../widget/combobox.dart';

class SelectDetailPage extends StatelessWidget {
  const SelectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SelectDetailViewModel>(
        model: SelectDetailViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.ScaffoldPage.scrollable(
            header: const fu.PageHeader(
              title: Text("测试用的-选择类型 输入设备nodeId"),
            ),
            children: [
              FComboBox(
                  selectedValue:  model.selectedDeviceType,
                  items: model.deviceTypeList,
                  placeholder: "请选择实例",
                  onChanged: (a) {
                    model.selectedDeviceType = a!;
                    model.notifyListeners();
                  }),
              const SizedBox(height: 50,),
              fu.TextBox(
                placeholder: '请输入设备nodeId',
                controller: model.controller,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                // decoration: fu.WidgetStatePropertyAll(
                //     BoxDecoration(color: "#EEF6F5".toColor())),
              ),
              const SizedBox(
                height: 100,
              ),
              buttonView(title: "详情",onTap: (){
                if (model.selectedDeviceType.isNotEmpty &&
                    model.controller.text.isNotEmpty) {
                  DeviceType? deviceType =
                  model.getDeviceTypeFromName(model.selectedDeviceType);
                  if (deviceType == null) return;
                  DeviceDetailViewModel model2 = DeviceDetailViewModel(
                    deviceType: deviceType,
                    // nodeCode: '124#12812-2#2-3#1-11#0',
                    nodeId: model.controller.text,
                  );

                  // GoRouter.of(context!).push(Routes.deviceDetail, extra: model);
                  // GoRouter.of(context!).push('/navigation/navigation_view');

                  IntentUtils.share.push(context,
                      routeName: RouterPage.DeviceDetailScreen,
                      data: {"data": model2});
                }
              }),
            ],
          );
        });
  }
}
