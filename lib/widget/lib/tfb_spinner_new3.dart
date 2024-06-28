import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_header.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu.dart';
import 'package:omt/widget/lib/drop_menu/src/gzx_dropdown_menu_controller.dart';

class TfbSpinnerNew3 extends StatefulWidget {
  ///数据
  final List<IdNameValue> datas;

  ///搜索占位符，不为空，有搜索，为空不显示搜索
  final String? hintText;

  ///选择完成
  final ValueChanged<List<IdNameValue>?>? onPicked;
  final DropdownMenuChange? onTap;

  ///提交搜索
  final ValueChanged<String>? onSubmitted;

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
  final DateTime? startTime;
  final DateTime? endTime;
  final String? timeShowFormat; // = 'MM.dd',
  final String? timeFormat; // = 'MM.dd',
  final OnDateTimePick? onDateTimePick;

  const TfbSpinnerNew3(
      {super.key,
      required this.datas,
      this.hintText,
      this.onPicked,
      this.onTap,
      this.onSubmitted,
      this.childrenAboveOfSpinner,
      this.childrenBelowOfSpinner,
      this.childAboveOfGZXDropDownMenuPositioned,
      required this.child,
      this.padding,
      this.margin,
      this.startTime,
      this.endTime,
      this.timeFormat,
      this.timeShowFormat,
      this.onDateTimePick});

  @override
  State<TfbSpinnerNew3> createState() => _TfbSpinnerNew3State();
}

class _TfbSpinnerNew3State extends State<TfbSpinnerNew3> {
  //标题当前选中项
  int currentIndex = -1;
  final GlobalKey _stackKey = GlobalKey();
  List<GZXDropDownHeaderItem> items = [];
  List<GZXDropdownMenuBuilder> menus = [];
  final GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  IdNameValue? subListParent;
  String? timeStr;

  void _setTimeStr(DateTime? startTime, DateTime? endTime) {
    if (null != startTime && null != endTime) {
      timeStr =
          '${BaseTimeUtils.dateToTimeStr(startTime, format: widget.timeShowFormat)}-${BaseTimeUtils.dateToTimeStr(endTime, format: widget.timeShowFormat)}';
    } else if (null != startTime) {
      timeStr =
          BaseTimeUtils.dateToTimeStr(startTime, format: widget.timeShowFormat);
    } else if (null != endTime) {
      timeStr =
          BaseTimeUtils.dateToTimeStr(endTime, format: widget.timeShowFormat);
    }
  }

  //当前选择
  @override
  void initState() {
    _setTimeStr(widget.startTime, widget.endTime);
    super.initState();
  }

  buildDropdownListWidget(
      IdNameValue? data, void Function(IdNameValue item, bool hide) itemOnTap) {
    if (data == null || (data.children?.length ?? 0) == 0) {
      return Container();
    } else {
      var firstList = buildListView(data, true, (select) {
        if (!BaseSysUtils.empty(select.selectSub?.children)) {
          setState(() {});
          subListParent = select.selectSub;
        } else {
          setState(() {});
          subListParent = null;
          itemOnTap.call(select, true);
        }
      });

      subListParent = data.selectSub;
      if (!BaseSysUtils.empty(subListParent?.children)) {
        int length1 = data.children?.length ?? 0;
        int length2 = subListParent?.children?.length ?? 0;
        int length3 = subListParent?.selectSub?.children?.length ?? 0;
        int length4 =
            subListParent?.selectSub?.selectSub?.children?.length ?? 0;
        int length5 =
            subListParent?.selectSub?.selectSub?.selectSub?.children?.length ??
                0;
        int length6 = subListParent?.selectSub?.selectSub?.selectSub?.selectSub
                ?.children?.length ??
            0;
        int length7 = subListParent?.selectSub?.selectSub?.selectSub?.selectSub
                ?.selectSub?.children?.length ??
            0;

        var l = SysUtils.getMax(
            [length1, length2, length3, length4, length5, length6, length7]);
        if (l > 5) {
          l = 5;
        }
        if (l < 5) {
          l = 5;
        }

        var hasLevel2 = !BaseSysUtils.empty(subListParent?.children);
        var hasLevel3 = !BaseSysUtils.empty(subListParent?.selectSub?.children);
        var hasLevel4 =
            !BaseSysUtils.empty(subListParent?.selectSub?.selectSub?.children);
        var hasLevel5 = !BaseSysUtils.empty(
            subListParent?.selectSub?.selectSub?.selectSub?.children);
        var hasLevel6 = !BaseSysUtils.empty(subListParent
            ?.selectSub?.selectSub?.selectSub?.selectSub?.children);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100,
              color: ColorUtils.colorWindow,
              height: 50.0 * l,
              child: firstList,
            ),
            ...hasLevel2
                ? [
                    const LineView(
                      width: 1,
                      height: double.infinity,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0 * l,
                        child: buildListView(subListParent!, true, (data) {
                          itemOnTap.call(data,
                              BaseSysUtils.empty(data.selectSub?.children));
                        }),
                      ),
                    )
                  ]
                : [],
            ...hasLevel3
                ? [
                    const LineView(
                      width: 1,
                      height: double.infinity,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0 * l,
                        child: buildListView(subListParent!.selectSub!, true,
                            (data) {
                          itemOnTap.call(data,
                              BaseSysUtils.empty(data.selectSub?.children));
                        }),
                      ),
                    ),
                  ]
                : [],
            ...hasLevel4
                ? [
                    const LineView(
                      width: 1,
                      height: double.infinity,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0 * l,
                        child: buildListView(
                            subListParent!.selectSub!.selectSub!, true, (data) {
                          itemOnTap.call(data,
                              BaseSysUtils.empty(data.selectSub?.children));
                        }),
                      ),
                    ),
                  ]
                : [],
            ...hasLevel5
                ? [
                    const LineView(
                      width: 1,
                      height: double.infinity,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0 * l,
                        child: buildListView(
                            subListParent!.selectSub!.selectSub!.selectSub!,
                            true, (data) {
                          itemOnTap.call(data,
                              BaseSysUtils.empty(data.selectSub?.children));
                        }),
                      ),
                    ),
                  ]
                : [],
            ...hasLevel6
                ? [
                    const LineView(
                      width: 1,
                      height: double.infinity,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0 * l,
                        child: buildListView(
                            subListParent!
                                .selectSub!.selectSub!.selectSub!.selectSub!,
                            true, (data) {
                          itemOnTap.call(data,
                              BaseSysUtils.empty(data.selectSub?.children));
                        }),
                      ),
                    ),
                  ]
                : []
          ],
        );
      } else {
        return firstList;
      }
    }
  }

  ListView buildListView(
      IdNameValue data, bool children, void Function(IdNameValue item) itemOnTap) {
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
        Color selectedColor = ColorUtils.colorBlueLite;
        GestureTapCallback tap;
        if (data.isMultiple == true) {
          selectedColor = (item.isSelected == true)
              ? ColorUtils.colorAccent
              : ColorUtils.colorBlueLite;
          tap = () {
            setState(() {
              item.isSelected = !(item.isSelected ?? false);
            });
          };
        } else {
          selectedColor = (data.selectSub?.itemId == item.itemId)
              ? ColorUtils.colorAccent
              : ColorUtils.colorBlueLite;
          tap = () {
            item.selectSub = null;
            data.selectSub = item;
            itemOnTap(data);
          };
        }
        return Clickable(
          onTap: tap,
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
                      color: selectedColor,
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

  Widget _buildSearchView() {
    return Visibility(
      visible: widget.hintText?.isNotEmpty ?? false,
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 10),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: ColorUtils.colorBlackRader,
          ),
        ),
        child: TextField(
          style: const TextStyle(
            fontSize: 12,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 6),
            hintText: widget.hintText,
            hintStyle:
                const TextStyle(fontSize: 12, color: ColorUtils.colorBlackLiteLite),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (t) {
            t = t.replaceAll(' ', '');
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(t);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    menus.clear();
    if (!BaseSysUtils.empty(widget.datas)) {
      for (var data in widget.datas) {
        var name2 = data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub
                ?.selectSub?.selectSub?.showName ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub
                ?.selectSub?.showName ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub
                ?.showName ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.showName ??
            data.selectSub?.selectSub?.selectSub?.showName ??
            data.selectSub?.selectSub?.showName ??
            data.selectSub?.showName ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub
                ?.selectSub?.selectSub?.name ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub
                ?.selectSub?.name ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.selectSub?.name ??
            data.selectSub?.selectSub?.selectSub?.selectSub?.name ??
            data.selectSub?.selectSub?.selectSub?.name ??
            data.selectSub?.selectSub?.name ??
            data.selectSub?.name;
        if (-1 == data.selectSub?.id) {
          name2 = null;
        }
        items.add(GZXDropDownHeaderItem(name2 ?? data.name ?? '',
            flex: data.flex, iconSize: 11));
        var itemSize = data.children?.length ?? 0;

        if (itemSize != 0) {
          for (var i in data.children!) {
            if (!BaseSysUtils.empty(i.children)) {
              if (itemSize < i.children!.length) {
                itemSize = i.children!.length;
              }
            }
          }
        }

        if (itemSize == 0) {
          itemSize = 0;
        } else if (itemSize < 5) {
          itemSize = 5;
        } else {
          itemSize = 5;
        }

        menus.add(GZXDropdownMenuBuilder(
          dropDownHeight: 50.0 * (itemSize),
          dropDownWidget: buildDropdownListWidget(data, (item, hide) {
            if (hide) _dropdownMenuController.hide();
            widget.onPicked?.call(widget.datas);
            setState(() {});
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
            null == widget.startTime
                ? _buildSearchView()
                : Row(
                    children: [
                      TextView(
                        timeStr,
                        bgColor: ColorUtils.colorWhite,
                        color: ColorUtils.colorBlackLite,
                        border: true,
                        height: 30,
                        radius: 4,
                        margin: const EdgeInsets.only(top: 15, bottom: 10, left: 16),
                        borderRadius: BorderRadius.only(
                            topLeft: 4.toRadius(), bottomLeft: 4.toRadius()),
                        borderColor: '#F0F0F0'.toColor(),
                        size: 13,
                        onTap: () {
                          DateTimePicker.show(context,
                              dateFormat: widget.timeFormat,
                              showEnd: null != widget.endTime,
                              nowStartDate: widget.startTime,
                              nowEndDate: widget.endTime,
                              onDateTimePick: (start, end) {
                            setState(() {
                              widget.onDateTimePick?.call(start, end);
                              _setTimeStr(start, end);
                            });
                          });
                        },
                        padding: const EdgeInsets.only(
                            top: SizeUtils.paddingVertical,
                            bottom: SizeUtils.paddingVertical,
                            left: 10,
                            right: 10),
                        rightIcon: source('home/ic_down'),
                        rightIconMargin: const EdgeInsets.only(left: 6),
                        rightIconColor: ColorUtils.colorBlackLite,
                        rightIconWidth: 8,
                        rightIconHeight: 8,
                      ),
                      _buildSearchView().addExpanded()
                    ],
                  ),
            Container(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
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
                style:
                    const TextStyle(fontSize: 12, color: ColorUtils.colorBlackLite),
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
            setState(() {});
          },
          dropdownMenuChanging: (isShow, index) {
            // if (isShow == true &&
            //     null != index &&
            //     BaseSysUtils.empty(widget.datas[index].children)) {
            widget.onTap?.call(isShow, index);
            // _dropdownMenuController.hide();
            // }
            setState(() {});
          },
        ),
      ],
    );
  }
}
