import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/shared_utils.dart';

///
///  omt
///  navi_view_model.dart
///  导航页
///
///  Created by kayoxu on 2024-04-09 at 10:04:18
///  Copyright © 2024 .. All rights reserved.
///

class NaviViewModel extends BaseViewModelRefresh<dynamic> {
  UserInfoData? userInfoData;

  @override
  void initState() async {
    super.initState();
    SharedUtils.getUserInfo().then((value) {
      userInfoData = value;
      notifyListeners();
    });
  }


  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  void onTapItem(UserPermission e) {
    SharedUtils.setTheUserPermission(e);
    IntentUtils.share.goHomeBase(context);
  }
}
