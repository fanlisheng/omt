import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';
import 'package:omt/widget/lib/input_view.dart';

class SearchPage extends StatefulWidget {
  final String? keyValue;
  final bool? ShowTime;

  const SearchPage({super.key, this.keyValue, this.ShowTime});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List items = [];
  TextEditingController? controller = TextEditingController();

  //开始时间
  String? startTime;

  //结束时间
  String? endTime;

  //显示历史模块
  bool showHistory = true;
  List resultData = [];

  //显示结果模块
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    startTime =
        BaseTimeUtils.dateToTimeStr(BaseTimeUtils.getToday(start: true), format: 'MM.dd');
    endTime =
        BaseTimeUtils.dateToTimeStr(BaseTimeUtils.getToday(start: false), format: 'MM.dd');
    getHistory();
    controller?.addListener(() {
      if (showResult == false) {
        showHistory = false;
        showResult = true;
        setState(() {});
      } else {
        if (resultData.isEmpty && (controller?.text.length ?? 0) == 0) {
          showHistory = true;
          showResult = false;
          setState(() {});
        }
      }

      for (String r in items) {
        if (!BaseSysUtils.empty(controller?.text)) {
          if (r.contains(controller?.text ?? '')) {
            if (!resultData.contains(r)) {
              resultData.add(r);
              setState(() {});
            }
          }
        }
      }
    });
  }

  void getHistory() {
    SharedUtils.getHistory(widget.keyValue ?? '').then((value) async {
      items = value;
      setState(() {});
    });
  }

  void setHistory() async {
    await SharedUtils.setHistory(items, widget.keyValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.colorInputBg,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                        const EdgeInsets.only(left: 23, right: 0, bottom: 10),
                        // padding:
                        //     EdgeInsets.only(left: 12, right: 15, bottom: 0),
                        height: 30,
                        child: Row(
                          children: [
                            VisibleView(
                              visible: (widget.ShowTime ?? false) == true
                                  ? Visible.visible
                                  : Visible.gone,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                    ),
                                    color: ColorUtils.colorTimeBg),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextView(
                                      '$startTime - $endTime',
                                      size: 14,
                                      alignment: Alignment.center,
                                      color: ColorUtils.colorBlackLite,
                                      margin: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      onTap: () {
                                        DateTimePicker.show(context,
                                            showEnd: true,
                                            onDateTimePick: (start, end) {
                                              startTime =
                                                  BaseTimeUtils.dateToTimeStr(
                                                      start,
                                                      format: 'MM.dd');
                                              endTime =
                                                  BaseTimeUtils.dateToTimeStr(end,
                                                      format: 'MM.dd');
                                              setState(() {});
                                            });
                                      },
                                    ),
                                    ImageView(
                                      src: source('ic_vector'),
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 10, bottom: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ImageView(
                              src: source('ic_search'),
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(left: 12),
                            ),
                            Expanded(
                                child: InputView(
                                  controller: controller,
                                  textSize: 14,
                                  hintTextColor: ColorUtils.colorBlackLiteLite,
                                  hintTextSize: 14,
                                  hintText: '请输入关键字',
                                  padding: const EdgeInsets.only(top: 0),
                                  textColor: ColorUtils.colorBlack,
                                  onChanged: (value) {},
                                  onEditingComplete: () {
                                    if (!BaseSysUtils.empty(controller?.text)) {
                                      if (!items.contains(controller?.text)) {
                                        items.add(controller?.text);
                                        setHistory();
                                      }
                                    }
                                    SysUtils.hideKeyboard(context);
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                    TextView(
                      '取消',
                      margin: const EdgeInsets.only(right: 8, bottom: 10),
                      padding: const EdgeInsets.all(8),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            VisibleView(
              visible: showHistory ? Visible.visible : Visible.gone,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView(
                        '历史记录',
                        margin:
                        const EdgeInsets.only(left: 18, top: 16, bottom: 15),
                        color: ColorUtils.colorBlack,
                        size: 15,
                        fontWeight: FontWeight.bold,
                        onTap: () {
                          // controller?.text = '历史记录';
                        },
                      ),
                      ImageView(
                        src: source('ic_clear'),
                        width: 14,
                        height: 14,
                        padding: const EdgeInsets.all(10),
                        margin:
                        const EdgeInsets.only(right: 8, top: 10, bottom: 15),
                        onClick: () {
                          items.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 12,
                      children: _getListItems(),
                    ),
                  ),
                ],
              ),
            ),
            VisibleView(
              visible: showResult ? Visible.visible : Visible.gone,
              child: Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: resultData.length,
                  itemBuilder: (BuildContext context, int index) {
                    String title = resultData[index];
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            title,
                            margin:
                            const EdgeInsets.only(left: 15, top: 12, right: 15),
                            size: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.colorBlack,
                          ),
                          TextView(
                            title,
                            margin: const EdgeInsets.only(
                                left: 15, top: 7, bottom: 10, right: 15),
                            size: 12,
                            color: ColorUtils.colorBlackLiteLite,
                          ),
                          Container(
                            color: ColorUtils.colorItemLine,
                            height: .5,
                            margin: const EdgeInsets.only(left: 15, right: 15),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getListItems() {
    List<Widget> views = [];
    for (String title in items) {
      views.add(
        TextView(
          title,
          size: 13,
          color: ColorUtils.colorBlack,
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 14, right: 14),
          border: true,
          borderColor: ColorUtils.colorBorder,
          borderWidth: 0.5,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            controller?.text = title;
            setState(() {});
          },
        ),
      );
    }
    return views;
  }
}
