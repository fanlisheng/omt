import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';

class TfbSpinnerBottom extends StatefulWidget {
  final Color? nomalColor;
  final Color? selectedColor;
  final List<IdNameValue>? datas;
  final ValueChanged<List<IdNameValue>?>? onPick;

  const TfbSpinnerBottom(
      {Key? key, this.nomalColor, this.selectedColor, this.datas, this.onPick})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TfbSpinnerBottomState();
}

class _TfbSpinnerBottomState extends State<TfbSpinnerBottom> {
  //标题当前选中项
  int currentIndex = -1;

  //当前选择
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleWidget() {
      List<Widget> views = [];
      for (int i = 0; i < (widget.datas ?? []).length; i++) {
        String title =
            widget.datas?[i].selectSub?.name ?? widget.datas![i].name ?? '';
        views.add(
          Expanded(
              child: Clickable(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(6),
                  // color: currentIndex == i
                  //     ? ColorUtils.colorTitleBgs
                  //     : ColorUtils.colorTitleBg,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: TextView(
                    title,
                    maxLine: 1,
                    color: currentIndex == i
                        ? ColorUtils.colorBlue
                        : ColorUtils.colorBlackLite,
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                    size: 12,
                  )),
                  ImageView(
                    src: source(
                        currentIndex == i ? 'ic_top_arrow' : 'ic_bottom_arrow'),
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.only(right: 7.5),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                currentIndex = i;
              });

              var data = widget.datas?[i];
              int index = 0;
              if (!BaseSysUtils.empty(data?.children)) {
                var i = 0;
                for (var d in data!.children!) {
                  if (d.id == data.selectSub?.id) {
                    index = i;
                  }
                  i++;
                }
              }

              DataPicker.show<IdNameValue>(context,
                  selectedIndex: index,
                  datas: data?.children ?? [], onConfirm: (d) {
                setState(() {
                  data?.selectSub = d;
                  widget.onPick?.call(widget.datas);
                });
              }).then((value) {
                setState(() {
                  currentIndex = -1;
                });
              });
            },
          )),
        );
      }
      return views;
    }

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: titleWidget(),
      ),
    );
  }
}
