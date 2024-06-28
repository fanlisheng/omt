/// Package import
library;
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/lib/chart/model.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports

///todo图表
/// Render the horizontal gradient.
class HorizontalGradient2 extends StatelessWidget {
  final List<ChartData> datas;
  final String? tooltipFormat;

  const HorizontalGradient2({super.key, required this.datas, this.tooltipFormat});

  @override
  Widget build(BuildContext context) {
    var maxY = 1;

    if (!BaseSysUtils.empty(datas)) {
      num temp = maxY;
      for (var i in datas) {
        if ((i.y1?.toInt() ?? 0) > temp) {
          temp = i.y1 ?? 0;
        }
        if ((i.y2?.toInt() ?? 0) > temp) {
          temp = i.y2 ?? 0;
        }
        if ((i.y3?.toInt() ?? 0) > temp) {
          temp = i.y3 ?? 0;
        }
      }
      if (temp > maxY) {
        temp = SysUtils.getMaxY(temp);
        maxY = temp.toInt();
      }
    }

    return getHorizontalGradient2AreaChart(datas, maxY);
  }

  /// Return the circular chart with horizontal gradient.
  SfCartesianChart getHorizontalGradient2AreaChart(
      List<ChartData> datas, int maxY) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        backgroundColor: ColorUtils.colorWhite,
        margin: const EdgeInsets.only(left: 0),
        primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
            interval: 1,
//            labelRotation: -45,
            maximumLabels: 5,
            initialZoomFactor: 6 / (datas.length),
            majorTickLines: const MajorTickLines(color: ColorUtils.colorWhite),
            axisLine: const AxisLine(color: ColorUtils.colorWindow),
            majorGridLines: const MajorGridLines(
              width: 1,
            )),
        primaryYAxis: NumericAxis(
            interval: ((maxY) / 5).ceil() + 0.0,
            minimum: 0,
            maximum: (maxY) + 0.0,
//            labelFormat: '{value}%',
            axisLine: const AxisLine(width: 0),
            majorGridLines: const MajorGridLines(
              color: ColorUtils.colorWindow,
            ),
            majorTickLines: const MajorTickLines(size: 0)),
        series: getGradientAreaSeries(datas),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: TrackballLineType.vertical,
            lineColor: ColorUtils.colorAccent,
            // tooltipAlignment: ChartAlignment.center,
            hideDelay: 800,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipSettings: const InteractiveTooltip(
                format: 'point.y',
                color: ColorUtils.colorBlack,
                arrowLength: 11)),
        zoomPanBehavior: ZoomPanBehavior(
            enablePinching: false,
            enablePanning: true,
//            maximumZoomLevel: 0.2,
            zoomMode: ZoomMode.x,
            enableMouseWheelZooming: false));
  }

  /// Returns the list of spline area series with horizontal gradient.
  List<CartesianSeries<ChartData, String>> getGradientAreaSeries(
      List<ChartData> datas) {
    var list = <CartesianSeries<ChartData, String>>[
      LineSeries<ChartData, String>(
        color: datas.findFirst()?.color ?? ColorUtils.colorAccent,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 6,
            width: 6,
            borderColor: datas.findFirst()?.color ?? ColorUtils.colorAccent,
            color: Colors.white,
            borderWidth: 3),
        dataSource: datas,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1,
        name: 'Investment',
      ),
    ];

    if (datas.findFirst()?.y2 != null) {
      list.add(LineSeries<ChartData, String>(
        color: datas.findFirst()?.color1 ?? ColorUtils.colorAccent,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 6,
            width: 6,
            borderColor: datas.findFirst()?.color1 ?? ColorUtils.colorAccent,
            color: Colors.white,
            borderWidth: 3),
        dataSource: datas,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y2,
        name: 'Investment',
      ));
    }
    if (datas.findFirst()?.y3 != null) {
      list.add(LineSeries<ChartData, String>(
        color: datas.findFirst()?.color2 ?? ColorUtils.colorAccent,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 6,
            width: 6,
            borderColor: datas.findFirst()?.color2 ?? ColorUtils.colorAccent,
            color: Colors.white,
            borderWidth: 3),
        dataSource: datas,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y3,
        name: 'Investment',
      ));
    }

    return list;
  }
}
