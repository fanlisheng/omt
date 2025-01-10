import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/checkbox.dart';
import '../view_models/device_add_viewmodel.dart';

class AddPowerView extends StatefulWidget {
  final DeviceAddViewModel viewModel;

  const AddPowerView({super.key, required this.viewModel});

  @override
  State<AddPowerView> createState() => _AddPowerViewState();
}

class _AddPowerViewState extends State<AddPowerView> {
  @override
  Widget build(BuildContext context) {
    DeviceAddViewModel model = widget.viewModel;
    return contentView(model);
  }

  Widget contentView(DeviceAddViewModel model) {
    return Expanded(
      child: Container(
        // width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 58),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "添加电源信息",
              style: TextStyle(
                  fontSize: 12,
                  color: ColorUtils.colorWhite,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  "*",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorRed,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 2),
                Text(
                  "进/出口",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ComboBox<String>(
                  isExpanded: false,
                  value: model.portType,
                  items: model.portTypes.map<ComboBoxItem<String>>((e) {
                    return ComboBoxItem<String>(
                      value: e,
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          e,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (a) {
                    model.portType = a!;
                    model.notifyListeners();
                  },
                  placeholder: const Text(
                    "请选择进/出口",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            DashLine(
              color: "#5D6666".toColor(),
              height: 1,
              width: double.infinity,
            ),
            const SizedBox(height: 30),
            const Row(

              children: [
                Text(
                  "*",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorRed,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 2),
                Text(
                  "进/出口",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 30.0,
              children: [
                FCheckbox(
                  checked: model.batteryMains,
                  label: '市电',
                  onChanged: (isChecked) {
                    model.batteryMains = isChecked;
                    model.notifyListeners();
                  },
                ),
                FCheckbox(
                  checked: model.battery,
                  label: '电池',
                  onChanged: (isChecked) {
                    model.battery = isChecked;
                    model.notifyListeners();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
