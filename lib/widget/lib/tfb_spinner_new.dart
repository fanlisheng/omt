import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_header.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu_controller.dart';

@Deprecated('请使用TfbSpinnerNew3')
class TfbSpinnerNew extends StatefulWidget {
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

  const TfbSpinnerNew(
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
  State<TfbSpinnerNew> createState() => _TfbSpinnerNewState();
}

class _TfbSpinnerNewState extends State<TfbSpinnerNew> {
  //标题当前选中项
  int currentIndex = -1;
  final GlobalKey _stackKey = GlobalKey();
  List<GZXDropDownHeaderItem> items = [];
  List<GZXDropdownMenuBuilder> menus = [];
  final GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

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
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.children?.length ?? 0,
        // item 的个数
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1.0),
        // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          IdNameValue item = data.children![index];
          return Clickable(
            onTap: () {
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
                  // (data.selectSub?.itemId == item.itemId)
                  //     ? Icon(
                  //         Icons.check,
                  //         color: ColorUtils.colorAccent,
                  //         size: 16,
                  //       )
                  //     : SizedBox(),
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
  }

  @override
  Widget build(BuildContext context) {
    if (!BaseSysUtils.empty(widget.datas)) {
      items.clear();
      menus.clear();

      for (var data in widget.datas) {
        var name2 = data.selectSub?.name;
        if (-1 == data.selectSub?.id) {
          name2 = null;
        }
        items.add(
            GZXDropDownHeaderItem(name2 ?? data.name ?? '', flex: data.flex));
        var itemSize = data.children?.length ?? 0;

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
