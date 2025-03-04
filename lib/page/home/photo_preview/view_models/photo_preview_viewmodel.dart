import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/page/home/photo_detail/widgets/photo_detail_screen.dart';
import 'package:omt/widget/image/photo_view_page.dart';

import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../router_utils.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/intent_utils.dart';
import '../../../../widget/pagination/pagination_view.dart';
import '../widgets/photo_preview_screen.dart';

class PhotoPreviewViewModel extends BaseViewModelRefresh<dynamic> {
  PhotoPreviewScreenData photoPreviewScreenData;

  PhotoPreviewViewModel(this.photoPreviewScreenData);

  List<DeviceDetailCameraDataPhoto> photoData = [];
  int? total;
  int? pageIndex;
  int? pageLimit;

  String selectedType = "全部照片";
  List<String> typeList = [
    "全部照片",
    "抓拍照片",
    "背景照片",
  ];

  DateTime selectedDateTime = DateTime.now();
  final datePickerKey = GlobalKey<DatePickerState>();

  final GlobalKey<PaginationGridViewState<DeviceDetailCameraDataPhoto>>
      gridViewKey = GlobalKey();

  //是否设置基准照片
  bool isSetBasicPhoto = false;

  @override
  void initState() async {
    super.initState();

    // fetchData(1,8);
  }

  Future<(List<DeviceDetailCameraDataPhoto>, int)> fetchData(
      int page, int itemsPerPage) async {
    Completer<(List<DeviceDetailCameraDataPhoto>, int)> completer = Completer();

    await HttpQuery.share.homePageService.cameraPhotoList(
      page: page,
      deviceCode: photoPreviewScreenData.deviceCode,
      type: selectedType == "全部照片" ? 0 : (selectedType == "抓拍照片" ? 2 : 1),
      snapAts: [
        DateTime(selectedDateTime.year, selectedDateTime.month,
                selectedDateTime.day, 0, 0, 0)
            .toString(),
        DateTime(selectedDateTime.year, selectedDateTime.month,
                selectedDateTime.day, 23, 59, 59)
            .toString(),
      ],
      onSuccess: (DeviceDetailCameraSnapList? data) {
        if (data != null) {
          photoData = data.data ?? [];
          int totala = data.page?.total ?? 1;
          total = totala;
          pageLimit = data.page?.limit;
          pageIndex = data.page?.page ?? 1;
          completer.complete((photoData, totala));
        } else {
          completer.complete(
              ([], 1) as FutureOr<(List<DeviceDetailCameraDataPhoto>, int)>?);
        }
      },
      onError: (error) {
        completer.completeError(error);
      },
    );

    return completer.future;
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
  clickPhotoWith(int index) {
    // int? page = gridViewKey.currentState?.getCurrentPage();
    // List<DeviceDetailCameraDataPhoto>? photoData =
    //     gridViewKey.currentState?.getItems() ?? [];
    // if (photoPreviewScreenData.dayBasicPhoto != null &&
    //     (photoPreviewScreenData.dayBasicPhoto?.url ?? "").isNotEmpty) {
    //   photoPreviewScreenData.dayBasicPhoto?.snapAt =
    //       photoPreviewScreenData.dayBasicPhoto?.updatedAt;
    //   photoData.insert(0,photoPreviewScreenData.dayBasicPhoto!);
    //   total = (total ?? 0) + 1;
    //   if(index == 7){
    //     index == 0;
    //     page = (page ?? 0) + 1;
    //   }else{
    //     index += 1;
    //   }
    // }
    //
    // if (photoPreviewScreenData.nightBasicPhoto != null &&
    //     (photoPreviewScreenData.nightBasicPhoto?.url ?? "").isNotEmpty) {
    //   photoPreviewScreenData.nightBasicPhoto?.snapAt =
    //       photoPreviewScreenData.nightBasicPhoto?.updatedAt;
    //   photoData.insert(0,photoPreviewScreenData.nightBasicPhoto!);
    //   total = (total ?? 0) + 1;
    //   if(index == 7){
    //     index == 0;
    //     page = (page ?? 0) + 1;
    //   }else{
    //     index += 1;
    //   }
    // }

    PhotoDetailScreenData data = PhotoDetailScreenData(
        page: gridViewKey.currentState?.getCurrentPage(),
        index: index,
        total: total ?? 0,
        limit: pageLimit,
        photoData: gridViewKey.currentState?.getItems() ?? [],
        deviceCode: photoPreviewScreenData.deviceCode,
        type: selectedType == "全部照片" ? 0 : (selectedType == "抓拍照片" ? 2 : 1),
        snapAts: [
          DateTime(selectedDateTime.year, selectedDateTime.month,
                  selectedDateTime.day, 0, 0, 0)
              .toString(),
          DateTime(selectedDateTime.year, selectedDateTime.month,
                  selectedDateTime.day, 23, 59, 59)
              .toString(),
        ]);
    IntentUtils.share.push(context!,
        routeName: RouterPage.PhotoDetailScreen,
        data: {"data": data})?.then((value) {
      if (value["type"] == 1) {
        //1：日间，2：夜间
        photoPreviewScreenData.dayBasicPhoto = value["data"];
      } else if (value["type"] == 2) {
        photoPreviewScreenData.nightBasicPhoto = value["data"];
      }
      isSetBasicPhoto = true;
      notifyListeners();
    });
  }
}
