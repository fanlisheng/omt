// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;

///
///  tfblue_app
///  widgets.dart
///
///  Created by kayoxu on 2021/10/8 at 1:49 下午
///  Copyright © 2021 kayoxu. All rights reserved.
///

Widget TfbSwitch({
  required String title,
  String? subTitle,
  Color? colorOn,
  EdgeInsets? margin,
  ValueChanged<bool>? onChange,
  bool? value,
  // Color? colorOff
}) {
  var left = Text(
    title,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: const TextStyle(
      color: ColorUtils.colorBlack,
      fontSize: SizeUtils.fontSize15,
    ),
  );
  var leftRoot = subTitle == null
      ? left
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            left,
            const SizedBox(
              height: 2,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  color: ColorUtils.colorBlackLiteLite,
                  fontSize: SizeUtils.fontSize12),
            )
          ],
        );

  colorOn = colorOn ?? ColorUtils.colorAccent;
  // colorOff = colorOff ?? ColorUtils.colorAccent;

  return Container(
    padding: const EdgeInsets.all(SizeUtils.padding),
    margin: margin,
    decoration: const BoxDecoration(
        color: ColorUtils.colorWhite,
        borderRadius: BorderRadius.all(Radius.circular(0))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: leftRoot),
        CupertinoSwitch(
            value: value ?? false, activeColor: colorOn, onChanged: onChange)
      ],
    ),
  );
}

Widget TfbTitleMsg(String? title,
    {Color? titleColor,
    double? titleSize,
    double? msgSize,
    String? msg,
    Color? msgColor,
    bool? showLine = true,
    bool? showRightIcon,
    Function()? onTap}) {
  if (msg == null && showRightIcon != true) {
    return Column(
      children: [
        TextView(
          title ?? '',
          size: titleSize ?? 15,
          fontWeight: FontWeight.bold,
          color: titleColor ?? ColorUtils.colorBlack,
          maxLine: 3,
          padding: const EdgeInsets.only(
              left: SizeUtils.marginHorizontal,
              top: SizeUtils.padding,
              bottom: SizeUtils.padding,
              right: SizeUtils.marginHorizontal),
        ),
        LineView(
          visible: showLine == true ? Visible.visible : Visible.gone,
          margin: const EdgeInsets.only(
            left: SizeUtils.marginHorizontal,
            right: SizeUtils.marginHorizontal,
          ),
        )
      ],
    );
  } else if (showRightIcon != true && msg != null) {
    return Column(
      children: [
        Row(
          children: [
            TextView(
              title ?? '',
              size: msgSize ?? 15,
              fontWeight: FontWeight.bold,
              color: titleColor ?? ColorUtils.colorBlack,
              maxLine: 3,
              padding: const EdgeInsets.only(
                  left: SizeUtils.marginHorizontal,
                  top: SizeUtils.padding,
                  bottom: SizeUtils.padding,
                  right: SizeUtils.marginHorizontal),
            ),
            Expanded(
                child: TextView(
              msg,
              textAlign: TextAlign.right,
              size: 15,
              color: msgColor ?? ColorUtils.colorBlackLiteLite,
              maxLine: 3,
              padding: const EdgeInsets.only(
                  left: SizeUtils.marginHorizontal,
                  top: SizeUtils.padding,
                  bottom: SizeUtils.padding,
                  right: SizeUtils.marginHorizontal),
            )),
          ],
        ),
        LineView(
          visible: showLine == true ? Visible.visible : Visible.gone,
          margin: const EdgeInsets.only(
            left: SizeUtils.marginHorizontal,
            right: SizeUtils.marginHorizontal,
          ),
        )
      ],
    );
  }

  return HorizontalTitleMsgView(
    title: title ?? '',
    height: 50,
    padding: const EdgeInsets.only(
        left: SizeUtils.marginHorizontal, right: SizeUtils.marginHorizontal),
    // padding: EdgeInsets.only(top: 15, bottom: 15),
    titleColor: titleColor ?? ColorUtils.colorBlack,
    titleSize: 15,
    titleFontWeight: FontWeight.bold,
    msg: msg ?? '',
    msgColor: msgColor ?? ColorUtils.colorBlackLiteLite,
    msgSize: 15,
    rightIcon: showRightIcon ?? false,
    rightIconColor: ColorUtils.colorCCC,
    onClick: onTap,
    bottomLine: showLine ?? true,
    bottomLineColor: ColorUtils.colorSeparator,
    bottomLineMargin: const EdgeInsets.only(
        left: SizeUtils.marginHorizontal, right: SizeUtils.marginHorizontal),
  );
}

Widget columnText(
    {String? title,
    String? msg,
    Color? titleColor,
    Color? msgColor,
    double? titleSize,
    double? msgSize,
    int? flex}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      TextView(
        title.defaultStr(),
        size: titleSize ?? 12,
        color: titleColor ?? ColorUtils.colorBlackLite,
        margin: const EdgeInsets.only(bottom: 4),
      ),
      TextView(
        msg.defaultStr(),
        size: msgSize ?? 13,
        color: msgColor ?? ColorUtils.colorBlackLite,
      ),
    ],
  ).addExpanded(flex: flex);
}

Widget rowText(
    {String? text1,
    String? text2,
    EdgeInsets? margin,
    EdgeInsets? padding,
    CrossAxisAlignment? crossAxisAlignment,
    List<Widget>? rightViews,
    int? flexMsg}) {
  var row = Row(
    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
    children: <Widget>[
      TextView(
        text1,
        size: 13,
        color: const Color(0xFF999999),
        margin: const EdgeInsets.only(right: 4),
      ),
      TextView(
        text2,
        size: 13,
        color: const Color(0xFF333333),
        maxLine: flexMsg == null ? 1 : 3,
      ).addExpanded(flex: flexMsg),
      ...(rightViews ?? [])
    ],
  );
  if (null != margin || null != padding) {
    return row.addContainer(padding: padding, margin: margin);
  } else {
    return row;
  }
}

Widget textLine(String title, {bool showLine = false}) {
  return Clickable(
      bgColor: ColorUtils.colorWhite,
      child: Column(
        children: [
          TextView(
            title,
            height: 41,
            width: 70,
            size: 14,
            alignment: Alignment.center,
            fontWeight: showLine == true ? FontWeight.bold : FontWeight.normal,
            color: ColorUtils.colorBlack,
          ),
          LineView(
            height: 3,
            width: 24,
            color: showLine == true
                ? ColorUtils.colorAccent
                : ColorUtils.transparent,
          )
        ],
      ));
}

Widget TfbComboBox(
    {int? selectedIndex, List<IdNameValue>? datas, double? width}) {
  var child2 = fu.ComboBox<IdNameValue>(
    value: null == selectedIndex ? null : datas![selectedIndex],
    items: datas!.map<fu.ComboBoxItem<IdNameValue>>((e) {
      return fu.ComboBoxItem<IdNameValue>(
        value: e,
        child: TextView(
          e.name ?? '',
          maxLine: 1,
          alignment: Alignment.centerLeft,
          size: 13,
          width: null == width ? width : width - 50,
        ),
      );
    }).toList(),
    onChanged: (data) {},
    placeholder: TextView(
      '请选择',
      maxLine: 1,
      size: 13,
      width: null == width ? width : width - 50,
      alignment: Alignment.centerLeft,
      color: ColorUtils.colorBlackLite,
    ),
  );

  return child2;
}

Widget TfbTitleSub(
    {String? title,
    String? subTitle,
    double width = 160,
    bool? row = false,
    String? hint,
    TextEditingController? controller,
    Color titleColor = BaseColorUtils.colorBlack,
    Color subTitleColor = BaseColorUtils.colorBlackLite,
    FontWeight? titleFontWeight = FontWeight.w500,
    FontWeight? subTitleFontWeight = FontWeight.normal,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double titleSize = 15,
    double subTitleSize = 14,
    int? selectedIndex,
    List<IdNameValue>? datas,
    ValueChanged<IdNameValue?>? onSelected,
    Function()? onTap}) {
  Widget? child2;

  if (!BaseSysUtils.empty(datas)) {
    child2 = fu.ComboBox<IdNameValue>(
      value: (null == selectedIndex ||
              selectedIndex < 0 ||
              selectedIndex >= (datas?.length ?? 0))
          ? null
          : datas![selectedIndex],
      items: datas!.map<fu.ComboBoxItem<IdNameValue>>((e) {
        return fu.ComboBoxItem<IdNameValue>(
          value: e,
          child: TextView(
            e.name ?? '',
            maxLine: 1,
            alignment: Alignment.centerLeft,
            size: 13,
            width: width - 50,
          ),
        );
      }).toList(),
      onChanged: (data) {
        onSelected?.call(data);
      },
      placeholder: TextView(
        '请选择',
        maxLine: 1,
        size: 13,
        width: width - 50,
        alignment: Alignment.centerLeft,
        color: ColorUtils.colorBlackLite,
      ),
    );
  } else {
    child2 = null != controller
        ? // fu.TextBox()
        EditView(
            text: subTitle,
            showLine: false,
            textColor: subTitleColor,
            maxLines: 1,
            textSize: subTitleSize,
            alignment: Alignment.centerLeft,
            controller: controller
              ..text = controller.text.defaultStr(data: subTitle ?? ''),
            hintText: hint ?? '请填写$title',
          )
        : TextView(
            subTitle,
            // padding: EdgeInsets.only(top: 12, bottom: 0),
            maxLine: 5,
            alignment: Alignment.centerLeft,
            size: subTitleSize,
            color: subTitleColor,
            fontWeight: subTitleFontWeight,
          );
  }

  var children = [
    TextView(
      title,
      fontWeight: FontWeight.w600,
      size: titleSize,
      color: titleColor,
    ),
    Container(
      width: width,
      height: 35,
      margin: const EdgeInsets.only(top: 5),
      child: child2,
    ),
  ];
  Widget child = row == true
      ? Row(
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        )
      : Column(
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        );
  return child;
}

Widget TitleMsgVideoFrame(String title, String? msg, {int? flex}) {
  return Row(
    children: [
      TextView(
        title,
        color: ColorUtils.colorBlack,
      ),
      Expanded(
          child: TextView(
        msg,
        maxLine: 2,
      ))
    ],
  ).addFlexible(flex: flex);
}
