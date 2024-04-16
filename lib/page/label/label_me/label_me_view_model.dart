import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';

///
///  omt
///  label_me_view_model.dart
///  数据标注
///
///  Created by kayoxu on 2024-04-15 at 16:39:19
///  Copyright © 2024 .. All rights reserved.
///

class LabelMeViewModel extends BaseViewModelRefresh<dynamic> {
  String? selectedDir;

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  void setSelectedDir(String? value) {
    selectedDir = value;
    notifyListeners();
  }
}
