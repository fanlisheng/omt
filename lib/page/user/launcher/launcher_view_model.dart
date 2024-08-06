import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  launcher_view_model.dart
///  LauncherPage
///
///  Created by kayoxu on 2024-03-05 at 15:25:38
///  Copyright © 2024 .. All rights reserved.
///

class LauncherViewModel extends BaseViewModelRefresh<dynamic> {
  @override
  void initState() async {
    super.initState();
    // Timer(Duration(seconds: 2), () {
    //   IntentUtils.share.goHome(context);
    // });

    SharedUtils.getUserInfo().then((value) {
      if (BaseSysUtils.empty(value?.phone)) {
        IntentUtils.share.gotoLogin(context, noAlert: true);
      } else {
        IntentUtils.share.goHome(context, checkUserPermission: true);
      }
    });
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }
}
