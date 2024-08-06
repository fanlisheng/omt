import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_header.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu_controller.dart';

@Deprecated('请使用TfbSpinnerNew3')
class TfbSpinnerNew2 extends StatefulWidget {
  ///数据
  final List<IdNameValue> datas;

  ///选择完成
  final ValueChanged<List<IdNameValue>?>? onPicked;
  final ValueChanged<int?>? onTap;

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

  const TfbSpinnerNew2(
      {super.key,
      required this.datas,
      this.onPicked,
      this.onTap,
      this.childrenAboveOfSpinner,
      this.childrenBelowOfSpinner,
      this.childAboveOfGZXDropDownMenuPositioned,
      required this.child,
      this.padding,
      this.margin});

  @override
  State<TfbSpinnerNew2> createState() => _TfbSpinnerNew2State();
}

class _TfbSpinnerNew2State extends State<TfbSpinnerNew2> {
  //标题当前选中项
  int currentIndex = -1;
  final GlobalKey _stackKey = GlobalKey();
  List<GZXDropDownHeaderItem> items = [];
  List<GZXDropdownMenuBuilder> menus = [];
  final GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  IdNameValue? subListParent;

  //当前选择
  @override
  void initState() {
    super.initState();
  }

  buildDropdownListWidget(
      IdNameValue? data, void Function(IdNameValue item) itemOnTap) {
    if (data == null || (data.children?.length ?? 0) == 0) {
      return Container();
    } else {
      var firstList = buildListView(data, true, (select) {
        if (!BaseSysUtils.empty(select.selectSub?.children)) {
          setState(() {
            subListParent = select.selectSub;
          });
        } else {
          setState(() {
            subListParent = null;
            itemOnTap.call(select);
          });
        }
      });

      if (!BaseSysUtils.empty(subListParent?.children)) {
        return Row(
          children: <Widget>[
            Container(
              width: 100,
              color: ColorUtils.colorWindow,
              height: 50.0 * (subListParent?.children?.length ?? 0),
              child: firstList,
            ),
            const LineView(
              width: 1,
              height: double.infinity,
            ),
            Expanded(
              child: SizedBox(
                height: 50.0 * (subListParent?.children?.length ?? 0),
                child: buildListView(subListParent!, true, itemOnTap),
              ),
            ),
          ],
        );
      } else {
        return firstList;
      }
    }
  }

  ListView buildListView(IdNameValue data, bool children,
      void Function(IdNameValue item) itemOnTap) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: data.children?.length ?? 0,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
        color: children ? ColorUtils.colorWindow : ColorUtils.transparent,
      ),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        IdNameValue item = data.children![index];
        return Clickable(
          onTap: () {
            item.selectSub = null;
            data.selectSub = item;
            itemOnTap(data);
          },
          child: SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    item.name ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: (data.selectSub?.itemId == item.itemId)
                          ? ColorUtils.colorAccent
                          : ColorUtils.colorBlueLite,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!BaseSysUtils.empty(widget.datas)) {
      items.clear();
      menus.clear();

      for (var data in widget.datas) {
        var name2 = data.selectSub?.selectSub?.selectSub?.name ??
            data.selectSub?.selectSub?.name ??
            data.selectSub?.name;
        if (-1 == data.selectSub?.id) {
          name2 = null;
        }
        items.add(
            GZXDropDownHeaderItem(name2 ?? data.name ?? '', flex: data.flex));
        var itemSize = data.children?.length ?? 0;

        // if (!BaseSysUtils.empty(subListParent?.children)) {
        //   var length2 = subListParent!.children!.length;
        //   if (itemSize < length2) {
        //     itemSize = length2;
        //   }
        // }

        if (itemSize != 0) {
          for (var i in data.children!) {
            if (!BaseSysUtils.empty(i.children)) {
              if (itemSize < i.children!.length) {
                itemSize = i.children!.length;
              }
            }
          }
        }

        if (itemSize > 7) {
          itemSize = 7;
        }

        menus.add(GZXDropdownMenuBuilder(
          dropDownHeight: 50.0 * (itemSize),
          dropDownWidget: buildDropdownListWidget(data, (item) {
            setState(() {
              _dropdownMenuController.hide();
              widget.onPicked?.call(widget.datas);
            });
          }),
        ));
      }
    }

    return Stack(
      key: _stackKey,
      children: <Widget>[
        Column(
          children: <Widget>[
            ...(widget.childrenAboveOfSpinner ?? []),
            Container(
              padding:
                  widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
              margin: widget.margin,
              color: Colors.white,
              height: 43,
              child: GZXDropDownHeader(
                items: items,
                stackKey: _stackKey,
                controller: _dropdownMenuController,
                height: 32,
                dividerHeight: 0,
                // borderColor: Colors.transparent,
                style: const TextStyle(
                    fontSize: 13, color: ColorUtils.colorBlackLite),
              ),
            ),
            ...(widget.childrenBelowOfSpinner ?? []),
            Expanded(child: widget.child),
          ],
        ),
        (widget.childAboveOfGZXDropDownMenuPositioned ??
            const SizedBox(
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
          dropdownMenuChanged: (isShow, index) {
            if (isShow == true &&
                null != index &&
                BaseSysUtils.empty(widget.datas[index].children)) {
              // widget.onTap?.call(index);
              _dropdownMenuController.hide();
            }
          },
          dropdownMenuChanging: (isShow, index) {
            if (isShow == true &&
                null != index &&
                BaseSysUtils.empty(widget.datas[index].children)) {
              widget.onTap?.call(index);
              // _dropdownMenuController.hide();
            }
          },
        ),
      ],
    );
  }
}
