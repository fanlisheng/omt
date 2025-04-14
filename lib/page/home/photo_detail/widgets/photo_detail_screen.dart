import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/provider_widget.dart';
import 'package:kayo_package/utils/base_time_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/page/home/device_detail/widgets/detail_ai_view.dart';
import 'package:omt/widget/combobox.dart';
import '../../../../bean/home/home_page/device_detail_camera_entity.dart';
import '../../../../widget/nav/dnavigation_view.dart';
import '../../../../widget/pagination/pagination_view.dart';
import '../../device_detail/widgets/detail_camera_view.dart';
import '../../../../utils/color_utils.dart';
import '../view_models/photo_detail_viewmodel.dart';

class PhotoDetailScreenData {
  final int index;
  final int total;
  final int? page;
  final int? limit;
  final String? deviceCode;
  final String? nodeId;
  final int? type;
  final List<String>? snapAts;
  final List<DeviceDetailCameraDataPhoto> photoData;

  PhotoDetailScreenData( {
    required this.index,
    required this.total,
    required this.photoData,
    this.page,
    this.limit,
    this.deviceCode,
    this.nodeId,
    this.type,
    this.snapAts,
  });
}

class PhotoDetailScreen extends StatelessWidget {
  // final int pageIndex;
  final PhotoDetailScreenData pageNeedData;

  const PhotoDetailScreen({super.key, required this.pageNeedData});

  // const PhotoDetailScreen({super.key, required this.pageIndex, required this.photoIndex});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<PhotoDetailViewModel>(
        model: PhotoDetailViewModel(pageNeedData)..themeNotifier = true,
        autoLoadData: true,
        builder: (context, model, child) {
          return Container(
            color: "#3B3F3F".toColor(),
            child: ScaffoldPage(
              header: const PageHeader(
                title: DNavigationView(
                  title: "查看详情",
                  titlePass: "首页 / 摄像头 / 照片预览 / ",
                  rightWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                ),
              ),
              content: contentView(model),
            ),
          );
        });
  }

  Widget contentView(PhotoDetailViewModel model) {
    return Container(
      margin: const EdgeInsets.all(16),
      color: "#4E5353".toColor(),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "查看详情",
              style: TextStyle(
                fontSize: 14,
                color: ColorUtils.colorGreenLiteLite,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            DashLine(
              color: "#5D6666".toColor(),
              height: 1,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                infoItem(
                  "设备名称:",
                  "工控机V2B_出",
                ),
                const SizedBox(width: 30),
                infoItem(
                  "抓拍时间:",
                  model.images[model.currentImageIndex].snapAt ?? '',
                ),
                Expanded(child: Container()),
                Clickable(
                  onTap: (){
                    model.setBasicPhoto(type: 1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: "#5E6363".toColor(),
                    ),
                    width: 32,
                    height: 32,
                    child: const Icon(FluentIcons.sunny, size: 16.0),
                  ),
                ),
                const SizedBox(width: 10),
                Clickable(
                  onTap: (){
                    model.setBasicPhoto(type: 2);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: "#5E6363".toColor(),
                    ),
                    width: 32,
                    height: 32,
                    child: const Icon(FluentIcons.clear_night, size: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 图片显示
            Expanded(
              child: Center(
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Clickable(
                      onTap: model.previousImage,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: "#5E6363".toColor(),
                        ),
                        width: 40,
                        height: 56,
                        child: const Icon(FluentIcons.chevron_left, size: 18.0),
                      ),
                    ),
                    const SizedBox(width: 45),
                    if (model.images.length >
                        model.currentImageIndex)
                      Expanded(
                        // Image.network(model.pageNeedData
                        //     .photoData[model.pageNeedData.index].url ??
                        //     ""),
                        child: ImageView(
                          url: model.images[model.currentImageIndex].url ??
                              "",
                        ),
                      ),
                    // 显示当前图片
                    const SizedBox(width: 45),
                    Clickable(
                      onTap: model.nextImage,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: "#5E6363".toColor(),
                        ),
                        width: 40,
                        height: 56,
                        child: const Icon(FluentIcons.chevron_right, size: 18),
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget infoItem(String name, String value) {
    String a = (value.isNotEmpty) ? value : "-";
    return Row(
      children: [
        SizedBox(
          child: Text(
            name,
            style: TextStyle(color: "A7C3C2".toColor(), fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          a,
          style: const TextStyle(
              color: ColorUtils.colorGreenLiteLite, fontSize: 12),
        ),
      ],
    );
  }
}
