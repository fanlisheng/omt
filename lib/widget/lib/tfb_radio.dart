import 'dart:math';

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

class TFBCheckBox extends StatefulWidget {
  final bool? checked;
  final String? title;
  final String? subTitle;
  final bool? multiple;
  final ValueChanged<bool>? onChange;
  final EdgeInsets? margin;
  final Color bgColor;

  const TFBCheckBox(
      {super.key,
      this.checked,
      this.title,
      this.subTitle,
      this.onChange,
      this.margin,
      this.bgColor = ColorUtils.colorWhite,
      this.multiple = false});

  @override
  State<TFBCheckBox> createState() => _TFBCheckBoxState();
}

class _TFBCheckBoxState extends State<TFBCheckBox> {
  bool? checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: widget.multiple != true ? 20 : 20,
            width: widget.multiple != true ? 20 : 20,
            child: widget.multiple != true
                ? CustomPaint(
                    painter: checked != true
                        ? CirclePainter(true)
                        : CircleCheckedPainter(),
                  )
                : checked != true
                    ? CustomPaint(
                        painter: CirclePainter(false),
                      )
                    : ImageView(
                        src: source('ic_cb_checked'),
                        height: 20,
                        width: 20,
                      )),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text(
              widget.title ?? '',
              style: TextStyle(
                  fontSize: SizeUtils.fontSize15,
                  color: widget.checked == null
                      ? ColorUtils.colorBlackLiteLite
                      : ColorUtils.colorBlack),
            ),
            Visibility(
                visible: widget.subTitle != null,
                child: const SizedBox(
                  height: 2,
                )),
            Visibility(
                visible: widget.subTitle != null,
                child: Text(widget.subTitle ?? '',
                    style: TextStyle(
                        fontSize: SizeUtils.fontSize12,
                        color: widget.checked == null
                            ? ColorUtils.colorBlackLiteLite
                            : ColorUtils.colorBlackLiteLite)))
          ],
        )
      ],
    ).setOnClick(
        padding: const EdgeInsets.all(SizeUtils.padding),
        margin: widget.margin,
        bgColor: widget.bgColor,
        onTap: widget.checked == null
            ? null
            : () {
                setState(() {
                  checked = !(checked ?? false);
                  widget.onChange?.call(checked ?? false);
                });
              });
  }
}

class CirclePainter extends CustomPainter {
  final bool circle;
  final Color? color;

  CirclePainter(this.circle, {this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color = color ?? ColorUtils.colorCCC
      ..style = PaintingStyle.stroke
      ..invertColors = false;

    // Rect rect = Rect.fromCircle(center: Offset(100.0, 150.0), radius: 50.0);
    // //根据上面的矩形,构建一个圆角矩形
    // RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20.0));
    //
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.width - paint.strokeWidth) / 2);

    if (circle) {
      canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
    } else {
      RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(2.0));
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CircleCheckedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..invertColors = false;

    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    canvas.drawArc(rect, 0.0, 2 * pi, false,
        paint..color = ColorUtils.colorAccent.withOpacity(0.3));

    rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.width / 2.5) / 2);
    canvas.drawArc(rect, 0.0, 2 * pi, false,
        paint..color = ColorUtils.colorAccent.withOpacity(1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
