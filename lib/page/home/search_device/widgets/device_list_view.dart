import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/page/home/search_device/view_models/search_device_viewmodel.dart';
import 'package:omt/utils/device_utils.dart';
import '../../../../utils/color_utils.dart';
import '../../../one_picture/one_picture/one_picture_page.dart';
import 'package:fluent_ui/fluent_ui.dart' as ui;

class DeviceListView extends StatefulWidget {
  final SearchDeviceViewModel viewModel;

  const DeviceListView({super.key, required this.viewModel});

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  @override
  Widget build(BuildContext context) {
    SearchDeviceViewModel model = widget.viewModel;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 8),
      decoration: BoxDecoration(
        color: ColorUtils.colorBackgroundLine,
        borderRadius: BorderRadius.circular(3),
      ),
      child: contentView(model),
    );
  }

  Widget contentView(SearchDeviceViewModel model) {
    switch (model.searchState) {
      case DeviceSearchState.notSearched:
        return noSearchStateView(model);
      case DeviceSearchState.searching:
        return searchingAndCompleted(model);
      case DeviceSearchState.completed:
        if (model.deviceScanData.isEmpty) {
          return noSearchDataView(model);
        } else {
          return searchingAndCompleted(model);
        }
      case DeviceSearchState.onePicturePage:
        return onePicturePageView(model);
    }
  }

  Container searchingAndCompleted(SearchDeviceViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "当前同一局域网下共发现 ",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorWhite,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${model.deviceScanData.length}",
                          style: const TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorGreen,
                              fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          " 个设备",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: model.searchState == DeviceSearchState.completed
                            ? 0
                            : 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value:
                                model.searchState == DeviceSearchState.completed
                                    ? 1
                                    : null,
                            // 进度值，0.5表示50%
                            backgroundColor: "#676B6B".toColor(),
                            // 进度条的背景颜色
                            valueColor: const AlwaysStoppedAnimation(
                                ColorUtils.colorGreen),
                            // 进度条的颜色
                            borderRadius: BorderRadius.circular(2.5),
                            minHeight: 5,
                          ),
                        ),
                        Visibility(
                          visible:
                              model.searchState == DeviceSearchState.completed,
                          child:
                              // Image.asset(source("home/ic_complete"),width: 20,height: 20,),
                              ImageView(
                            src: source("home/ic_complete"),
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(left: 20, bottom: 10),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              TextView(
                model.searchState == DeviceSearchState.searching
                    ? "停止扫描"
                    : "重新扫描",
                color: ColorUtils.colorGreen,
                textDarkOnlyOpacity: true,
                textAlign: TextAlign.center,
                borderWidth: 1,
                borderColor: ColorUtils.colorGreen,
                border: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 6,
                ),
                radius: 3,
                onTap: () {
                  model.searchState == DeviceSearchState.searching
                      ? model.scanStopEventAction()
                      : model.scanAnewEventAction();
                },
              ),
            ],
          ),
          const SizedBox(height: 0),
          if (model.deviceScanData.isNotEmpty) ...[
            Expanded(
              child: Container(
                // height: 186,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: "#5D6666".toColor(),
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: deviceShowList1(model.deviceScanData),
              ),
            ),
          ],
          if (model.deviceNoBindingData.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              height: 126,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: "#5D6666".toColor(),
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "以下设备未绑定大门编号",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextView(
                        "绑定",
                        bgColor: ColorUtils.colorGreen,
                        color: BaseColorUtils.white,
                        textDarkOnlyOpacity: true,
                        textAlign: TextAlign.center,
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, left: 24, right: 24),
                        margin: const EdgeInsets.only(top: 2),
                        radius: 3,
                        onTap: () {
                          model.bindEventAction();
                        },
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  Expanded(
                    child: deviceShowList1(model.deviceNoBindingData),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Container onePicturePageView(SearchDeviceViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: OnePicturePage(
              key: model.picturePageKey,
              instanceName: model.selectedInstance?.name,
              instanceId: model.selectedInstance?.id!,
              gateId: model.selectedDoor?.id,
              passId: model.selectedInOut?.id,
            ),
          ),
          if (model.deviceNoBindingData.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              height: 126,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: "#5D6666".toColor(),
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "以下设备未绑定大门编号",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorUtils.colorWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextView(
                        "绑定",
                        bgColor: ColorUtils.colorGreen,
                        color: BaseColorUtils.white,
                        textDarkOnlyOpacity: true,
                        textAlign: TextAlign.center,
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, left: 24, right: 24),
                        margin: const EdgeInsets.only(top: 2),
                        radius: 3,
                        onTap: () {
                          model.bindEventAction();
                        },
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  Expanded(
                    child: deviceShowList1(model.deviceNoBindingData),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  //没有搜索时的视图
  Widget noSearchStateView(SearchDeviceViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "您可以通过先选择实例，再扫描设备，查看同一局域网内的所选实例绑定的设备",
            style: TextStyle(
              color: Color(0xFFA7C3C2),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextView(
            "扫描设备",
            bgColor: model.selectedInstance != null
                ? ColorUtils.colorGreen
                : ColorUtils.colorGreen.withOpacity(0.2),
            color: model.selectedInstance != null
                ? BaseColorUtils.white
                : BaseColorUtils.white.withOpacity(0.2),
            textDarkOnlyOpacity: true,
            textAlign: TextAlign.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 6,
            ),
            radius: 3,
            onTap: model.selectedInstance != null
                ? () {
                    model.scanStartEventAction();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget noSearchDataView(SearchDeviceViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "暂无设备（请确认设备和本电脑使用同一网络或设备已绑定实例）",
            style: TextStyle(
              color: Color(0xFFA7C3C2),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextView(
            "扫描设备",
            bgColor: model.selectedInstance != null
                ? ColorUtils.colorGreen
                : ColorUtils.colorGreen.withOpacity(0.2),
            color: model.selectedInstance != null
                ? BaseColorUtils.white
                : BaseColorUtils.white.withOpacity(0.2),
            textDarkOnlyOpacity: true,
            textAlign: TextAlign.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 6,
            ),
            radius: 0,
            onTap: model.selectedInstance != null
                ? () {
                    model.scanStartEventAction();
                  }
                : null,
          ),
        ],
      ),
    );
  }

//显示图片
//   Widget deviceShowList1(List<DeviceEntity> deviceData) {
//     return GridView.builder(
//       padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
//       itemCount: deviceData.length, // 项目的数量
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 6, // 设置每行显示 3 个项
//         crossAxisSpacing: 10, // 列间距
//         mainAxisSpacing: 10, // 行间距
//       ),
//       itemBuilder: (context, index) {
//         return Container(
//           decoration: BoxDecoration(
//               border: Border.all(width: 1, color: "#5D6666".toColor())),
//           child: Column(
//             children: [
//               const SizedBox(height: 8),
//               Expanded(
//                 flex: 5,
//                 child: ImageView(
//                     src: source(DeviceUtils.getDeviceImage(
//                         deviceData[index].deviceType ?? 0))),
//               ),
//               SizedBox(height: 4),
//               Expanded(
//                 flex: 2,
//                 child: FittedBox(
//                   fit: BoxFit.contain,
//                   child: Text(
//                     DeviceUtils.getDeviceTypeString(
//                         deviceData[index].deviceType ?? 0),
//                     style: const TextStyle(color: ColorUtils.colorWhite),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: FittedBox(
//                   fit: BoxFit.contain,
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
//                     child: Text(
//                       deviceData[index].ip ?? "",
//                       style: const TextStyle(
//                           color: ColorUtils.colorWhite, fontSize: 10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
  Widget deviceShowList1(List<DeviceEntity> deviceData) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
        child: Wrap(
          spacing: 10, // 水平间距
          runSpacing: 10, // 垂直间距
          children: List.generate(deviceData.length, (index) {
            Color bgColor = ((deviceData[index].fault?.length ?? 0) > 0)
                ? Colors.red.withOpacity(0.1)
                : '#82FFFC'.toColor().withOpacity(0.05);
            String fault =   (deviceData[index].fault??[]).join("\n");
            return ui.Tooltip(
              message: fault,
              useMousePosition: false,
              style: const ui.TooltipThemeData(
                waitDuration: Duration(),
              ),
              child: Container(
                width: 90, // 固定宽度
                height: 76, // 固定高度
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: "#5D6666".toColor()),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(color: bgColor, spreadRadius: 1),
                  ],
                ),
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
                          style: const TextStyle(color: ColorUtils.colorWhite),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          margin:
                          const EdgeInsets.only(left: 2, right: 2, bottom: 4),
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
            );
          }),
        ),
      ),
    );
  }
}
