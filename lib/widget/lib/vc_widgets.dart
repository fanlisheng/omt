import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/linkage_data.dart';
import 'package:omt/utils/color_utils.dart';


class LinkPage extends StatefulWidget {
  final Color? nomalColor;
  final Color? selecteColor;
  final List? titles;
  final List<LinkKage>? datas;
  final GlobalKey? buttonRowKey;
  final ValueChanged<int>? onSelectTitleClick;

  const LinkPage(
      {super.key,
      this.nomalColor,
      this.selecteColor,
      this.titles,
      this.datas,
      this.onSelectTitleClick,
      this.buttonRowKey});

  @override
  State<StatefulWidget> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  //标题当前选中项
  int currentIndex = -1;

  //下拉选择框
  OverlayEntry? overlayEntry;

  bool test = false;

  List dataArray = [];

  //当前选择
  @override
  void initState() {
    super.initState();
    LinkKage l = LinkKage();
    l.value = widget.datas;
    dataArray.add(l);
  }

  void refreshOverlay() {
    if (overlayEntry?.maintainState == false) {
      overlayEntry?.maintainState = true;
    } else {
      overlayEntry?.maintainState = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getItem(List<LinkKage> lists) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        itemCount: lists.length,
        itemBuilder: (BuildContext context, int index) {
          LinkKage item = lists[index];
          bool select = false;
          for (LinkKage l in dataArray) {
            if (l.name == item.name) {
              select = true;
            }
          }
          return TextView(
            item.name ?? '无',
            size: 15,
            fontWeight: FontWeight.normal,
            bgColor: item.hierarchy == 0 ? ColorUtils.colorGray : Colors.white,
            color:
                select == true ? ColorUtils.colorBlue : ColorUtils.colorBlack,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 13),
            onTap: () {
              bool can = true;
              for (int i = 0; i < dataArray.length; i++) {
                LinkKage l = dataArray[i];
                if (l.hierarchy == item.hierarchy) {
                  dataArray[i] = item;
                  can = false;
                }
              }
              if (can == true) {
                dataArray.add(item);
              }
              setState(() {});
              refreshOverlay();
            },
          );
        },
      );
    }

    List<Widget> getRows() {
      List<Widget> views = [];
      for (int i = 0; i < dataArray.length; i++) {
        LinkKage linkKage = dataArray[i];
        if (linkKage.value != null) {
          if (i == 0) {
            views.add(
              Container(
                width: 120,
                color: ColorUtils.colorGray,
                child: getItem(linkKage.value ?? []),
              ),
            );
          } else {
            views.add(
              Expanded(
                child: Container(
                  color: ColorUtils.colorGray,
                  child: getItem(linkKage.value ?? []),
                ),
              ),
            );
          }
        }
      }
      return views;
    }

    void showAlert(int index) {
      if (index == currentIndex) {
        return;
      }
      currentIndex = index;
      overlayEntry?.remove();
      overlayEntry = null;
      setState(() {});
      final box =
          widget.buttonRowKey?.currentContext!.findRenderObject() as RenderBox;
      final dy = box.localToGlobal(Offset(0, box.size.height)).dy;
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned.fill(
          top: dy,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: getRows(),
                          ),
                        ),
                        Row(
                          children: [
                            TextView(
                              '重置',
                              color: ColorUtils.colorBlackLite,
                              bgColor: ColorUtils.colorGray,
                              size: 15,
                              radius: 4,
                              width: 107,
                              height: 43,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                  left: 20, bottom: 20, top: 15),
                              onTap: () {
                                dataArray = [];
                                LinkKage l = LinkKage();
                                l.value = widget.datas;
                                dataArray.add(l);
                                refreshOverlay();
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: TextView(
                                '确定',
                                color: ColorUtils.colorWhite,
                                bgColor: ColorUtils.colorBlue,
                                size: 15,
                                radius: 4,
                                width: 107,
                                height: 43,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    right: 20, bottom: 20, top: 15, left: 12),
                                onTap: () {
                                  overlayEntry!.remove();
                                  overlayEntry = null;
                                  currentIndex = -1;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: GestureDetector(onTap: () {
                    overlayEntry!.remove();
                    overlayEntry = null;
                    currentIndex = -1;
                    setState(() {});
                  }),
                ),
              ],
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
    }

    List<Widget> titleWidget() {
      List<Widget> views = [];
      for (int i = 0; i < (widget.titles ?? []).length; i++) {
        String title = widget.titles![i];
        views.add(
          Clickable(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: currentIndex == i
                    ? ColorUtils.colorTitleBgs
                    : ColorUtils.colorTitleBg,
              ),
              child: Row(
                children: [
                  TextView(
                    title,
                    color: currentIndex == i
                        ? ColorUtils.colorBlue
                        : ColorUtils.colorBlackLite,
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 4),
                    size: 12,
                  ),
                  ImageView(
                    src: source(
                        currentIndex == i ? 'ic_top_arrow' : 'ic_bottom_arrow'),
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 7.5),
                  ),
                ],
              ),
            ),
            onTap: () {
              showAlert(i);
            },
          ),
        );
      }
      return views;
    }

    return Container(
      key: widget.buttonRowKey,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: titleWidget(),
      ),
    );
  }
}
