import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_header.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu_controller.dart';


class TfbSpinner extends StatefulWidget {
  ///数据
  final List<IdNameValue> datas;

  ///自定义
  final List<GZXDropdownMenuBuilder>? customMenus;

  ///选择完成
  final ValueChanged<List<IdNameValue>?>? onPick;

  ///Spinner上面的widget
  final List<Widget>? childrenAboveOfSpinner;

  ///Spinner下面的widget
  final List<Widget>? childrenBelowOfSpinner;

  ///需要显示的列表或者其他
  final Widget child;

  ///底部的Widget
  final Widget? childAboveOfGZXDropDownMenuPositioned;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final GZXDropdownMenuController? dropdownMenuController;

  const TfbSpinner(
      {Key? key,
      required this.datas,
      this.customMenus,
      this.onPick,
      this.childrenAboveOfSpinner,
      this.childrenBelowOfSpinner,
      this.childAboveOfGZXDropDownMenuPositioned,
      required this.child,
      this.padding,
      this.margin,
      this.dropdownMenuController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TfbSpinnerState();
}

class _TfbSpinnerState extends State<TfbSpinner> {
  //标题当前选中项
  int currentIndex = -1;
  GlobalKey _stackKey = GlobalKey();
  List<GZXDropDownHeaderItem> items = [];
  List<GZXDropdownMenuBuilder> menus = [];
  late GZXDropdownMenuController _dropdownMenuController;

  //当前选择
  @override
  void initState() {
    super.initState();
    if (widget.dropdownMenuController != null) {
      _dropdownMenuController = widget.dropdownMenuController!;
    } else {
      _dropdownMenuController = GZXDropdownMenuController();
    }
  }

  buildDropdownListWidget(IdNameValue? data, void itemOnTap(IdNameValue item)) {
    if (data == null || (data.children?.length ?? 0) == 0) {
      return Container();
    } else {
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.children?.length ?? 0,
        // item 的个数
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1.0,color: ColorUtils.colorBlackLiteLite.withOpacity(.2),),
        // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          IdNameValue item = data.children![index];
          return Clickable(
            onTap: () {
              data.selectSub = item;
              itemOnTap(data);
            },
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      item.name ?? '',
                      style: TextStyle(
                        color: (data.selectSub?.itemId == item.itemId)
                            ? ColorUtils.colorAccent
                            : ColorUtils.colorBlackLite,
                        fontSize: 13
                      ),
                    ),
                  ),
                  // (data.selectSub?.itemId == item.itemId)
                  //     ? Icon(
                  //         Icons.check,
                  //         color: Theme.of(context).primaryColor,
                  //         size: 16,
                  //       )
                  //     : SizedBox(),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!BaseSysUtils.empty(widget.datas)) {
      items.clear();
      menus.clear();

      if ((widget.customMenus?.length ?? 0) > 0) {
        menus.addAll(widget.customMenus ?? []);
      }
      int i = 0;
      for (var data in widget.datas) {
        var name2 = data.selectSub?.name;
        if (-1 == data.selectSub?.id) {
          name2 = null;
        }
        items.add(GZXDropDownHeaderItem(name2 ?? data.name ?? ''));
        var itemSize = data.children?.length ?? 0;
        if (itemSize > 7) {
          itemSize = 7;
        }
        if (i >= menus.length) {
          menus.add(GZXDropdownMenuBuilder(
            dropDownHeight: 50.0 * (itemSize),
            dropDownWidget: buildDropdownListWidget(data, (item) {
              setState(() {
                _dropdownMenuController.hide();
                widget.onPick?.call(widget.datas);
              });
            }),
          ));
        }
        i++;
      }
    }

    return Stack(
      key: _stackKey,
      children: <Widget>[
        Column(
          children: <Widget>[
            ...(widget.childrenAboveOfSpinner ?? []),
            Container(
              child: GZXDropDownHeader(
                items: items,
                stackKey: _stackKey,
                controller: _dropdownMenuController,
                height: 32,
                dividerHeight: 0,
                // borderColor: Colors.transparent,
                style:
                    TextStyle(fontSize: 13, color: ColorUtils.colorBlackLite),
              ),
              padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 10),
              margin: widget.margin,
              color: Colors.white,
              height: 43,
            ),
            ...(widget.childrenBelowOfSpinner ?? []),
            Expanded(child: widget.child),
          ],
        ),
        (widget.childAboveOfGZXDropDownMenuPositioned ??
            SizedBox(
              height: 0,
              width: 0,
            )),
        GZXDropDownMenu(
          // controller用于控制menu的显示或隐藏
          controller: _dropdownMenuController,
          // 下拉菜单显示或隐藏动画时长
          animationMilliseconds: 200,
          // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
          menus: menus,
          dropdownMenuChanged: (isShow, index) {},
          // dropdownMenuChanging: (isShow, index) {
          //   setState(() {});
          // },
        ),
      ],
    );
  }
}
