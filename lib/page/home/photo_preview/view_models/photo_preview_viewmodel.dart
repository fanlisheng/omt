
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';

class PhotoPreviewViewModel extends BaseViewModelRefresh<dynamic> {


  String selectedType = "抓拍照片";
  List<String> typeList = ["抓拍照片","背景照片",];

  DateTime selectedDateTime = DateTime.now();
  final datePickerKey = GlobalKey<DatePickerState>();
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

  ///点击事件

}