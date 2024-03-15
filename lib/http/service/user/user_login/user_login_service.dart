import 'package:flutter/cupertino.dart';

import 'package:omt/bean/common/code_data.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';
// import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  user_login_service.dart
///  登录
///
///  Created by kayoxu on 2024-03-05 at 15:04:21
///  Copyright © 2024 .. All rights reserved.
///

class UserLoginService {
  get _list async => '${API.share.host}xxx/xxx';

  get _detail async => '${API.share.host}xxx/xxx';

// list(
//   Map map, {
//   ValueChanged<ListEntity?>? onSuccess,
//   ValueChanged<ListEntity?>? onCache,
//   ValueChanged<String>? onError,
// }) async {
//   map.addAll({'fullData': true});
//   HttpManager.share.doHttpPost<ListEntity>(
//     await _list,
//     map,
//     method: 'GET',
//     autoHideDialog: true,
//     autoShowDialog: true,
//     onSuccess: onSuccess,
//     onCache: onCache,
//     onError: onError,
//   );
// }
//
// detail(
//   Map map, {
//   ValueChanged<DetailEntity?>? onSuccess,
//   ValueChanged<DetailEntity?>? onCache,
//   ValueChanged<String>? onError,
// }) async {
//   map.addAll({'fullData': true});
//   HttpManager.share.doHttpPost<DetailEntity>(
//     await _detail,
//     map,
//     method: 'GET',
//     autoHideDialog: false,
//     autoShowDialog: false,
//     onSuccess: onSuccess,
//     onCache: onCache,
//     onError: onError,
//   );
// }


}
