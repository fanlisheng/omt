import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';
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
              minScale: 0.01,
              maxScale: 5.6,
              child: model.graph.nodeCount() == 0
                  ? Container()
                  : GraphView(
                      graph: model.graph,
                      algorithm: SugiyamaAlgorithm(model.builder),
                      paint: Paint()
                        ..color = Colors.green
                        ..strokeWidth = 1
                        ..style = PaintingStyle.stroke,
                      builder: (Node node) {
                        var a = node.key!.value as String?;
                        return rectangleWidget(model, a);
                      },
                    ));
          return ToolBar(
            title: '一张图',
            elevation: 0,
            actions: [
              TextButton(
                  onPressed: () {
                    model.refresh();
                  },
                  child: Text('刷新'))
            ],
            iosBack: true,
            child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.01,
                maxScale: 5.6,
                child: model.graph.nodeCount() == 0
                    ? Container()
                    : GraphView(
                        graph: model.graph,
                        algorithm: SugiyamaAlgorithm(model.builder),
                        paint: Paint()
                          ..color = Colors.green
                          ..strokeWidth = 1
                          ..style = PaintingStyle.stroke,
                        builder: (Node node) {
                          var a = node.key!.value as String?;
                          return rectangleWidget(model, a);
                        },
                      )),
          );
        });
  }

  Widget rectangleWidget(OnePictureViewModel model, String? nodeId) {
    OnePictureDataData? onePictureDataData = model.dataMap[nodeId];

    if ((onePictureDataData?.getChildList() ?? []).isNotEmpty &&
        (onePictureDataData?.nextList ?? []).isEmpty) {
      return Container(
        child: Column(
          children: [
            !(onePictureDataData?.showName ?? true)
                ? SizedBox.shrink()
                : TextView(onePictureDataData?.showNameText),
            Container(
              padding: EdgeInsets.only(
                  top: onePictureDataData?.showAddBtn == true ? 32 : 0,
                  bottom: onePictureDataData?.showAddBtn == true ? 16 : 20,
                  left: 16,
                  right: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
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
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
                padding:
                    EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
                  ],
                ),
                child: Column(
                  children: [
                    onePictureDataData?.iconData == null
                        ? SizedBox.shrink()
                        : Icon(onePictureDataData?.iconData),
                    Text('${onePictureDataData?.showNameText}'),
                    (onePictureDataData?.showDesc ?? '').isEmpty
                        ? SizedBox.shrink()
                        : TextView(onePictureDataData?.showDesc),
                  ],
                ))));
  }

  Widget rectangleSubWidget2(
      {required OnePictureViewModel model,
      OnePictureDataData? data,
      Graph? graph,
      SugiyamaConfiguration? builder}) {
    // model.currentIndex++;
    // if (model.currentIndex > 16) {
    //   return Container(
    //     color: ColorUtils.colorRed,
    //     height: 100,
    //     width: 100,
    //   );
    // }

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
        ..nodeSeparation = (100)
        ..levelSeparation = (100)
        ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
        ..coordinateAssignment = CoordinateAssignment.UpRight;
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
                      : TextView(oData?.showNameText),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: (oData?.getChildList() ?? []).isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(
                                top: 16, bottom: 16, left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blue[100]!, spreadRadius: 1),
                              ],
                            ),
                            child: Column(
                              children: [
                                oData?.iconData == null
                                    ? SizedBox.shrink()
                                    : Icon(oData?.iconData),
                                Text('${oData?.showNameText}'),
                                (oData?.showDesc ?? '').isEmpty
                                    ? SizedBox.shrink()
                                    : Text(oData?.showDesc??''),
                              ],
                            ))
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
              margin: EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
              child: Column(children: [
                !(data?.showName ?? true)
                    ? SizedBox.shrink()
                    : TextView(data?.showNameText),
                Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 20, left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Container(child: cW)),
                (data?.showDesc ?? '').isEmpty
                    ? SizedBox.shrink()
                    : TextView(data?.showDesc),
              ])).addRightIcon(
              onTap: data?.showAddBtn != true
                  ? null
                  : () {
                      model.onTapItemNew(data);
                    });
        } else {
          if (data.showBorder == true) {

          }
          if (data.ignore == true) {

          }
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
                      : TextView(data?.showNameText),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 30, left: 16, right: 16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
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
                  ).addRightIcon(
                      onTap: data.ignore != true
                          ? null
                          : () {
                              model.onTapItemNew(data);
                            })
                ],
              )
            : Container(
                padding: EdgeInsets.all(16),
                margin: data.getChildList().length > 1
                    ? EdgeInsets.all(16)
                    : (((data.getChildList().firstOrNull?.nextList ?? [])
                            .isEmpty)
                        ? EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16)
                        : EdgeInsets.all(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
                  ],
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        data?.iconData == null
                            ? SizedBox.shrink()
                            : Icon(data?.iconData),
                        Text('${data?.showNameText}'),
                        (data?.showDesc ?? '').isEmpty
                            ? SizedBox.shrink()
                            : Text(data?.showDesc ?? ''),
                      ],
                    ),
                    cW
                  ],
                )));
  }

  refresh({
    @required String? instanceId,
    @required int? gateId,
    @required int? passId,
  }) {
    viewModel?.instanceId = instanceId;
    viewModel?.gateId = gateId;
    viewModel?.passId = passId;
    viewModel?.requestData();
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
