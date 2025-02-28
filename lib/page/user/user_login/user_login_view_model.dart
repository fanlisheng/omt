import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get_mac_address/get_mac_address.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/http/http_manager.dart';
import 'package:omt/page/user/user_login/user_position_selection_page.dart';
import 'package:omt/utils/auth_utils.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/shared_utils.dart';

import '../../../bean/common/id_name_value.dart';
import '../../../http/http_query.dart';

///
///  omt
///  user_login_view_model.dart
///  登录
///
///  Created by kayoxu on 2024-03-05 at 15:04:21
///  Copyright © 2024 .. All rights reserved.
///

class UserLoginViewModel extends BaseViewModelRefresh<UserInfoData> {
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

  String selectedProject = "成都项目";
  List<String> projectList = ["成都项目"];

  // final _getMacAddressPlugin = GetMacAddress();
  String _macAddress = '';

  @override
  void initState() async {
    super.initState();
    initPlatformState();

    phoneController = TextEditingController(text: 'admin');
    pwdController = TextEditingController(text: '123456');
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

  login() async {
    var phone = phoneController.text;
    var pwd = pwdController.text;

    if (BaseSysUtils.empty(phone)) {
      LoadingUtils.showInfo(data: '请输入账号');
      return;
    }

    if (BaseSysUtils.empty(pwd)) {
      LoadingUtils.showInfo(data: '请输入密码');
      return;
    }
    UserInfoData userInfoData = UserInfoData();
    HttpQuery.share.userLoginService.login(
        phone: phone,
        password: pwd,
        mac: _macAddress,
        onSuccess: (data) async {
          LogUtils.info(msg: data);
          if (data == null) return;
          userInfoData.token = data["token"];
          userInfoData.phone = phone;
          await SharedUtils.setUserInfo(userInfoData);
          HttpQuery.share.userLoginService.getPositions(
              onSuccess: (List<IdNameValue>? data1) async {
            LogUtils.info(msg: data1);
            if (data1 == null || data1.isEmpty || data1.first.id == null) {
              return;
            }
            if (data1.length == 1) {
              requestConfirm(data1.first.id!);
            } else {
              final result = await showDialog<IdNameValue>(
                context: context!,
                builder: (context) => Dialog(
                  backgroundColor: ColorUtils.colorWhite, // 背景颜色
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)), // 去掉圆角
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6, // 设置高度为屏幕的80%
                    width: MediaQuery.of(context).size.width * 0.4,  // 设置宽度为屏幕的60%
                    child: UserPositionSelectionPage(positions: data1),
                  ),
                ),
              );
              if (result != null) {
                requestConfirm(result.id!);
              }
            }
          });
        });
  }

  requestConfirm(int id) {
    HttpQuery.share.userLoginService.confirm(
        positionId: id,
        onSuccess: (data2) async {
          if (data2 == null) return;
          UserInfoData? userInfoData = await SharedUtils.getUserInfo();
          if (userInfoData == null) return;
          userInfoData.token = data2["token"];
          await SharedUtils.setUserInfo(userInfoData);
          await AuthUtils.share.init(userLoginData: userInfoData);
          IntentUtils.share.goHome(context);
        });
  }

  login1() async {
    var phone = phoneController.text;
    var pwd = pwdController.text;

    if (BaseSysUtils.empty(phone)) {
      LoadingUtils.showInfo(data: '请输入账号');
      return;
    }

    if (BaseSysUtils.empty(pwd)) {
      LoadingUtils.showInfo(data: '请输入密码');
      return;
    }

    UserInfoData userInfoData = UserInfoData()..phone = phone;
    bool canNext = true;

    switch (phone) {
      case 'admin':
        if (!BaseSysUtils.equals(pwd, '123456')) {
          canNext = false;
        } else {
          userInfoData.userPermissions = [
            UserPermission()
              ..id = AuthEnum.menuVideoConfiguration
              ..name = '视频配置',
            UserPermission()
              ..id = AuthEnum.menuCameraConfiguration
              ..name = '摄像头配置',
            UserPermission()
              ..id = AuthEnum.menuTools
              ..name = '小工具',
            UserPermission()
              ..id = AuthEnum.menuOnePicture
              ..name = '一张图'
          ];
        }
        break;

      case 'zt':
        if (!BaseSysUtils.equals(pwd, '123456')) {
          canNext = false;
        } else {
          userInfoData.userPermissions = [
            UserPermission()
              ..id = AuthEnum.menuCameraConfiguration
              ..name = '摄像头配置'
          ];
        }
        break;
      case 'tfb':
        if (!BaseSysUtils.equals(pwd, '123456')) {
          canNext = false;
        } else {
          userInfoData.userPermissions = [
            UserPermission()
              ..id = AuthEnum.menuVideoConfiguration
              ..name = '视频配置',
          ];
        }
        break;
      case 'labelme':
        if (!BaseSysUtils.equals(pwd, '123456')) {
          canNext = false;
        } else {
          userInfoData.userPermissions = [
            UserPermission()
              ..id = AuthEnum.menuLabelMe
              ..name = '数据标注',
          ];
        }
        break;
      default:
        break;
    }

    if (canNext == false) {
      LoadingUtils.showInfo(data: '账号或密码不正确');
      return;
    }

    await SharedUtils.setUserInfo(userInfoData);

    await AuthUtils.share.init(userLoginData: userInfoData);

    IntentUtils.share.goHome(context);
  }

  Future<void> initPlatformState() async {
    String macAddress;
    try {
      // macAddress =
      //     await _getMacAddressPlugin.getMacAddress() ?? '';
      macAddress = "";
    } on PlatformException {
      macAddress = '';
    }
    _macAddress = macAddress;
    notifyListeners();
  }

}
