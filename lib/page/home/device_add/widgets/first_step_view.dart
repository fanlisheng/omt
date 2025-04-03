
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/views/widget/base/image_view.dart';
import '../../../../bean/common/id_name_value.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/device_add_viewmodel.dart';

class FirstStepView extends StatelessWidget {
  final DeviceAddViewModel model;

  const FirstStepView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
          color: ColorUtils.colorBackgroundLine,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "第一步：选择设备",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.colorWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 8),
              ComboBox<IdNameValue>(
                isExpanded: false,
                value: model.deviceTypeSelected,
                items: model.deviceTypes.map<ComboBoxItem<IdNameValue>>((e) {
                  return ComboBoxItem<IdNameValue>(
                    value: e,
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        e.name,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (a) {
                  model.selectedDeviceType(a);
                  model.deviceTypeSelected = a!;
                  model.notifyListeners();
                },
                placeholder: const Text(
                  "请选择设备类型",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}