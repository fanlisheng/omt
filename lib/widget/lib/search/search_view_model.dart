import 'package:flutter/material.dart';
import 'package:kayo_package/mvvm/base/base_view_model.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/shared_utils.dart';


///
///  flutter_ticket
///  home_launcher_model.dart
///
///  Created by kayoxu on 2020/8/10 at 3:16 PM
///  Copyright © 2020 kayoxu. All rights reserved.
///

class SearchViewModel extends BaseViewModel {
  TextEditingController? controller;

  FocusNode contentFocusNode = FocusNode();

  bool showClear = false;
  bool showHistory = true; //是否显示历史

  String? historyTag = ''; //存储历史记录本地的key
  List<String>? historyTexts = []; //历史记录

  final String? keyword;

  SearchViewModel(this.keyword, this.historyTag);

  @override
  void initState() async {
    super.initState();
    controller = TextEditingController(text: keyword ?? '');
    List<String>? history =
        await SharedUtils.getStringList(historyTag ?? '', hashSet: false);
    historyTexts = history;
    FocusScope.of(context!).requestFocus(contentFocusNode);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void onSearch(String? key) {
    key = key ?? '';
    //关闭键盘
    contentFocusNode.unfocus();
    //改变textfield的文字
    controller?.text = key;

    key.replaceAll(' ', '');
    if (key != '') {
      //写入搜索的key
      List<String>? historys = historyTexts; //1.读取控制器里面的历史
      historys?.insert(0, key); //2.加入搜索的
      Set<String>? historySet = Set<String>.from(historys ?? []); //3.去重
      historyTexts = historySet.toList(); //4.赋值
      //存储新数据
      SharedUtils.setList(historyTag ?? '', historyTexts);
    }
    //返回
    IntentUtils.share.pop(context!, data: {'data': key});
  }

  void onTextFieldClear() {
    //  //关闭键盘
    contentFocusNode.unfocus();
    //改变显示列表的状态
    showHistory = true;
    notifyListeners();
  }

  void onClearHistory() {
    //清空控制器里面的数据，清空本地数据
    SharedUtils.clearForKey(historyTag ?? '');
    historyTexts = [];
    notifyListeners();
  }
}
