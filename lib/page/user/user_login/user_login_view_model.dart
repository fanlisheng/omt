import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/utils/intent_utils.dart';

///
///  omt
///  user_login_view_model.dart
///  登录
///
///  Created by kayoxu on 2024-03-05 at 15:04:21
///  Copyright © 2024 .. All rights reserved.
///

class UserLoginViewModel extends BaseViewModelRefresh<UserLoginData> {
  late TextEditingController phoneController;
  late TextEditingController pwdController;
  int? platformId;
  int? org_dept_id;
  bool pwdObscureText = true;
  bool acceptAgreement = false;
  bool canLogin = false;
  bool canClear = false;
  bool available = false;
  String tips = '';
  bool privacy = false;

  // 手机号格式是否正确
  bool showPhoneTips = false;

  List pemissionIds = [1, 2, 3];

  String? token;
  FocusNode node = FocusNode();

  int i = 0;

  @override
  void initState() async {
    super.initState();
    phoneController = TextEditingController(text: '1');
    pwdController = TextEditingController(text: '1');
    canLogin = !BaseSysUtils.empty(phoneController.text) &&
        !BaseSysUtils.empty(pwdController.text);
    canClear = !BaseSysUtils.empty(phoneController.text);
    node.addListener(() {
      if (!node.hasFocus) {
        if (!BaseSysUtils.empty(phoneController.text)) {
          showPhoneTips = !BaseSysUtils.isPhoneNo(phoneController.text);
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  void onEditValueChange(String value) {
    canLogin = !BaseSysUtils.empty(phoneController.text) &&
        !BaseSysUtils.empty(pwdController.text);
    canClear = !BaseSysUtils.empty(phoneController.text);
    if (value.length == 11) {
      showPhoneTips = !BaseSysUtils.isPhoneNo(phoneController.text);
    }
    notifyListeners();
  }

  clearPhone() {
    phoneController.text = '';
    canClear = false;
    notifyListeners();
  }

  setPwdObscureText() {
    pwdObscureText = !pwdObscureText;
    notifyListeners();
  }

  login() {
    // DataPicker.show(context!, datas: ['dddd', '1111', '222']);
    IntentUtils.share.goHome(context);
  }
}
