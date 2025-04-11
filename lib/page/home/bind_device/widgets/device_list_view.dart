import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/utils/base_color_utils.dart';
import 'package:kayo_package/views/widget/base/image_view.dart';
import 'package:kayo_package/views/widget/base/text_view.dart';
import '../../../../bean/home/home_page/device_entity.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/device_utils.dart';
import '../view_models/bind_device_viewmodel.dart';

class DeviceListView extends StatefulWidget {
  final BindDeviceViewModel viewModel;

  const DeviceListView({super.key, required this.viewModel});

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  @override
  Widget build(BuildContext context) {
    BindDeviceViewModel model = widget.viewModel;
    return contentView(model);
  }

  Container contentView(BindDeviceViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: "#5D6666".toColor(),
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            height: 128,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "请选择绑定设备",
                        style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Checkbox(
                        checked: model.selected,
                        content: const Text(
                          '全选设备',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.colorWhite,
                          ),
                        ),
                        onChanged: (a) {
                          model.selectedAllEventAction(a);
                        }),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 0),
                Expanded(
                  child: deviceShowList2(model.deviceData, onTap: (index) {
                    model.selectedItemEventAction(index);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//显示图片
Widget deviceShowList2(
  List<DeviceEntity> deviceData, {
  Function(int)? onTap,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
    child: Wrap(
      spacing: 10, // 水平间距
      runSpacing: 10, // 垂直间距
      children: List.generate(deviceData.length, (index) {
        return Clickable(
          onTap: onTap != null
              ? () {
                  onTap(index);
                }
              : null,
          child: Container(
            width: 90, // 固定宽度
            height: 76, // 固定高度
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: deviceData[index].selected == true
                    ? ColorUtils.colorGreen
                    : "#5D6666".toColor(),
              ),
              borderRadius: BorderRadius.circular(3),
              color: deviceData[index].selected == true
                  ? "#5D6666".toColor()
                  : ColorUtils.transparent,
              boxShadow: [
                BoxShadow(
                  color: '#82FFFC'.toColor(opacity: .05),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Expanded(
                        flex: 5,
                        child: ImageView(
                          src: source(DeviceUtils.getDeviceImage(
                              deviceData[index].deviceType ?? 0)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            DeviceUtils.getDeviceTypeString(
                                deviceData[index].deviceType ?? 0),
                            style:
                                const TextStyle(color: ColorUtils.colorWhite),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 2, right: 2, bottom: 4),
                            child: Text(
                              deviceData[index].ip ?? "",
                              style: const TextStyle(
                                  color: ColorUtils.colorWhite, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: deviceData[index].selected ?? false,
                  child: Positioned(
                    top: 2,
                    right: 2,
                    width: 16,
                    height: 16,
                    child: ImageView(
                      src: source("home/ic_device_selected"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}
