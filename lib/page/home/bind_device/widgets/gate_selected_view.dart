import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:omt/utils/color_utils.dart';
import '../view_models/bind_device_viewmodel.dart';

class GateSelectedView extends StatefulWidget {
  final BindDeviceViewModel viewModel;

  const GateSelectedView({super.key, required this.viewModel});

  @override
  State<GateSelectedView> createState() => _GateSelectedViewState();
}

class _GateSelectedViewState extends State<GateSelectedView> {
  @override
  Widget build(BuildContext context) {
    BindDeviceViewModel model = widget.viewModel;
    return contentView(model);
  }

  Widget contentView(BindDeviceViewModel model) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: "#5D6666".toColor(),
          ),
        ),
        // width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 58),
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "请选择绑定信息",
              style: TextStyle(
                  fontSize: 12,
                  color: ColorUtils.colorWhite,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
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
                  "大门编号",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.colorWhite,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ComboBox<String>(
                  isExpanded: false,
                  value: model.gateNo,
                  items: model.gates.map<ComboBoxItem<String>>((e) {
                    return ComboBoxItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (color) {
                    model.gateNo = color;
                    model.notifyListeners();
                  },
                  placeholder: const Text(
                    "请选择大门编号",
                    style: TextStyle(
                        fontSize: 12, color: ColorUtils.colorBlackLiteLite),
                  ),
                ),
                // DropdownButtonFormField<String>(
                //   value: model.gateNo,
                //   items: model.gates.map<DropdownMenuItem<String>>((e) {
                //     return DropdownMenuItem<String>(
                //       value: e,
                //       child: Text(e),
                //     );
                //   }).toList(),
                //   onChanged: (color) {
                //     model.gateNo = color;
                //   },
                //   dropdownColor: ColorUtils.colorWhite,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.zero, // 去除圆角
                //     ),
                //
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
