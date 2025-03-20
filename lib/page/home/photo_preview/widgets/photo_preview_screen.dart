import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_time_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:kayo_package/views/widget/base/image_view.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/widget/combobox.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../../../../widget/pagination/image_display_page.dart';
import '../../../../widget/pagination/pagination_view.dart';
import '../../device_detail/widgets/detail_camera_view.dart';
import '../../photo_detail/view_models/photo_detail_viewmodel.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/photo_preview_viewmodel.dart';

class PhotoPreviewScreenData {
  final String deviceCode;
  DeviceDetailCameraDataPhoto? dayBasicPhoto;
  DeviceDetailCameraDataPhoto? nightBasicPhoto;

  PhotoPreviewScreenData(
      {required this.deviceCode,
      required this.dayBasicPhoto,
      required this.nightBasicPhoto});
}

class PhotoPreviewScreen extends StatelessWidget {
  final PhotoPreviewScreenData photoPreviewScreenData;

  PhotoPreviewScreen({required this.photoPreviewScreenData, super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<PhotoPreviewViewModel>(
        model: PhotoPreviewViewModel(photoPreviewScreenData)
          ..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: ScaffoldPage(
              header: PageHeader(
                title: DNavigationView(
                  title: "照片预览",
                  titlePass: "首页 / 摄像头 / ",
                  rightWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 120,
                          child: FComboBox<String>(
                              selectedValue: model.selectedType,
                              items: model.typeList,
                              onChanged: (String? a) async {
                                model.selectedType = a ?? "";
                                model.gridViewKey.currentState
                                    ?.loadData(refresh: true);
                                model.notifyListeners();
                              }, //
                              placeholder: "照片类型"),
                        ),
                        const SizedBox(width: 12),
                        Clickable(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1)),
                              color: "#5E6363".toColor(),
                            ),
                            width: 34,
                            height: 34,
                            child: const Icon(FluentIcons.chevron_left,
                                size: 12.0),
                          ),
                          onTap: () {
                            model.selectedDateTime = model.selectedDateTime
                                .subtract(const Duration(days: 1));
                            model.gridViewKey.currentState
                                ?.loadData(refresh: true);
                            model.notifyListeners();
                          },
                        ),
                        const SizedBox(width: 4),
                        Clickable(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1)),
                              color: "#5E6363".toColor(),
                            ),
                            height: 34,
                            child: Row(
                              children: [
                                Text(
                                  model.selectedDateTime.toTimeStr(
                                      format: BaseTimeUtils.formatYMD),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.colorGreenLiteLite),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Icon(FluentIcons.date_time, size: 16.0),
                              ],
                            ),
                          ),
                          onTap: () async {
                            final newTime = await showDatePicker(
                              context: context,
                              initialDate: model.selectedDateTime,
                              firstDate:
                                  DateTime(model.selectedDateTime.year - 100),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Container(
                                  color: ColorUtils.colorBlack,
                                  child: child,
                                );
                              },
                            );
                            if (newTime != null) {
                              model.selectedDateTime = newTime;
                              model.gridViewKey.currentState
                                  ?.loadData(refresh: true);
                              model.notifyListeners();
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                        Clickable(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1)),
                              color: "#5E6363".toColor(),
                            ),
                            width: 34,
                            height: 34,
                            child: const Icon(FluentIcons.chevron_right,
                                size: 12.0),
                          ),
                          onTap: () {
                            DateTime tomorrow = model.selectedDateTime
                                .add(const Duration(days: 1));
                            if (tomorrow.day <= DateTime.now().day) {
                              model.selectedDateTime = tomorrow;
                              model.gridViewKey.currentState
                                  ?.loadData(refresh: true);
                              model.notifyListeners();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  onTap: model.isSetBasicPhoto
                      ? () {
                          IntentUtils.share.popResultOk(context);
                        }
                      : null,
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(PhotoPreviewViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          // Expanded(flex:10,child: ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 7, bottom: 6),
                color: "#5B6565".toColor(),
                child: imageTimeView(
                    model.context!,
                    model.photoPreviewScreenData.dayBasicPhoto?.url,
                    "日间基准照片", onTap: () {
                  ImageUtils.share.showBigImg(
                    model.context!,
                    url: ImageUtils.share.getImageUrl(
                      url: model.photoPreviewScreenData.dayBasicPhoto?.url,
                    ),
                  );
                }),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 7, bottom: 6),
                color: "#5B6565".toColor(),
                child: imageTimeView(
                    model.context!,
                    model.photoPreviewScreenData.nightBasicPhoto?.url,
                    "夜间基准照片", onTap: () {
                  ImageUtils.share.showBigImg(
                    model.context!,
                    url: ImageUtils.share.getImageUrl(
                      url: model.photoPreviewScreenData.nightBasicPhoto?.url,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            flex: 26,
            child:
                // ImageDisplayPage<DeviceDetailCameraDataPhoto>(
                //
                //   fetchData: (page ,index){
                //     return model.fetchData(page,index);
                //   },
                //   // onDataReloaded: (page , index){
                //   //
                //   // },
                //   itemWidgetBuilder: (c, item) {
                //     // 使用自定义的 Widget 来展示图片
                //     return Clickable(
                //       child: Container(
                //         padding: const EdgeInsets.only(
                //             left: 10, right: 10, top: 7, bottom: 6),
                //         color: "#5B6565".toColor(),
                //         child: imageTimeView(c, item.url, item.typeText ?? "",
                //             rightStr: item.snapAt),
                //       ),
                //       onTap: () {
                //         IntentUtils.share
                //             .push(c, routeName: RouterPage.PhotoDetailScreen);
                //       },
                //     );
                //   },
                // ),
                PaginationGridView<DeviceDetailCameraDataPhoto>(
              // items: model.photoData,
              key: model.gridViewKey,
              fetchData: model.fetchData,
              itemWidgetBuilder: (c, index, item) {
                bool isZP = (item.typeText ?? "").contains("抓拍");
                return Clickable(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 7, bottom: 6),
                    decoration: BoxDecoration(
                      border: isZP
                          ? Border.all(color: ColorUtils.colorGreen, width: 2)
                          : null,
                      color: "#5B6565".toColor(),
                    ),
                    child: imageTimeView(c, item.url, item.typeText ?? "",
                        rightStr: item.snapAt),
                  ),
                  onTap: () {
                    model.clickPhotoWith(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget imageTimeView(BuildContext context, String? url, String leftStr,
      {String? rightStr, GestureTapCallback? onTap}) {
    bool isZP = leftStr.contains("抓拍");
    final screenSize = MediaQuery.of(context).size;
    return Clickable(
      // color: "#5B6565".toColor(),
      width: 234 / (1050 - 160) * screenSize.width,
      // width: 234 ,
      height: screenSize.height * 0.43 / 2,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: (url ?? "").isNotEmpty
                ? ImageView(
                    url: url,
                    // src: source(''),
                    // width: 234,
                    // height: 131,
                  )
                : const Center(
                    child: Text(
                      "没有照片",
                      style: TextStyle(
                          fontSize: 12, color: ColorUtils.colorGreenLiteLite),
                    ),
                  ),
          ),
          // Container(
          //   width: 234 / (1050 - 160) * screenSize.width,
          //   // width: 234 ,
          //   color: ColorUtils.colorGreenLiteLite,
          // ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  leftStr,
                  style: TextStyle(
                      fontSize: 12,
                      color: (isZP
                          ? ColorUtils.colorGreen
                          : ColorUtils.colorGreenLiteLite)),
                ),
              ),
              Text(
                rightStr ?? "",
                style: const TextStyle(
                    fontSize: 12, color: ColorUtils.colorGreenLiteLite),
              ),
            ],
          )
        ],
      ),
    );
  }
}
