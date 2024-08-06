import 'package:flutter/material.dart';

import 'package:kayo_package/kayo_package.dart';

import 'search_view_model.dart';

///
///  flutter_ticket
///  home_launcher_page.dart
///
///  Created by kayoxu on 2020/8/10 at 3:48 PM
///  Copyright © 2020 kayoxu. All rights reserved.
///

class KSearchPage extends StatelessWidget {
  final String? keyword;
  final String? hintText;
  final String? historyTag;

  const KSearchPage({super.key, this.keyword, this.hintText, this.historyTag});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchViewModel>(
        model: SearchViewModel(keyword ?? '', historyTag ?? ''),
        autoLoadData: true,
        builder: (context, model, child) {
          Widget SearchBar() {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ), //上半部分
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                color: const Color(0xffEEEEEE),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 12,
                                ),
                                ImageView(
                                  src: source('ic_search'),
                                  height: 15,
                                  color: BaseColorUtils.colorBlackLite,
                                  width: 15,
                                ),
                                Container(
                                  width: 12,
                                ), //输入框
                                Expanded(
                                  child: SizedBox(
                                    height: 38,
                                    child: EditView(
                                      // padding: EdgeInsets.only(top: 5),
                                      focusNode: model.contentFocusNode,
                                      textSize: 14,
                                      controller: model.controller,
                                      textColor: const Color(0xFF42434C),
                                      hintText: hintText ?? '请输入搜索关键字',
                                      hintTextSize: 14,
                                      hintTextColor: const Color(0xFF828892),
                                      maxLines: 1,
                                      showLine: false,
                                      keyboardType: TextInputType.text,
                                      onSubmitted: (T) {
                                        T = T.replaceAll(' ', '');
                                        if (BaseSysUtils.empty(T)) {
                                          LoadingUtils.showInfo(
                                              data: '关键字不能为空');
                                          return;
                                        }
                                        model.onSearch(T);
                                        // dispatch(SearchActionCreator.onSearch(T));
                                      },
                                      onChanged: (T) {
                                        if (T.isEmpty) {
                                          model.onTextFieldClear();
                                          // dispatch(SearchActionCreator.onTextFieldClear());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), //左边圆角背景
                        ),
                        Clickable(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 20, left: 18),
                          onTap: () {
                            // dispatch(SearchActionCreator.onSearch(''));
                            model.onSearch('');
                          },
                          child: TextView(
                            '取消',
                            color: Colors.blueAccent,
                            size: 15,
                          ),
                        ), //取消按钮
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          Widget HistoryItem(String t) {
            return GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 32,
                padding: const EdgeInsets.only(
                    left: 16, top: 8, right: 16, bottom: 8),
                child: Text(
                  t,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff575961)),
                ),
              ),
              onTap: () {
                // dispatch(SearchActionCreator.onSearch(t));
                model.onSearch(t);
              },
            );
          }

          // ignore: non_constant_identifier_names
          Widget HistoryList() {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 11),
                        child: const Text(
                          '历史记录',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff191D2D)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          const Text(
                            '删除',
                            style: TextStyle(
                                color: Color(0xff888A8E),
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 7,
                          ),
                          Image(
                            image: AssetImage(source('ic_clear')),
                            width: 14,
                          ),
                          Container(
                            width: 15,
                          ),
                        ],
                      ),
                      onTap: () {
                        // dispatch(SearchActionCreator.onClearHistory());
                        model.onClearHistory();
                      },
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 20,
                    children: model.historyTexts!.map((t) {
                      return HistoryItem(t);
                    }).toList(),
                  ),
                ),
              ],
            );
          }

          return Scaffold(
            body: Column(
              children: <Widget>[
                SearchBar(),
                Container(
                  height: 30,
                ),
                HistoryList(),
              ],
            ),
          );
        });
  }
}
