import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/utils/base_sys_utils.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/api.dart';

import '../../../http_manager.dart';
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
  get _login async => '${API.share.host}api/moat/phone/login';

  get _getPositions async => '${API.share.host}api/moat/user/positions';

  get _confirm async => '${API.share.host}api/moat/position/confirm';

  // get _detail async => '${API.share.host}xxx/xxx';

  login({
    required String phone,
    required String password,
    int? platformId,
    required String mac,
    ValueChanged<Map?>? onSuccess,
    ValueChanged<Map?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<Map>(
      await _login,
      {
        "phone": phone,
        "password": BaseSysUtils.getMd5(password),
        // "phone": "18180821779",
        // "password": "585b8aeb3e295e4c15becdc9088f9d63",
        // "phone": "15196612685",
        // "password": "585b8aeb3e295e4c15becdc9088f9d63",
        "platform_id": platformId ?? 1,
        "mac": mac
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  getPositions({
    ValueChanged<List<IdNameValue>?>? onSuccess,
    ValueChanged<List<IdNameValue>?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<IdNameValue>>(
      await _getPositions,
      {},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  confirm({
    required int positionId,
    ValueChanged<Map?>? onSuccess,
    ValueChanged<Map?>? onCache,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<Map>(
      await _confirm,
      {
        "position_id": positionId,
      },
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

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
