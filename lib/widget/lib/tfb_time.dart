import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';

///
///  tfblue_app
///  tfb_radio.dart
///
///  Created by kayoxu on 2021/10/8 at 3:42 下午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class TfbTimePicker extends StatefulWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? startTimeMax;
  final DateTime? endTimeMax;
  final String? timeFormat;
  final String? dateFormat;
  final String? pickerDateTimeFormat;
  final OnDateTimePick? onDateTimePick;

  const TfbTimePicker(
      {super.key,
      this.padding,
      this.margin,
      required this.startTime,
      required this.endTime,
      this.startTimeMax,
      this.endTimeMax,
      this.timeFormat = 'HH:mm',
      this.dateFormat = 'MM月dd日',
      this.pickerDateTimeFormat,
      this.onDateTimePick});

  @override
  State<TfbTimePicker> createState() => _TfbTimePickerState();
}

class _TfbTimePickerState extends State<TfbTimePicker> {
  String? pickerDateTimeFormat;

  @override
  void initState() {
    super.initState();
    pickerDateTimeFormat =
        widget.pickerDateTimeFormat ?? 'yyyy-MM-dd ${widget.timeFormat}';
  }

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () {
        DateTimePicker.show(context,
            dateFormat: widget.pickerDateTimeFormat ?? pickerDateTimeFormat,
            showEnd: true,
            maxStartDate: widget.startTimeMax ??
                BaseTimeUtils.getTime(after: 0, start: false),
            maxEndDate: widget.endTimeMax ??
                BaseTimeUtils.getTime(after: 0, start: false),
            nowStartDate: widget.startTime,
            nowEndDate: widget.endTime, onDateTimePick: (start, end) {
          setState(() {
            widget.onDateTimePick?.call(start, end);
          });
        });
      },
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: ColorUtils.colorBgSearch),
      height: 36,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageView(
                src: source('alarm/ic_date'),
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(left: 16),
              ),
              TextView(
                BaseTimeUtils.dateToTimeStr(
                    widget.startTime ?? BaseTimeUtils.getToday(start: true),
                    format: widget.dateFormat),
                size: 13,
                fontWeight: FontWeight.w600,
                color: ColorUtils.colorBlack,
                margin: const EdgeInsets.only(left: 4),
              ),
              TextView(
                BaseTimeUtils.dateToTimeStr(
                    widget.startTime ?? BaseTimeUtils.getToday(start: true),
                    format: widget.timeFormat),
                size: 11,
                color: ColorUtils.colorBlackLite,
                margin: const EdgeInsets.only(left: 2),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 1,
                color: ColorUtils.colorLine,
              ),
              TextView(
                '约${BaseTimeUtils.intervalDay(widget.startTime ?? BaseTimeUtils.getToday(start: true), widget.endTime ?? BaseTimeUtils.getToday(start: false))}天',
                color: ColorUtils.colorBlue,
                size: 9,
                border: true,
                borderColor: ColorUtils.colorLine,
                borderWidth: 1,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                padding: const EdgeInsets.only(
                    left: 12, top: 1, bottom: 1, right: 12),
              ),
              Container(
                width: 8,
                height: 1,
                color: ColorUtils.colorLine,
              ),
            ],
          ),
          Row(
            children: [
              ImageView(
                src: source('alarm/ic_date'),
                width: 16,
                height: 16,
              ),
              TextView(
                BaseTimeUtils.dateToTimeStr(
                    widget.endTime ?? BaseTimeUtils.getToday(start: false),
                    format: widget.dateFormat),
                size: 13,
                fontWeight: FontWeight.w600,
                color: ColorUtils.colorBlack,
                margin: const EdgeInsets.only(left: 4),
              ),
              TextView(
                BaseTimeUtils.dateToTimeStr(
                    widget.endTime ?? BaseTimeUtils.getNow(),
                    format: widget.timeFormat),
                size: 11,
                color: ColorUtils.colorBlackLite,
                margin: const EdgeInsets.only(left: 2, right: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
