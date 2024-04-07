import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/utils/_index_utils.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/page/pager_indicator_item.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshUtils {
  static Widget init(
      {required Widget child,
      required bool showNoDataWidget,
      String noDataMsg = '没有数据',
      Widget? noDataWidget,
      String? noDataText,
      bool enableRefresh = true,
      bool enableLoad = true,
      required RefreshController controller,
      Function()? onRefresh,
      Function()? onLoad,
      ValueChanged<int>? onLoadPageWithIndex,
      bool? notApp = false,
      int page = 1,
      int size = 20,
      int? total,
      Color bgColor = ColorUtils.colorWhite,
      bool lightText = false}) {
    if (notApp == true && null != total) {
      return Column(
        children: [
          child.addExpanded(),
          TablePagerIndicator(
            totalCount: total,
            pageEach: size,
            callback: (int totalPages, int currentPageIndex) {
              onLoadPageWithIndex?.call(currentPageIndex);
            },
          )
        ],
      );
    }

    return SmartRefresher(
      header: const WaterDropMaterialHeader(),
      footer: ClassicFooter(
        textStyle: TextStyle(color: lightText ? Colors.white : Colors.grey),
        failedIcon:
            Icon(Icons.error, color: lightText ? Colors.white : Colors.grey),
        canLoadingIcon: Icon(Icons.autorenew,
            color: lightText ? Colors.white : Colors.grey),
        idleIcon: Icon(Icons.arrow_upward,
            color: lightText ? Colors.white : Colors.grey),
        loadingIcon: const SizedBox(
            width: 25.0, height: 25.0, child: CupertinoActivityIndicator()),
        idleText: '上拉加载更多',
        canLoadingText: '释放以加载更多',
        failedText: '加载失败',
        loadingText: '加载中...',
        noDataText: noDataText ?? '没有更多数据了',
      ),
      enablePullDown: enableRefresh,
      enablePullUp: enableLoad,
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoad,
      child: showNoDataWidget
          ? ListView(
              children: [
                (noDataWidget ??
                    BaseViewUtils.noData(
                        marginImageTop: 12,
                        msg: noDataMsg,
                        width: 220,
                        height: 150,
                        msgColor: ColorUtils.colorBlackLite,
                        margin: const EdgeInsets.only(top: 120)))
              ],
            )
          : child,
    );
  }

  static hideRefresh(
      {required RefreshController? controller,
      required bool refresh,
      required int dataSize,
      required int pageSize}) {
    if (refresh) {
      controller?.refreshCompleted();
    } else {
      LoadingUtils.showInfo(
          data: dataSize < 1 ? '没有更多数据了' : '上拉加载了$dataSize条数据');
    }
    controller?.loadComplete();
    if (dataSize < 1 || dataSize < pageSize) controller?.loadNoData();
  }

  static hideRefreshSimple({
    required RefreshController? controller,
  }) {
    controller?.refreshCompleted();
    controller?.loadComplete();
  }

  static firstLoading(
      {required RefreshController? controller, Function()? loadData}) {
    try {
      if (null != controller) {
        controller.requestRefresh();
      }
    } catch (e) {
      print(e);
      loadData?.call();
    }
  }
}
