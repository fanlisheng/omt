import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/widget/canvas/dashed_border_painter.dart';
import 'one_picture_view_model.dart';
import 'package:graphview/GraphView.dart';

///
///  omt
///  one_picture_page.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

class OnePicturePage extends StatefulWidget {
  String? instanceId;
  final int? gateId;
  final int? passId;

  OnePicturePage({super.key, this.instanceId, this.gateId, this.passId});

  @override
  State<OnePicturePage> createState() => OnePicturePageState();
}

class OnePicturePageState extends State<OnePicturePage> {
  OnePictureViewModel? viewModel;

  double _titleSize() => 18;

  Color _titleColor() => ColorUtils.colorBlackLite;

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<OnePictureViewModel>(
        model: OnePictureViewModel(
            widget.instanceId, widget.gateId, widget.passId),
        autoLoadData: true,
        builder: (context, model, child) {
          viewModel = model;
          return InteractiveViewer(
              constrained: false,
              // clipBehavior: Clip.antiAlias,
              boundaryMargin: const EdgeInsets.all(50),
              // transformationController: model.transformationController,
              minScale: 0.1,
              maxScale: 1,
              child: model.graph.nodeCount() == 0
                  ? ((model.theOnePictureDataData?.getChildList() ?? [])
                          .isNotEmpty
                      ? (Row(
                          children: model.theOnePictureDataData!
                              .getChildList()
                              .map((e) {
                            final Graph graph = Graph();
                            SugiyamaConfiguration builder =
                                SugiyamaConfiguration()
                                  ..bendPointShape =
                                      CurvedBendPointShape(curveLength: 6)
                                  ..coordinateAssignment =
                                      CoordinateAssignment.UpRight;
                            return rectangleSubWidget2(
                                model: model,
                                data: e,
                                graph: graph,
                                builder: builder);
                          }).toList(),
                        ))
                      : Container())
                  : GraphView(
                      graph: model.graph,
                      algorithm: SugiyamaAlgorithm(model.builder),
                      paint: Paint()
                        ..color = Colors.green
                        ..strokeWidth = 2
                        ..style = PaintingStyle.stroke,
                      builder: (Node node) {
                        var a = node.key!.value as String?;
                        return rectangleWidget(model, a);
                      },
                    ));
        });
  }

  Widget rectangleWidget(OnePictureViewModel model, String? nodeId) {
    OnePictureDataData? onePictureDataData = model.dataMap[nodeId];

    if ((onePictureDataData?.getChildList() ?? []).isNotEmpty &&
        (onePictureDataData?.nextList ?? []).isEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !(onePictureDataData?.showName ?? true)
                ? SizedBox.shrink()
                : TextView(
                    onePictureDataData?.showNameText,
                    size: _titleSize(),
                    color: _titleColor(),
                  ),
            Container(
              padding: EdgeInsets.only(
                  top: onePictureDataData?.showAddBtn == true ? 32 : 0,
                  bottom: onePictureDataData?.showAddBtn == true ? 16 : 20,
                  left: 0,
                  right: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: '#347979'.toColor(), width: 1),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: onePictureDataData!.getChildList().map((e) {
                  final Graph graph = Graph();
                  SugiyamaConfiguration builder = SugiyamaConfiguration()
                    ..bendPointShape = CurvedBendPointShape(curveLength: 6)
                    ..coordinateAssignment = CoordinateAssignment.UpRight;
                  return rectangleSubWidget2(
                      model: model, data: e, graph: graph, builder: builder);
                }).toList(),
              ),
            )
          ],
        ),
      ).addRightIcon(
          onTap: onePictureDataData?.showAddBtn != true
              ? null
              : () {
                  model.onTapItemNew(onePictureDataData);
                });
    }

    return GestureDetector(
        onTap: () {
          // print('tapped' + '${onePictureDataData?.toString()}');
          model.onTapItem(onePictureDataData);
        },
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: '#347979'.toColor(), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _item(onePictureDataData)));
  }

  Widget rectangleSubWidget2(
      {required OnePictureViewModel model,
      OnePictureDataData? data,
      Graph? graph,
      SugiyamaConfiguration? builder}) {
    if (data == null) {
      LogUtils.info(msg: 'nodeId or onePictureDataData is null');
      return const SizedBox.shrink();
    }

    graph ??= Graph();
    builder ??= SugiyamaConfiguration()
      ..bendPointShape = CurvedBendPointShape(curveLength: 6)
      ..coordinateAssignment = CoordinateAssignment.UpRight;

    bool addNewGraph = false;

    if ((data.nextList ?? []).isNotEmpty) {
      addNewGraph = true;
      model.doSetDataToGraph(graph, data);

      builder
        ..nodeSeparation = (10)
        ..levelSeparation = (50)
        ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
        ..coordinateAssignment = CoordinateAssignment.DownRight;
    }

    if (addNewGraph) {
      return GraphView(
        graph: graph,
        algorithm: SugiyamaAlgorithm(builder),
        paint: Paint()
          ..color = Colors.green
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          // I can decide what widget should be shown here based on the id
          var nodeId = node.key!.value as String?;
          OnePictureDataData? oData = model.dataMap[nodeId];

          return GestureDetector(
            child: Container(
              // margin: EdgeInsets.only(bottom: 20,top: 20),
              child: Column(
                children: [
                  !(oData?.showName ?? true)
                      ? SizedBox.shrink()
                      : TextView(oData?.showNameText, size: _titleSize()),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 0, right: 0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: '#347979'.toColor(), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: (oData?.getChildList() ?? []).isEmpty
                        ? _item(oData)
                        : Row(
                            children: oData!.getChildList().map((e) {
                              final Graph graph = Graph();
                              SugiyamaConfiguration builder =
                                  SugiyamaConfiguration()
                                    ..bendPointShape =
                                        CurvedBendPointShape(curveLength: 6)
                                    ..coordinateAssignment =
                                        CoordinateAssignment.UpRight;
                              return rectangleSubWidget2(
                                  model: model,
                                  data: e,
                                  graph: graph,
                                  builder: builder);
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
            onTap: () {
              // print('tapped' + '${data.toString()}');
              model.onTapItem(oData);
            },
          );
        },
      );
    }

    Widget cW = const SizedBox.shrink();

    if ((data.getChildList() ?? []).isNotEmpty) {
      cW = Row(
        children: data.getChildList().map((e) {
          return rectangleSubWidget2(model: model, data: e);
        }).toList(),
      );

      if (data.type == OnePictureType.JCK.index) {
        // data.setBorder();
        if (data.showBorder == false) {
          return Container(
                  margin:
                      EdgeInsets.only(bottom: 16, top: 0, left: 0, right: 0),
                  child: Column(children: [
                    !(data?.showName ?? true)
                        ? SizedBox.shrink()
                        : TextView(data?.showNameText, size: _titleSize()),
                    Container(
                        padding: data.getChildList().length > 0
                            ? null
                            : const EdgeInsets.only(
                                top: 0, bottom: 20, left: 0, right: 20),
                        decoration: data.getChildList().length > 0
                            ? null
                            : BoxDecoration(
                                border: Border.all(
                                    color: '#347979'.toColor(), width: 1),
                                borderRadius: BorderRadius.circular(4)),
                        child: Container(child: cW)),
                    (data?.showDesc ?? '').isEmpty
                        ? SizedBox.shrink()
                        : TextView(data?.showDesc),
                  ]))
              .addRightIcon(
                  onTap: data?.showAddBtn != true
                      ? null
                      : () {
                          model.onTapItemNew(data);
                        })
              .addDashBorder(
                  color: '#347979'.toColor(),
                  width: 1,
                  dash: data.getChildList().length > 0,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  padding:
                      EdgeInsets.only(left: 0, right: 20, top: 0, bottom: 0),
                  borderRadius: 4.0);
        } else {
          if (data.showBorder == true) {}
          if (data.ignore == true) {}
        }
      }

      // return cW;
    }

    return GestureDetector(
        onTap: () {
          // print('tapped' + '${data.toString()}');
          model.onTapItem(data);
        },
        child: data.getChildList().isNotEmpty
            ? Column(
                children: [
                  !(data?.showName ?? true)
                      ? SizedBox.shrink()
                      : TextView(data?.showNameText, size: _titleSize()),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 16, left: 0, right: 20),
                    margin: data.getChildList().length > 0
                        ? null
                        : EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: data.getChildList().length > 0
                            ? null
                            : Border.all(color: '#347979'.toColor(), width: 2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: data!.getChildList().map((e) {
                        final Graph graph = Graph();
                        SugiyamaConfiguration builder = SugiyamaConfiguration()
                          ..bendPointShape =
                              CurvedBendPointShape(curveLength: 6)
                          ..coordinateAssignment = CoordinateAssignment.UpRight;
                        return rectangleSubWidget2(
                            model: model,
                            data: e,
                            graph: graph,
                            builder: builder);
                      }).toList(),
                    ),
                  )
                      .addRightIcon(
                          onTap: data.ignore != true
                              ? null
                              : () {
                                  model.onTapItemNew(data);
                                })
                      .addDashBorder(
                          color: '#347979'.toColor(),
                          width: 1,
                          dash: data.getChildList().length > 0,
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          borderRadius: 4.0),
                ],
              )
            : _item(data));
  }

  Container _item(OnePictureDataData? oData) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: '#82FFFC'.toColor(opacity: .1)),
          boxShadow: [
            BoxShadow(color: '#82FFFC'.toColor(opacity: .05), spreadRadius: 1),
          ],
        ),
        child: Column(
          children: [
            (oData?.icon ?? '').isEmpty
                ? SizedBox.shrink()
                : ImageView(
                    src: oData?.icon,
                    height: 22,
                    width: 22,
                  ),
            TextView(
              '${oData?.showNameText}',
              color: '#30E7E3'.toColor(),
              size: oData?.type == OnePictureType.SL.index ? 30 : 14,
            ),
            (oData?.showDesc ?? '').isEmpty
                ? SizedBox.shrink()
                : Text(oData?.showDesc ?? ''),
          ],
        ));
  }

  refresh({
    @required String? instanceId,
    @required int? gateId,
    @required int? passId,
  }) {
    viewModel?.instanceId = instanceId;
    viewModel?.gateId = gateId;
    viewModel?.passId = passId;
    viewModel?.reInitData();
  }
}

extension on Widget {
  addDashBorder(
      {required Color color,
      required int width,
      required double borderRadius,
      EdgeInsets? margin,
      EdgeInsets? padding,
      required bool dash}) {
    if (dash) {
      var customPaint = CustomPaint(
        painter: DashedBorderPainter(
            color: '#347979'.toColor(), borderRadius: borderRadius),
        child:
            Padding(padding: padding ?? EdgeInsets.only(top: 0), child: this),
      );
      return null != margin
          ? Container(
              margin: margin,
              child: customPaint,
            )
          : customPaint;
    }
    return this;
  }
}

extension on Container {
  Widget addRightIcon({required Function()? onTap, Widget? btn}) {
    if (null == onTap) {
      return this;
    }

    return Stack(
      children: [
        this,
        Positioned(
            right: 20,
            top: 30,
            child: btn ??
                TextButton(
                    onPressed: onTap,
                    child: const Row(
                      children: [Icon(Icons.add), Text('添加设备')],
                    ))),
      ],
    );
  }
}
