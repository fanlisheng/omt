// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tfblue_app/widget/lib/drop_menu/gzx_dropdown_menu.dart';
// import 'package:kayo_package/kayo_package.dart';
// import 'package:tfblue_app/bean/common/id_name_value.dart';
// import 'package:tfblue_app/bean/common/linkage_data.dart';
// import 'package:tfblue_app/utils/color_utils.dart';
// import 'package:tfblue_app/utils/sys_utils.dart';
//
// class TfbSpinnerMulti extends StatefulWidget {
//   ///数据
//   final List<IdNameValue> datas;
//
//   final List<List<IdNameValue>>? selectedItems;
//
//   ///选择完成
//   final ValueChanged<List<List<IdNameValue>>>? onPick;
//
//   ///Spinner上面的widget
//   final List<Widget>? childrenAboveOfSpinner;
//
//   ///Spinner下面的widget
//   final List<Widget>? childrenBelowOfSpinner;
//
//   ///需要显示的列表或者其他
//   final Widget child;
//
//   ///底部的Widget
//   final Widget? childAboveOfGZXDropDownMenuPositioned;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//
//   const TfbSpinnerMulti(
//       {Key? key,
//       required this.datas,
//       this.onPick,
//       this.childrenAboveOfSpinner,
//       this.childrenBelowOfSpinner,
//       this.childAboveOfGZXDropDownMenuPositioned,
//       required this.child,
//       this.padding,
//       this.margin,
//       this.selectedItems})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _TfbSpinnerMultiState();
// }
//
// class _TfbSpinnerMultiState extends State<TfbSpinnerMulti> {
//   late List<List<IdNameValue>> selectedItems;
//
//   //标题当前选中项
//   int currentIndex = -1;
//   GlobalKey _stackKey = GlobalKey();
//   List<TextView> items = [];
//   List<Widget> menus = [];
//
//   //当前选择
//   @override
//   void initState() {
//     selectedItems = widget.selectedItems ??
//         widget.datas.map((e) {
//           List<IdNameValue> d = [];
//           return d;
//         }).toList();
//
//     super.initState();
//   }
//
//   buildDropdownListWidget(IdNameValue? data, void itemOnTap(IdNameValue item)) {
//     if (data == null || (data.children?.length ?? 0) == 0) {
//       return Container();
//     } else {
//       return ListView.separated(
//         shrinkWrap: true,
//         scrollDirection: Axis.vertical,
//         itemCount: data.children?.length ?? 0,
//         // item 的个数
//         separatorBuilder: (BuildContext context, int index) =>
//             Divider(height: 1.0),
//         // 添加分割线
//         itemBuilder: (BuildContext context, int index) {
//           IdNameValue item = data.children![index];
//           return Clickable(
//             onTap: () {
//               data.selectSub = item;
//               itemOnTap(data);
//             },
//             child: Container(
//               height: 50,
//               child: Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Text(
//                       item.name ?? '',
//                       style: TextStyle(
//                         color: (data.selectSub?.itemId == item.itemId)
//                             ? Theme.of(context).primaryColor
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                   (data.selectSub?.itemId == item.itemId)
//                       ? Icon(
//                           Icons.check,
//                           color: Theme.of(context).primaryColor,
//                           size: 16,
//                         )
//                       : SizedBox(),
//                   SizedBox(
//                     width: 16,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!BaseSysUtils.empty(widget.datas)) {
//       items.clear();
//       menus.clear();
//
//       for (var data in widget.datas) {
//         var name2 = data.selectSub?.name;
//         if (-1 == data.selectSub?.id) {
//           name2 = null;
//         }
//         items.add(TextView(name2 ?? data.name ?? ''));
//
//         menus.add();
//       }
//     }
//
//     return Stack(
//       key: _stackKey,
//       children: <Widget>[
//         Column(
//           children: <Widget>[
//             ...(widget.childrenAboveOfSpinner ?? []),
//             Container(
//               child: GZXDropDownHeader(
//                 items: items,
//                 stackKey: _stackKey,
//                 controller: _dropdownMenuController,
//                 height: 43,
//                 dividerHeight: 0,
//                 borderColor: Colors.transparent,
//                 style:
//                     TextStyle(fontSize: 13, color: ColorUtils.colorBlackLite),
//               ),
//               padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 10),
//               margin: widget.margin,
//               color: Colors.white,
//               height: 43,
//             ),
//             ...(widget.childrenBelowOfSpinner ?? []),
//             Expanded(child: widget.child),
//           ],
//         ),
//         (widget.childAboveOfGZXDropDownMenuPositioned ??
//             SizedBox(
//               height: 0,
//               width: 0,
//             )),
//         GZXDropDownMenu(
//           // controller用于控制menu的显示或隐藏
//           controller: _dropdownMenuController,
//           // 下拉菜单显示或隐藏动画时长
//           animationMilliseconds: 200,
//           // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
//           menus: menus,
//           dropdownMenuChanged: (isShow, index) {},
//           // dropdownMenuChanging: (isShow, index) {
//           //   setState(() {});
//           // },
//         ),
//       ],
//     );
//   }
// }
