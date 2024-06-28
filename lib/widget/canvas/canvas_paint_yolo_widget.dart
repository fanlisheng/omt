import 'package:flutter/material.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/canvas/paint_yolo.dart';

typedef OnRectangles = Function(
    List<PaintYolo> pys, ValueChanged<IdNameValue?> type);

class CanvasPaintYoloWidget extends StatefulWidget {
  int canvasNum;
  List<PaintYolo> rectangles;
  PaintYolo? rectangleSelected;
  ValueChanged<PaintYolo?>? onRectangleSelect;

  final OnRectangles onRectangles;

  CanvasPaintYoloWidget({
    super.key,
    this.rectangleSelected,
    this.onRectangleSelect,
    required this.canvasNum,
    required this.rectangles,
    required this.onRectangles,
  });

  @override
  State<CanvasPaintYoloWidget> createState() => _CanvasPaintYoloWidgetState();
}

class _CanvasPaintYoloWidgetState extends State<CanvasPaintYoloWidget> {
  bool popData = true;
  PaintYolo? activeRectangle;
  Offset? dragStartOffset;
  Offset? rectStartOffset;
  bool isResizing = false;
  bool isMoving = false;
  final double handleSize = 10.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          activeRectangle = _getActiveRectangle(details.localPosition);
          if (activeRectangle != null) {
            dragStartOffset = details.localPosition;
            rectStartOffset = activeRectangle!.rect!.topLeft;
            isResizing =
                _isOnHandle(details.localPosition, activeRectangle!.rect!);
            isMoving =
                _isOnMoveHandle(details.localPosition, activeRectangle!.rect!);
            widget.onRectangleSelect?.call(activeRectangle);
          }
        });
      },
      onPanStart: (details) {
        popData = true;
        setState(() {
          activeRectangle = _getActiveRectangle(details.localPosition);
          if (activeRectangle != null) {
            dragStartOffset = details.localPosition;
            rectStartOffset = activeRectangle!.rect!.topLeft;
            isResizing =
                _isOnHandle(details.localPosition, activeRectangle!.rect!);
            isMoving =
                _isOnMoveHandle(details.localPosition, activeRectangle!.rect!);
          } else {
            final startPoint =
                _constrainPointToBox(details.localPosition, context);
            widget.rectangles
                .add(PaintYolo(rect: Rect.fromPoints(startPoint, startPoint)));
          }
        });
      },
      onPanUpdate: (details) {
        popData = false;
        setState(() {
          final endPoint = _constrainPointToBox(details.localPosition, context);
          if (activeRectangle != null) {
            if (isResizing) {
              activeRectangle!.rect =
                  Rect.fromPoints(rectStartOffset!, endPoint);
            } else if (isMoving) {
              final dx = endPoint.dx - dragStartOffset!.dx;
              final dy = endPoint.dy - dragStartOffset!.dy;
              final newTopLeft = Offset(
                rectStartOffset!.dx + dx,
                rectStartOffset!.dy + dy,
              );
              activeRectangle!.rect = Rect.fromLTWH(
                newTopLeft.dx,
                newTopLeft.dy,
                activeRectangle!.rect!.width,
                activeRectangle!.rect!.height,
              );
              rectStartOffset = newTopLeft;
              dragStartOffset = endPoint;
            }
          } else {
            final lastIndex = widget.rectangles.length - 1;
            widget.rectangles[lastIndex] = PaintYolo(
              rect: Rect.fromPoints(
                  widget.rectangles[lastIndex].rect!.topLeft, endPoint),
            );
          }
        });
      },
      onPanEnd: (_) {
        if (activeRectangle == null) {
          if (popData && widget.rectangles.isNotEmpty) {
            widget.rectangles.removeLast();
          } else {
            widget.onRectangles(widget.rectangles, (data) {
              setState(() {
                if (data?.id == null) {
                  widget.rectangles.removeLast();
                } else {
                  widget.rectangles.last.type = data;
                }
                LogUtils.info(msg: '${widget.rectangles}');
              });
            });
          }
        }
        setState(() {
          activeRectangle = null;
          dragStartOffset = null;
          rectStartOffset = null;
          isResizing = false;
          isMoving = false;
        });
      },
      child: CustomPaint(
        painter: CanvasPaint(
          rectangles: widget.rectangles,
          rectangleSelected: widget.rectangleSelected,
          handleSize: handleSize,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Offset _constrainPointToBox(Offset point, BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Size size = box.size;
    final double x = point.dx.clamp(0.0, size.width);
    final double y = point.dy.clamp(0.0, size.height);
    return Offset(x, y);
  }

  PaintYolo? _getActiveRectangle(Offset point) {
    for (int i = widget.rectangles.length - 1; i >= 0; i--) {
      final rect = widget.rectangles[i];
      if (_isOnHandle(point, rect.rect!) ||
          _isOnMoveHandle(point, rect.rect!)) {
        return rect;
      }
    }
    return null;
  }

  bool _isOnHandle(Offset point, Rect rect) {
    return (point.dx >= rect.right - handleSize &&
        point.dx <= rect.right + handleSize &&
        point.dy >= rect.bottom - handleSize &&
        point.dy <= rect.bottom + handleSize);
  }

  bool _isOnMoveHandle(Offset point, Rect rect) {
    final double moveHandleSize = handleSize * 1.5;
    return (point.dx >= rect.left &&
        point.dx <= rect.left + moveHandleSize &&
        point.dy >= rect.top &&
        point.dy <= rect.top + moveHandleSize);
  }
}

class CanvasPaint extends CustomPainter {
  final List<PaintYolo> rectangles;
  final PaintYolo? rectangleSelected;
  final double handleSize;

  CanvasPaint(
      {required this.rectangles,
      this.rectangleSelected,
      required this.handleSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // final Paint paintSelected = Paint()
    //   ..color = Colors.orange
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 6.0;

    final Paint handlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Paint moveHandlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double strokeWidthPlus = 0;

    int i = 0;
    int colorSize = 49;
    var colors = SysUtils.generateColors49();

    for (final rect in rectangles) {
      paint.color = colors[i++ % colorSize];
      moveHandlePaint.color = paint.color;
      if (rectangleSelected?.type?.id != null &&
          rect.type?.id == rectangleSelected?.type?.id) {
        strokeWidthPlus = 3;
        paint.strokeWidth = 6;
      } else {
        strokeWidthPlus = 0.0;
        paint.strokeWidth = 3;
      }
      canvas.drawRect(rect.rect!, paint);
      canvas.drawRect(
        Rect.fromCenter(
          center: rect.rect!.bottomRight,
          width: handleSize,
          height: handleSize,
        ),
        handlePaint,
      );

      // Draw the move handle
      canvas.drawRect(
        Rect.fromPoints(
          rect.rect!.topLeft,
          Offset(rect.rect!.left + handleSize * 1.5 + strokeWidthPlus,
              rect.rect!.top + handleSize * 1.5 + strokeWidthPlus),
        ),
        moveHandlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
