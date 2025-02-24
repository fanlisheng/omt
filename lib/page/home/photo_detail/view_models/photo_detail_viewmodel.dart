import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';

class PhotoDetailViewModel extends BaseViewModelRefresh<dynamic> {
  int currentImageIndex = 0;
  List<String> images = [
    'assets/image1.jpg', // 请将图片路径替换为你的图片路径
    'assets/image2.jpg', // 请将图片路径替换为你的图片路径
    'assets/image3.jpg', // 请将图片路径替换为你的图片路径
  ];

  bool isDayMode = true;


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
  // 显示上一张图片
  void previousImage() {
    if(currentImageIndex == 0){
      //请求上一页数据
    }else{
      currentImageIndex = (currentImageIndex - 1) % images.length;
    }
    notifyListeners();
  }

  // 显示下一张图片
  void nextImage() {
    if(currentImageIndex == 7){
      //请求下一页数据
    }else{
      currentImageIndex = (currentImageIndex + 1) % images.length;
    }

    notifyListeners();
  }

  // 切换白天/夜晚模式
  void toggleTheme() {}
}
