import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
// import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  one_picture_service.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

class OnePictureService {

  get _deviceTree => '${API.share.host}api/device/tree';


  deviceTree(
  {
    required String instanceId,
    required int? gateId,
    required int? passId,
   ValueChanged<OnePictureDataData?>? onSuccess,
  ValueChanged<OnePictureDataData?>? onCache,
  ValueChanged<String>? onError,
}) async {


    Map<String, dynamic> map = {};
    if (instanceId!= null) {
      map['instance_id'] = instanceId;
     }
    if (gateId!= null) {
      map['gate_id'] = gateId;
    }
    if (passId!= null) {
      map['pass_id'] = passId;
    }

  HttpManager.share.doHttpPost<OnePictureDataData>(
    await _deviceTree,
    map,
    method: 'POST',
    autoHideDialog: false,
    autoShowDialog: false,
    onSuccess: onSuccess,
    onCache: onCache,
    onError: onError,
  );
}


}
