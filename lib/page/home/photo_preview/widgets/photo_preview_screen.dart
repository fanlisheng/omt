import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_time_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/widget/combobox.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../../../../widget/pagination/pagination_view.dart';
import '../../device_detail/widgets/detail_camera_view.dart';
import '../../photo_detail/view_models/photo_detail_viewmodel.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/photo_preview_viewmodel.dart';

class PhotoPreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<PhotoPreviewViewModel>(
        model: PhotoPreviewViewModel()..themeNotifier = true,
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
                          child: FComboBox(
                              selectedValue: model.selectedType,
                              items: model.typeList,
                              onChanged: (a) {},
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
                            );
                            if (newTime != null) {
                              model.selectedDateTime = newTime;
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
                              model.notifyListeners();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(PhotoPreviewViewModel model) {
    return Container(
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
                child: imageTimeView(model.context!,"", "日间基准照片"),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 6),
                color: "#5B6565".toColor(),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: imageTimeView(
                  model.context!,"",
                  "夜间基准照片",
                ),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 6),
                color: "#5B6565".toColor(),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
              flex: 26,
              child: PaginationGridView(
                itemWidget: Clickable(
                  child: Container(
                    child: imageTimeView(model.context!, "","背景照片",
                        rightStr: "2024-10-20 10:32"),
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 6),
                    color: "#5B6565".toColor(),
                  ),
                  onTap: () {
                    IntentUtils.share.push(model.context!,
                        routeName: RouterPage.PhotoDetailScreen);
                  },
                ),
              ))
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 28),
    );
  }
}
