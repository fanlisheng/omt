import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayo_package/kayo_package.dart';

class InputView extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;

  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Color? lineColor;
  final bool? showBorder;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? radius;
  final double? borderWidth;
  final Alignment? alignment;
  final TextAlign? textAlign;
  final Color? textColor;
  final Color? hintTextColor;
  final double? hintTextSize;
  final double? textSize;
  final int? maxLenth;
  final int? maxLine;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClick;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final bool? editable;
  final TextStyle? textStyle;

  const InputView({
    Key? key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.lineColor,
    this.showBorder = false,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.radius,
    this.borderWidth,
    this.alignment = Alignment.centerLeft,
    this.textAlign = TextAlign.left,
    this.textColor,
    this.hintTextColor,
    this.hintTextSize,
    this.textSize,
    this.maxLenth,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLine,
    this.editable = true,
    this.onClick,
    this.textStyle,
  }) : super(key: key);

  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  onClick() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          onTap: null == widget.onClick ? onClick : widget.onClick,
          inputFormatters: widget.inputFormatters,
          style: null == widget.textStyle
              ? TextStyle(
                  color: widget.textColor,
                  fontSize: widget.textSize,
                )
              : widget.textStyle,
          autocorrect: false,
          enabled: widget.editable,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign ?? TextAlign.start,
          maxLength: widget.maxLenth,
          // maxLengthEnforced: false,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          maxLines: widget.maxLine ?? 1,
          textInputAction: TextInputAction.done,
          keyboardType: widget.keyboardType,
          controller: widget.controller ?? TextEditingController(),
          onChanged: widget.onChanged,
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            contentPadding: widget.padding ?? EdgeInsets.all(0),
            isDense: true,
            border: widget.showBorder == true
                ? OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.blue,

                      ///设置边框的粗细
                      width: 0.5,
                    ),
                  )
                : InputBorder.none,

            ///设置输入框可编辑时的边框样式
            enabledBorder: widget.showBorder == true
                ? OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.blue,

                      ///设置边框的粗细
                      width: 0.5,
                    ),
                  )
                : InputBorder.none,

            ///用来配置输入框获取焦点时的颜色
            focusedBorder: widget.showBorder == true
                ? OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.blue,

                      ///设置边框的粗细
                      width: 0.5,
                    ),
                  )
                : InputBorder.none,
            hintText: widget.hintText ?? '输入关键字搜索',
            hintStyle: TextStyle(
                fontSize: widget.hintTextSize ?? 13,
                color: widget.hintTextColor ?? '#999999'.toColor()),
          ),
        ),
      ],
    );
  }
}
