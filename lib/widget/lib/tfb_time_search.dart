
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/intent_utils.dart';

///
///  tfblue_app
///  tfb_radio.dart
///
///  Created by kayoxu on 2021/10/8 at 3:42 下午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class TfbTimeSearch extends StatefulWidget {
  final double? width;
  final EdgeInsets? margin;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? timeFormat; // = 'yyyy-MM-dd HH:mm:ss',
  final String? timeShowFormat; // = 'MM.dd',
  final String? timeDivide; // = '-',
  final String? keywords;
  final String? hintTime;
  final String? hintSearch;
  final Function()? onTapTime;
  final Function()? onTapSearch;
  final OnDateTimePick? onDateTimePick;
  final ValueChanged<String?>? onSearchPick;
  final ValueChanged<IdNameValue?>? onAreaPick;
  final bool? showTime;
  final bool? showArea;
  final bool? showSearch;
  final IdNameValue? area;

  const TfbTimeSearch(
      {super.key,
      this.width,
      this.margin,
      this.startTime,
      this.endTime,
      this.timeFormat = 'yyyy-MM-dd',
      this.timeShowFormat = 'MM.dd',
      this.timeDivide = '-',
      this.keywords,
      this.hintTime,
      this.hintSearch,
      this.onTapTime,
      this.onTapSearch,
      this.onDateTimePick,
      this.onSearchPick,
      this.onAreaPick,
      this.showTime = true,
      this.showArea = false,
      this.showSearch = true,
      this.area});

  @override
  State<TfbTimeSearch> createState() => _TfbTimeSearchState();
}

class _TfbTimeSearchState extends State<TfbTimeSearch> {
  String? timeStr;
  String? searchStr;
  String? areaStr;

  @override
  void initState() {
    super.initState();

    _setTimeStr(widget.startTime, widget.endTime);
    searchStr = widget.keywords;
    areaStr = widget.area?.name;
  }

  void _setTimeStr(DateTime? startTime, DateTime? endTime) {
    if (null != startTime && null != endTime) {
      timeStr =
          '${BaseTimeUtils.dateToTimeStr(startTime, format: widget.timeShowFormat)}${widget.timeDivide}${BaseTimeUtils.dateToTimeStr(endTime, format: widget.timeShowFormat)}';
    } else if (null != startTime) {
      timeStr =
          BaseTimeUtils.dateToTimeStr(startTime, format: widget.timeShowFormat);
    } else if (null != endTime) {
      timeStr =
          BaseTimeUtils.dateToTimeStr(endTime, format: widget.timeShowFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      margin: widget.margin ?? const EdgeInsets.only(right: 0),
      decoration: const BoxDecoration(
        color: ColorUtils.colorWhite,
        // borderRadius: BorderRadius.all(Radius.circular(RadiusUtils.radius4))
      ),
      child: Row(
        children: [
          widget.showArea == true
              ? TextView(areaStr ?? '成都市',
                  color: ColorUtils.colorBlack,
                  size: 13,
                  onTap: () {},
                  padding: const EdgeInsets.only(
                      top: SizeUtils.paddingVertical,
                      bottom: SizeUtils.paddingVertical,
                      left: SizeUtils.padding,
                      right: SizeUtils.padding))
              : const SizedBox(
                  height: 0,
                  width: SizeUtils.padding,
                ),
          TextView(
            timeStr ?? widget.hintTime,
            bgColor: ColorUtils.colorWhite,
            color: ColorUtils.colorBlackLite,
            border: true,
            radius: 4,
            borderRadius: BorderRadius.only(
                topLeft: 4.toRadius(), bottomLeft: 4.toRadius()),
            borderColor: '#F0F0F0'.toColor(),
            size: 13,
            onTap: widget.onTapTime ??
                () {
                  DateTimePicker.show(context,
                      dateFormat: widget.timeFormat,
                      showEnd: null != widget.endTime,
                      nowStartDate: widget.startTime,
                      nowEndDate: widget.endTime, onDateTimePick: (start, end) {
                    setState(() {
                      widget.onDateTimePick?.call(start, end);
                      _setTimeStr(start, end);
                    });
                  });
                },
            padding: const EdgeInsets.only(
                top: SizeUtils.paddingVertical,
                bottom: SizeUtils.paddingVertical,
                left: 10,
                right: 10),
            rightIcon: source('home/ic_down'),
            rightIconMargin: const EdgeInsets.only(left: 6),
            rightIconColor: ColorUtils.colorBlackLite,
            rightIconWidth: 8,
            rightIconHeight: 8,
          ).addExpanded(flex: showSearch == true ? null : 1).setVisible(
              visible:
                  widget.showTime == true ? Visible.visible : Visible.gone),
          Expanded(
              child: TextView(
            (searchStr?.length ?? 0) > 0
                ? searchStr
                : (widget.hintSearch ?? '搜索条件'),
            color: ColorUtils.colorBlackLiteLite,
            size: 13,
            borderRadius: BorderRadius.only(
                topRight: 4.toRadius(), bottomRight: 4.toRadius()),
            margin: const EdgeInsets.only(right: 15),
            bgColor: '#F6F5F5'.toColor(),
            onTap: widget.onTapSearch ??
                () {
                  IntentUtils.share
                      .push(context, routeName: RouterPage.KSearchPage, data: {
                    'keyword': searchStr,
                    'hintText': widget.hintSearch ?? '搜索条件',
                  })!.then((data) {
                    if (data is Map) {
                      var value = data['data'];
                      setState(() {
                        searchStr = value;
                      });
                      widget.onSearchPick?.call(value);
                    }
                  });
                },
            padding: const EdgeInsets.only(
                top: SizeUtils.paddingVertical,
                bottom: SizeUtils.paddingVertical,
                left: SizeUtils.paddingHorizontal),
            left: ImageView(
              src: source('ic_search'),
              width: 16,
              color: ColorUtils.colorBlackLite,
              margin: const EdgeInsets.only(right: 4),
              height: 16,
            ),
          )).setVisible(
              visible: showSearch == true ? Visible.visible : Visible.gone)
        ],
      ),
    );
  }
}
