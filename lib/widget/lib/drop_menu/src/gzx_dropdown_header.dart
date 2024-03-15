import 'package:flutter/material.dart';
import 'package:kayo_package/extension/base_string_extension.dart';
import 'package:kayo_package/extension/base_widget_extension.dart';
import 'package:omt/utils/color_utils.dart';

import 'gzx_dropdown_menu_controller.dart';

/// Signature for when a tap has occurred.
typedef OnItemTap<T> = void Function(T value);

/// Dropdown header widget.
class GZXDropDownHeader extends StatefulWidget {
  final Color color;
  final double borderWidth;
  final Color borderColor;
  final TextStyle style;
  final TextStyle? dropDownStyle;
  final double iconSize;
  final Color iconColor;
  final Color? iconDropDownColor;

//  final List<String> menuStrings;
  final double height;
  final double dividerHeight;
  final Color dividerColor;
  final GZXDropdownMenuController controller;
  final OnItemTap? onItemTap;
  final List<GZXDropDownHeaderItem> items;
  final GlobalKey stackKey;

  /// Creates a dropdown header widget, Contains more than one header items.
  GZXDropDownHeader({
    Key? key,
    required this.items,
    required this.controller,
    required this.stackKey,
    this.style = const TextStyle(color: Color(0xFF666666), fontSize: 13),
    this.dropDownStyle,
    this.height = 32,
    this.iconColor = const Color(0xffB4B4B4),
    this.iconDropDownColor,
    this.iconSize = 20,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFF0F0F0),
    this.dividerHeight = 20,
    this.dividerColor = const Color(0xFFeeede6),
    this.onItemTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  _GZXDropDownHeaderState createState() => _GZXDropDownHeaderState();
}

class _GZXDropDownHeaderState extends State<GZXDropDownHeader>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;
  late double _screenWidth;
  late int _menuCount;
  GlobalKey _keyDropDownHeader = GlobalKey();
  TextStyle? _dropDownStyle;
  Color? _iconDropDownColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(_onController);
  }

  _onController() {
    if (mounted) {
      setState(() {});
    }
//    print(widget.controller.menuIndex);
  }

  @override
  Widget build(BuildContext context) {
//    print('_GZXDropDownHeaderState.build');

    _dropDownStyle = widget.dropDownStyle ??
        const TextStyle(color: ColorUtils.colorAccent, fontSize: 12);
    _iconDropDownColor = widget.iconDropDownColor ?? ColorUtils.colorAccent;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _menuCount = widget.items.length;

    // var gridView = GridView.count(
    //   physics: NeverScrollableScrollPhysics(),
    //   crossAxisCount: _menuCount,
    //   mainAxisSpacing: 12,
    //   crossAxisSpacing: 12,
    //   childAspectRatio: (_screenWidth / _menuCount) / widget.height,
    //   children: widget.items.map<Widget>((item) {
    //     return _menu(item);
    //   }).toList(),
    // );

    List<Widget> list = [];
    for (var i in widget.items) {
      list.add(SizedBox(
        width: 12,
      ));
      list.add(_menu(i));
    }
    list.removeAt(0);
    // var list = widget.items.map<Widget>((item) {
    //     return _menu(item);
    //   }).toList();

    var gridView = Row(
      children: list,
    );

    return Container(
      key: _keyDropDownHeader,
      height: widget.height,
//      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: gridView,
    );
  }

  dispose() {
    super.dispose();
  }

  Widget _menu(GZXDropDownHeaderItem item) {
    int index = widget.items.indexOf(item);
    int menuIndex = widget.controller.menuIndex;
    _isShowDropDownItemWidget = index == menuIndex && widget.controller.isShow;

    return GestureDetector(
      onTap: () {
        final RenderBox? overlay =
            widget.stackKey.currentContext!.findRenderObject() as RenderBox?;

        final RenderBox dropDownItemRenderBox =
            _keyDropDownHeader.currentContext!.findRenderObject() as RenderBox;

        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
//        print("POSITION : $position ");
        var size = dropDownItemRenderBox.size;
//        print("SIZE : $size");

        widget.controller.dropDownMenuTop = size.height + position.dy;

        if (index == menuIndex) {
          if (widget.controller.isShow) {
            widget.controller.hide();
          } else {
            widget.controller.show(index);
          }
        } else {
          if (widget.controller.isShow) {
            widget.controller.hide(isShowHideAnimation: false);
          }
          widget.controller.show(index);
        }

        if (widget.onItemTap != null) {
          widget.onItemTap!(index);
        }

        setState(() {});
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _isShowDropDownItemWidget
                          ? _dropDownStyle
                          : widget.style.merge(item.style),
                    ),
                  ),
                  Icon(
                    !_isShowDropDownItemWidget
                        ? item.iconData ?? Icons.keyboard_arrow_down
                        : item.iconDropDownData ??
                            item.iconData ??
                            Icons.keyboard_arrow_up,
                    color: _isShowDropDownItemWidget
                        ? _iconDropDownColor
                        : item.style?.color ?? widget.iconColor,
                    size: item.iconSize ?? widget.iconSize,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
            index == widget.items.length - 1
                ? Container()
                : Container(
                    height: widget.dividerHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: widget.dividerColor, width: 1),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ).addExpanded(flex: item.flex ?? 1);
  }
}

class GZXDropDownHeaderItem {
  final String title;
  final IconData? iconData;
  final IconData? iconDropDownData;
  final double? iconSize;
  final int? flex;
  final TextStyle? style;

  GZXDropDownHeaderItem(
    this.title, {
    this.iconData,
    this.iconDropDownData,
    this.iconSize,
    this.style,
    this.flex,
  });
}
