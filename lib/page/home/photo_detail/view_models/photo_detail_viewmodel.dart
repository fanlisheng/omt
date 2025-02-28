import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/utils/dialog_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../../bean/common/code_data.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../http/http_query.dart';
import '../widgets/photo_detail_screen.dart';

class PhotoDetailViewModel extends BaseViewModelRefresh<dynamic> {
  final PhotoDetailScreenData pageNeedData;

  PhotoDetailViewModel(this.pageNeedData);

  int currentImageIndex = 0;
  List<DeviceDetailCameraDataPhoto> images = [];

  bool isDayMode = true;

  @override
  void initState() async {
    super.initState();
    if ((pageNeedData.page == null || pageNeedData.page == 0) ||
        (pageNeedData.limit == null || pageNeedData.limit == 0)) {
      currentImageIndex = pageNeedData.index;
    } else {
      currentImageIndex =
          pageNeedData.index + ((pageNeedData.page! - 1) * pageNeedData.limit!);
    }

    images = pageNeedData.photoData;
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
    if (currentImageIndex == 0) {
      //请求上一页数据
    } else {
      currentImageIndex = (currentImageIndex - 1) % images.length;
    }
    notifyListeners();
  }

  // 显示下一张图片
  void nextImage() {
    if ((currentImageIndex + 1) >= images.length) {
      if (pageNeedData.page == null || pageNeedData.deviceCode == null) return;
      if ((currentImageIndex + 1) < pageNeedData.total) {
        //请求新的数据
        HttpQuery.share.homePageService.cameraPhotoList(
          page: pageNeedData.page! + 1,
          deviceCode: pageNeedData.deviceCode!,
          type: pageNeedData.type ?? 0,
          snapAts: pageNeedData.snapAts ?? [],
          onSuccess: (DeviceDetailCameraSnapList? data) {
            if (data != null && (data.data ?? []).isNotEmpty) {
              images.addAll(data.data!);
              currentImageIndex++;
              notifyListeners();
            }
          },
          onError: (error) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('已经是这天的最后一张了')),
            // );
          },
        );
      } else {
        LoadingUtils.showInfo(data: "已是最后一张!");
      }
    } else {
      currentImageIndex = (currentImageIndex + 1) % images.length;
    }
    notifyListeners();
  }

  // 切换白天/夜晚模式
  void setBasicPhoto({required int type}) async {
    if (pageNeedData.deviceCode == null ||
        images[currentImageIndex].url == null) {
      return;
    }
    final result = await DialogUtils.showContentDialog(
        context: context!,
        title: "设置基准照片",
        content: "您确定设置该照片为${type == 1 ? "日间" : "夜间"}基准照片？",
        deleteText: "确定");
    if (result == '取消') return;
    HttpQuery.share.homePageService.setCameraBasicPhoto(
      deviceCode: pageNeedData.deviceCode ?? "",
      type: type,
      url: images[currentImageIndex].url ?? "",
      onSuccess: (CodeMessageData? data) {
        IntentUtils.share.pop(context!,
            data: {"data": images[currentImageIndex], "type": type});
      },
      onError: (error) {},
    );
  }
}
