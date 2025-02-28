import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
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

class OnePicturePage extends StatelessWidget {
  const OnePicturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<OnePictureViewModel>(
        model: OnePictureViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
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
                boundaryMargin: EdgeInsets.all(100),
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
                          var a = node.key!.value as int?;
                          return rectangleWidget(a);
                        },
                      )),
          );
        });
  }

  Widget rectangleWidget(int? a) {
    if (a == 1 && false) {
      final node111 = Node.Id(111);
      final node1111 = Node.Id(1111);
      final node1112 = Node.Id(1112);

      final Graph graph2 = Graph();

      SugiyamaConfiguration builder2 = SugiyamaConfiguration()
        ..bendPointShape = CurvedBendPointShape(curveLength: 6)
        ..coordinateAssignment = CoordinateAssignment.UpRight;

      graph2.addEdge(node111, node1112);
      graph2.addEdge(node111, node1111);

      builder2
        ..nodeSeparation = (100)
        ..levelSeparation = (100)
        ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
        ..coordinateAssignment = CoordinateAssignment.UpRight;

      return GraphView(
        graph: graph2,
        algorithm: SugiyamaAlgorithm(builder2),
        paint: Paint()
          ..color = Colors.green
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          // I can decide what widget should be shown here based on the id
          var a = node.key!.value as int?;
          return Text('Node ${a}');
        },
      );
    }

    return GestureDetector(
        onTap: () {
          print('tapped' + a.toString());
        },
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
              ],
            ),
            child: Text('Node ${a}')));
  }
}
