import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/page/camera/camera_bound_delete/camera_bound_delete_view_model.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/refresh_tools.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  omt
///  camera_bound_delete_page.dart
///  已绑定矿区摄像头管理
///
///  Created by kayoxu on 2024-04-02 at 15:24:10
///  Copyright © 2024 .. All rights reserved.
///

class CameraBoundDeletePage extends StatelessWidget {
  const CameraBoundDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CameraBoundDeleteViewModel>(
        model: CameraBoundDeleteViewModel()..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return fu.ScaffoldPage(
              header: const fu.PageHeader(
                title: Text('绑定到已删除矿区摄像头'),
              ),
              content: Column(
                children: [
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      TextView('矿区').addExpanded(flex: 2),
                      TextView('名称').addExpanded(flex: 3),
                      TextView('IP').addExpanded(flex: 2),
                      TextView('ID').addExpanded(flex: 3),
                      TextView(
                        '操作',
                        alignment: Alignment.center,
                      ).addExpanded(flex: 1)
                    ],
                  ).addContainer(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      color: ColorUtils.colorCCC.dark,
                      margin: const EdgeInsets.only(top: 6, bottom: 6)),
                  RefreshUtils.init(
                          notApp: true,
                          page: model.getPageIndex(),
                          size: model.getPageSize(),
                          total: model.cameraHttpEntity?.page?.total,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              var data = model.data[index];
                              return Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? ColorUtils.colorWhite.dark
                                          : ColorUtils.transparent),
                                  child: Row(
                                    children: [
                                      TextView(
                                        data.point_name,
                                        maxLine: 3,
                                      ).addExpanded(flex: 2),
                                      TextView(
                                        data.name,
                                        maxLine: 3,
                                      ).addExpanded(flex: 3),
                                      TextView(
                                        data.ip_address,
                                        maxLine: 3,
                                      ).addExpanded(flex: 2),
                                      TextView(
                                        data.channel_info,
                                        maxLine: 3,
                                      ).addExpanded(flex: 3),
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextView(
                                          '绑定矿区',
                                          padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                              top: 4,
                                              bottom: 4),
                                          onTap: () {
                                            model.bindDevice(data);
                                          },
                                        ),
                                      ).addExpanded(flex: 1)
                                    ],
                                  ));
                            },
                            itemCount: model.data.length,
                          ),
                          controller: model.refreshController,
                          onLoad: () {
                            model.loadMore();
                          },
                          onRefresh: () {
                            model.refresh();
                          },
                          onLoadPageWithIndex: (index) {
                            model.loadDataWithPageIndex(index + 1);
                          },
                          showNoDataWidget: BaseSysUtils.empty(model.data),
                          noDataText: '')
                      .addExpanded()
                ],
              ));
        });
  }
}
