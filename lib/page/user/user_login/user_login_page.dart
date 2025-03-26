import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/combobox.dart';
import 'package:omt/widget/lib/register_ver_button.dart';
import '../../../theme.dart';
import 'user_login_view_model.dart';

///
///  omt
///  user_login_page.dart
///  登录
///
///  Created by kayoxu on 2024-03-05 at 15:04:21
///  Copyright © 2024 .. All rights reserved.
///
///
///

import 'package:fluent_ui/fluent_ui.dart';

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<UserLoginViewModel>(
        model: UserLoginViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          var windowWidth = BaseSysUtils.getWidth(context) / 5 * 3;
          if (windowWidth < 600) {
            windowWidth = 600;
          }

          var column = _buildColumn2(model);

          return ui.FluentTheme(
            data: FluentThemeData(
              brightness: Brightness.light, // 强制此页面为亮色模式
              accentColor: AppTheme().color,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 490,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: ImageView(
                      src: source('login/ic_bg'),
                      fit: BoxFit.cover,
                      bgColor: ColorUtils.colorRed,
                    ),
                  ),
                ),
                Expanded(
                  flex: 590,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      color: ColorUtils.colorWhite,
                      child: rightView(model),
                    ),
                  ),
                ),
              ],
            ),
          );

          return _buildStack(context, windowWidth, column);
        });
  }

  Widget rightView(UserLoginViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      height: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ImageView(
                src: source("ic_logo"),
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 6),
              const Text.rich(
                TextSpan(
                  text: '福立盟运维配置客户端',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: ColorUtils.colorBlack,
                    fontWeight: FontWeight.w900,
                    height: 1.5,
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          // SizedBox(height: 100,),
          Expanded(flex: 100, child: Container()),
          ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 220.0, minWidth: 220.0, maxHeight: 299.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "欢迎登录，\n福立盟运维配置客户端",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorUtils.colorBlack,
                      fontWeight: FontWeight.w500),
                ),
                _titleView("项目"),
                FComboBox(
                  selectedValue: model.selectedProject,
                  items: model.projectList,
                  onChanged: (v) {},
                  placeholder: "",
                  bgColor: "#EEF6F5".toColor(),
                ),
                _titleView("账号"),
                ui.TextBox(
                  placeholder: '请输入账号',
                  controller: model.phoneController,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                  cursorColor: ui.Colors.teal,
                  decoration: ui.WidgetStatePropertyAll(
                      BoxDecoration(color: "#EEF6F5".toColor())),
                ),
                _titleView("密码"),
                ui.TextBox(
                  placeholder: '请输入密码',
                  controller: model.pwdController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                  cursorColor: ui.Colors.teal,
                  decoration: ui.WidgetStatePropertyAll(
                      BoxDecoration(color: "#EEF6F5".toColor())),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ui.FilledButton(
                        style: const ui.ButtonStyle(
                          backgroundColor:
                              ui.WidgetStatePropertyAll(ColorUtils.colorGreen),
                        ),
                        onPressed: () {
                          model.login();
                        },
                        child: TextView(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          '确定',
                          size: 12,
                          fontWeight: FontWeight.w500,
                          textDarkOnlyOpacity: true,
                          color: ColorUtils.colorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // FractionallySizedBox(
          //   heightFactor: 0.25,
          //   child: Container(
          //   ),
          // ),
          Expanded(flex: 140, child: Container()),
        ],
      ),
    );
  }

  ui.Container _titleView(String name) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 12,
            color: ColorUtils.colorBlackLiteLite,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

ui.Stack _buildStack(
    ui.BuildContext context, double windowWidth, ui.Column column) {
  return Stack(
    children: [
      ImageView(
        src: source('login/ic_bg'),
        fit: BoxFit.fitWidth,
        // color: context.isDark ? ColorUtils.colorBlack : null,
        width: double.infinity,
      ),
      ToolBar(
        resizeToAvoidBottomPadding: false,
        elevation: 0,
        backgroundColor: ColorUtils.transparent,
        appbarColor: ColorUtils.transparent,
        actions: SysUtils.appBarActions(context),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: windowWidth,
            child: column,
          ),
        ),
      )
    ],
  );
}

ui.Column _buildColumn2(UserLoginViewModel model) {
  return Column(
    children: <Widget>[
      TextView(
        '欢迎登录',
        margin: const EdgeInsets.only(top: 30, bottom: 30, left: 32),
        color: ColorUtils.colorBlack,
        alignment: Alignment.centerLeft,
        size: 32,
      ),
      _editView(
        model,
        hintText: '请输入账号',
        title: '账号',
        showBtn: false,
        focusNode: model.node,
        showObscureText: model.canClear,
        keyboardType: TextInputType.emailAddress,
        controller: model.phoneController,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(11),
//                          WhitelistingTextInputFormatter.digitsOnly
        ],
        onChanged: model.onEditValueChange,
      ),
      _editView(
        model,
        hintText: '请输入密码',
        title: '密码',
        obscureText: model.pwdObscureText,
        keyboardType: false ? FlutterKeyboard.number : TextInputType.text,
        controller: model.pwdController,
        onChanged: model.onEditValueChange,
      ),
      TextView(
        // (isyzm ?? false) ? '验证码错误请重新填写' : '手机号或密码错误请重新输入',
        model.tips,
        size: 13,
        color: ColorUtils.colorRedGradientStart,
        margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
        maxLine: 2,
        alignment: Alignment.centerLeft,
        textAlign: TextAlign.center,
      ),
      Container(
        decoration: BoxDecoration(
          color: model.canLogin
              ? ColorUtils.colorBlue
              : ColorUtils.colorBlue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 15),
              blurRadius: 15,
              color: ColorUtils.colorBlue.withOpacity(0.15),
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 48, left: 32, right: 32),
        height: 58,
        child: TextView(
          '登录',
          size: 17,
          color: ColorUtils.colorWhite.dark,
          fontWeight: FontWeight.bold,
          alignment: Alignment.center,
          onTap: () {
            model.login();
          },
        ),
      ),

      TextView(
        '视频配置：账号tfb，密码123456\n摄像头配置：账号zt，密码123456\n管理员账号admin，密码123456',
        margin: const EdgeInsets.only(top: 20),
      ),

      const Spacer(),
      // SafeArea(
      //   top: false,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ImageView(
      //         src: source(model.privacy
      //             ? 'login/ic_agree'
      //             : 'login/ic_disagree'),
      //         width: 16,
      //         height: 16,
      //         margin: EdgeInsets.only(top: 0),
      //         padding: EdgeInsets.all(8),
      //         onClick: () {
      //           model.privacy = !model.privacy;
      //           model.notifyListeners();
      //         },
      //       ),
      //       TextView(
      //         '同意',
      //         size: 12,
      //         color: ColorUtils.colorBlackLite,
      //         margin: EdgeInsets.only(top: 0),
      //       ),
      //       TextView(
      //         '《用户协议》',
      //         size: 12,
      //         color: ColorUtils.colorBlue,
      //         margin: EdgeInsets.only(top: 0),
      //         onTap: () {
      //           var s =
      //               'https://tfblue.shomes.cn/tfblueapp/document/privacy_policy_zt';
      //           IntentUtils.share.push(
      //             context,
      //             routeName: RouterPage.WebViewPage,
      //             data: {'url': s},
      //           );
      //         },
      //       ),
      //       TextView(
      //         '《个人信息保护政策》',
      //         size: 12,
      //         color: ColorUtils.colorBlue,
      //         margin: EdgeInsets.only(top: 0),
      //         onTap: () {
      //           var s =
      //               'https://tfblue.shomes.cn/tfblueapp/document/privacy_policy_zt';
      //           IntentUtils.share.push(
      //             context,
      //             routeName: RouterPage.WebViewPage,
      //             data: {'url': s},
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    ],
  );
}

Widget _editView(model,
    {String? hintText,
    TextEditingController? controller,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    bool showObscureText = false,
    bool showBtn = false,
    String? title,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return Container(
    margin: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextView(
          title ?? '',
          size: 14,
          color: ColorUtils.colorWhite,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        Container(
          decoration: BoxDecoration(
            color: 'F3F7FF'.toColor().dark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: EditView(
                  textSize: 14,
                  margin: const EdgeInsets.only(left: 20),
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textColor: ColorUtils.colorBlackLite,
                  hintTextColor: ColorUtils.colorBlackLiteLite,
                  inputFormatters: inputFormatters,
                  controller: controller,
                  showLine: false,
                  hintText: hintText,
                  onChanged: onChanged,
                  focusNode: focusNode,
                ),
              ),
              VisibleView(
                visible: showBtn ? Visible.visible : Visible.gone,
                child: LoginFormCode(
                  available: model.available,
                  availableColor: ColorUtils.colorBlue.dark,
                  countdown: 60,
                  onTapCallback: () {
                    model.getYzm();
                  },
                ),
              ),
              VisibleView(
                visible: showObscureText ? Visible.visible : Visible.gone,
                child: ImageView(
                  src: source('login/ic_delete'),
                  onClick: () {
                    model.clearPhone();
                  },
                  height: 19,
                  width: 19,
                  padding: const EdgeInsets.all(9),
                  radius: 20,
                  fit: BoxFit.fitWidth,
                  margin: const EdgeInsets.only(left: 2, right: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
