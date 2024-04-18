import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/widget/canvas/paint_yolo.dart';

class CanvasPaintYoloWidget extends StatefulWidget {
  int canvasNum = 1;
  List<PaintYolo> rectangles = [];
  final ValueChanged<List<PaintYolo>> onRectangles;

  CanvasPaintYoloWidget(
      {super.key,
      required this.canvasNum,
      required this.rectangles,
      required this.onRectangles});

  @override
  State<CanvasPaintYoloWidget> createState() => _CanvasPaintYoloWidgetState();
}

class _CanvasPaintYoloWidgetState extends State<CanvasPaintYoloWidget> {
  bool popData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.rectangles.length < widget.canvasNum + 1) {
          setState(() {
            // final point = _constrainPointToBox(Offset.zero, context);
            // widget.rectangles.add(Rect.fromPoints(point, point));
          });
        }
      },
      onPanStart: (details) {
        popData = true;
        setState(() {
          final startPoint =
              _constrainPointToBox(details.localPosition, context);
          widget.rectangles
              .add(PaintYolo(rect: Rect.fromPoints(startPoint, startPoint)));
        });
      },
      onPanUpdate: (details) {
        if (widget.rectangles.length < widget.canvasNum + 1) {
          popData = false;
          setState(() {
            final endPoint =
                _constrainPointToBox(details.localPosition, context);
            final lastIndex = widget.rectangles.length - 1;
            widget.rectangles[lastIndex] = PaintYolo(
                rect: Rect.fromPoints(
                    widget.rectangles[lastIndex].rect!.topLeft, endPoint));
          });
        }
      },
      onPanEnd: (_) {
        LogUtils.info(msg: '${widget.rectangles}');
        if (popData && !BaseSysUtils.empty(widget.rectangles)) {
          widget.rectangles.removeLast();
        } else {
          widget.onRectangles.call(widget.rectangles);
        }
        setState(() {
          // Do any cleanup if needed
        });
      },
      child: CustomPaint(
        painter: CanvasPaint(rectangles: widget.rectangles),
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
}

class CanvasPaint extends CustomPainter {
  final List<PaintYolo> rectangles;

  CanvasPaint({required this.rectangles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    int i = 0;
    var colors = [
      ColorUtils.colorRed,
      ColorUtils.colorGreen,
      ColorUtils.colorBlue,
      ColorUtils.colorYellow
    ];
    for (final rect in rectangles) {
      paint.color = colors[i++ % 4];
      canvas.drawRect(rect.rect!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
