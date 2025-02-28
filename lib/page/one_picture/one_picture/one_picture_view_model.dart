import 'package:graphview/GraphView.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/http/http_query.dart';

///
///  omt
///  one_picture_view_model.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

class OnePictureViewModel extends BaseViewModelRefresh<OnePictureDataData?> {
  final Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 6)
    ..coordinateAssignment = CoordinateAssignment.UpRight;

  @override
  void initState() async {
    super.initState();
    builder
      ..nodeSeparation = (60)
      ..levelSeparation = (60)
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) async {
    // var userInfo = await SharedUtils.getUserInfo();
    HttpQuery.share.onePictureService.deviceTree(
        instanceId: "562#6175",
        gateId: null,
        passId: null,
        onSuccess: (data) {









          onSuccess?.call(data);
        },
        onCache: onCache,
        onError: onError);
  }
}
