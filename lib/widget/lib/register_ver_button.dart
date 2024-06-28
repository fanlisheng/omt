import 'dart:async';


import 'package:kayo_package/kayo_package.dart';

import 'package:flutter/material.dart';
import 'package:omt/utils/color_utils.dart';

class LoginFormCode extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final Function? onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  final Color availableColor;
  final Color unavailableColor;

  const LoginFormCode({super.key, 
    this.countdown = 60,
    this.onTapCallback,
    this.available = false,
    this.availableColor = ColorUtils.colorWhite,
    this.unavailableColor = ColorUtils.colorBlackLiteLite,
  });

  @override
  _LoginFormCodeState createState() => _LoginFormCodeState();
}

class _LoginFormCodeState extends State<LoginFormCode> {
  /// 倒计时的计时器。
  Timer? _timer;

  /// 当前倒计时的秒数。
  int? _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  Color? currentColor;
  Color? currentBgColor;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  bool istap = false;

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
    currentColor = widget.availableColor;
    currentBgColor = ColorUtils.colorBlue;
  }

  // ignore: must_call_super
  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    _timer = null;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        istap = false;
        _cancelTimer();
        _seconds = widget.countdown;
        currentColor = widget.availableColor;
        currentBgColor = ColorUtils.colorBlue;
        _verifyStr = '重新发送';
        setState(() {});
        return;
      }
      _seconds = _seconds! - 1;
      _verifyStr = '$_seconds' 's后重新发送';
      // if (_seconds == 0) {
      //   _verifyStr = '重新发送';
      // }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available
        ? InkWell(
            onTap: (_seconds == widget.countdown)
                ? () {
                    if (istap == false) {
                      if (widget.available) {
                        istap = true;
                        _startTimer();
                        currentColor = widget.unavailableColor;
                        currentBgColor = '#F0F1F3'.toColor();
                        _verifyStr = '$_seconds' 's后重新发送';
                        setState(() {});
                        widget.onTapCallback!();
                      }
                    }
                  }
                : null,
            child: TextView(
              '  $_verifyStr  ',
              color: currentColor ?? ColorUtils.colorBlue,
              size: 14,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 8),
              margin: const EdgeInsets.only(right: 25, left: 5),
            ),
          )
        : InkWell(
            child: TextView(
              '  $_verifyStr  ',
              color: widget.unavailableColor,
              size: 14,
              // borderRadius: BorderRadius.circular(30),
              border: false,
              // bgColor: '#F0F1F3'.toColor(),
              // borderColor: widget.unavailableColor,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 8),
              margin: const EdgeInsets.only(right: 25, left: 5),
            ),
          );
  }
}
