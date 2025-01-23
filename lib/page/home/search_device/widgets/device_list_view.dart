import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/page/home/search_device/view_models/search_device_viewmodel.dart';
import '../../../../utils/color_utils.dart';

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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      color: ColorUtils.colorBackgroundLine,
      child: contentView(model),
    );
  }

  Widget contentView(SearchDeviceViewModel model) {
    switch (model.searchState) {
      case DeviceSearchState.notSearched:
        return noSearchStateView(model);
      case DeviceSearchState.searching:
      case DeviceSearchState.completed:
        return searchingAndCompleted(model);
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: model.scanRateValue == 1 ? 1 : null,
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
                          visible: model.scanRateValue == 1.0,
                          child: ImageView(
                            src: source("home/ic_complete"),
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 15, left: 20),
                          ),
                        )
                      ],
                    )
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
                radius: 0,
                onTap: () {
                  model.searchState == DeviceSearchState.searching
                      ? model.scanStopEventAction()
                      : model.scanAnewEventAction();
                },
              ),
            ],
          ),
          const SizedBox(height: 0),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: "#5D6666".toColor())),
              child: deviceShowList1(model.deviceScanData),
            ),
          ),
          if(model.deviceNoBindingData.isNotEmpty)...[
            const SizedBox(height: 10),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: "#5D6666".toColor())),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
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
                          radius: 0,
                          onTap: () {
                            model.bindEventAction();
                          },
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: deviceShowList1(model.deviceNoBindingData),
                    ),
                  ],
                ),
              ),
            )
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
            "您可以通过选择实例或扫描设备查看同一局域网内的设备",
            style: TextStyle(
              color: Color(0xFFA7C3C2),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextView(
            "扫描设备",
            bgColor: ColorUtils.colorGreen,
            color: BaseColorUtils.white,
            textDarkOnlyOpacity: true,
            textAlign: TextAlign.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 6,
            ),
            radius: 0,
            onTap: () {
              model.scanStartEventAction();
            },
          ),
        ],
      ),
    );
  }
//显示图片
  Widget deviceShowList1(List<DeviceEntity> deviceData) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
      itemCount: deviceData.length, // 项目的数量
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 设置每行显示 3 个项
        crossAxisSpacing: 10, // 列间距
        mainAxisSpacing: 10, // 行间距
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: "#5D6666".toColor())),
          child: Column(
            children: [
              SizedBox(height: 8),
              Expanded(
                flex: 5,
                child: ImageView(src: source('home/ic_device')),
              ),
              SizedBox(height: 4),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    deviceData[index].deviceTypeText ?? "-",
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
                    margin: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
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
        );
      },
    );
  }
}


