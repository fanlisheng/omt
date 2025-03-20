import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final double dashLength;
  final double dashGap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.borderRadius = 0.0,
    this.dashLength = 8.0,
    this.dashGap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (borderRadius > 0) {
      final path = Path();
      // 添加圆角矩形路径
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          Radius.circular(borderRadius),
        ),
      );

      double start = 0;
      bool draw = true;

      while (start < path.computeMetrics().first.length) {
        double end = start + (draw ? dashLength : dashGap);
        if (end > path.computeMetrics().first.length) {
          end = path.computeMetrics().first.length;
        }
        final segment = path.computeMetrics().first.extractPath(start, end);
        if (draw) {
          canvas.drawPath(segment, paint);
        }
        start += (draw ? dashLength : dashGap);
        draw = !draw;
      }
    } else {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(Offset(0, startY), Offset(0, startY + dashLength), paint);
        startY += dashLength + dashGap;
      }

      startY = 0;
      while (startY < size.height) {
        canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashLength), paint);
        startY += dashLength + dashGap;
      }

      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, 0), Offset(startX + dashLength, 0), paint);
        startX += dashLength + dashGap;
      }

      startX = 0;
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, size.height), Offset(startX + dashLength, size.height), paint);
        startX += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! DashedBorderPainter ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashGap != dashGap;
  }
}
