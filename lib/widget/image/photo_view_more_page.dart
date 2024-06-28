import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/image_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

///  smart_community
///  views.widget.base.camera.bigimage
///
///  Created by kayoxu on 2019/12/11 10:35 AM.
///  Copyright © 2019 kayoxu. All rights reserved.

class PhotoViewMorePage extends StatefulWidget {
  final String? url;
  final List<String>? urls;
  final File? file;
  final File? src;

  final String? title;
  final String? subTitle;
  final Widget? imgDesc;
  final PageController? pageController;
  final int? selectIndex;
  final Widget? bottomWidget;
  final List<String>? imageSrc;
  final bool? hasRotationButton;

  PhotoViewMorePage({super.key, 
    this.url,
    this.urls,
    this.src,
    this.file,
    this.title,
    this.subTitle,
    this.imgDesc,
    this.bottomWidget,
    this.imageSrc,
    this.selectIndex = 0,
    this.hasRotationButton,
  }) : pageController =
            PageController(initialPage: selectIndex ?? 0, viewportFraction: 1);

  @override
  State<StatefulWidget> createState() => _PhotoViewMorePageState();
}

class _PhotoViewMorePageState extends State<PhotoViewMorePage> {
  late int currentIndex;
  double rotation = 0;
  PhotoViewController photoViewController = PhotoViewController();

  @override
  void initState() {
    currentIndex = widget.selectIndex ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController?.dispose();
    // _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showTitle = !BaseSysUtils.empty(widget.title);
    bool showSubTitle = !BaseSysUtils.empty(widget.subTitle);

    var children2 = <Widget>[];

    if (showTitle) {
      children2.add(TextView(
        widget.title,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        color: const Color(0xff191D2D),
        size: 17,
      ));
    }

    if (showSubTitle) {
      children2.add(TextView(
        widget.subTitle,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        color: const Color(0xff191D2D),
        size: 10,
      ));
    }

    var photoView = null == widget.urls
        ? PhotoView(
            imageProvider: buildNetworkImage(),
            minScale: PhotoViewComputedScale.contained,
            loadingBuilder: (c, e) {
              return Container(
                child: const Stack(
                  children: <Widget>[
                    Center(
                        child: SpinKitFoldingCube(
                            color: Colors.white, size: 60.0)),
                  ],
                ),
              );
            })
        : PageView.builder(
            pageSnapping: true,
            onPageChanged: onPageChanged,
//            physics: const BouncingScrollPhysics(),
            controller: widget.pageController,
            itemCount: widget.urls!.length,
            itemBuilder: (BuildContext context, int index) {
              return PhotoView(
                imageProvider: buildNetworkImage(
                    u: ImageUtils.share.getImageUrl(url: widget.urls![index])),
                minScale: PhotoViewComputedScale.contained,
                controller: photoViewController,
                // maxScale: PhotoViewComputedScale.contained,
                loadingBuilder: (c, e) {
                  return Container(
                    child: const Stack(
                      children: <Widget>[
                        Center(
                            child: SpinKitFoldingCube(
                                color: Colors.white, size: 60.0)),
                      ],
                    ),
                  );
                },
              );
            },
          );

    var imgSrc = '${currentIndex + 1}/${widget.urls?.length}';
    if (!BaseSysUtils.empty(widget.imageSrc)) {
      if (widget.imageSrc!.length > currentIndex) {
        imgSrc =
            '${widget.imageSrc![currentIndex]} (${currentIndex + 1}/${widget.urls?.length})';
      } else {
        imgSrc =
            '${widget.imageSrc![widget.imageSrc!.length - 1]} (${currentIndex + 1}/${widget.urls?.length})';
      }
    }

    return Scaffold(
      appBar: showSubTitle || showTitle
          ? AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: children2,
              ),
              backgroundColor: ColorUtils.colorWhite,
              leading: IconButton(
                  icon: const Icon(
                    Icons.close,
//                    Icons.arrow_back_ios,
                  ),
                  iconSize: 25,
                  color: const Color(0xff50525c),
                  onPressed: () async {
                    if (Navigator.canPop(context)) {
                      return Navigator.of(context).pop('');
                    } else {
//                      return  SystemNavigator.pop();
                      return await SystemNavigator.pop();
                    }
                  }),
            )
          : null,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            photoView,
            Positioned(
              top: 23,
              left: 0,
              right: 0,
              child: widget.imgDesc ?? Container(),
            ),
            Positioned(
                bottom: 23,
                left: 0,
                right: 0,
                child: widget.bottomWidget ?? Container()),
            Positioned(
                left: 8,
                top: 35,
                child: VisibleView(
                    visible: (showSubTitle || showTitle)
                        ? Visible.gone
                        : Visible.visible,
                    child: FloatingActionButton(
                      mini: true,
                      elevation: 0,
                      backgroundColor: const Color(0x22000000),
                      onPressed: () {
                        IntentUtils.share.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 25,
                        color: Color(0xffffffff),
                      ),
                    ))),
            Positioned(
                right: 16,
                bottom: 80,
                child: VisibleView(
                    visible:
                        widget.urls == null ? Visible.gone : Visible.visible,
                    child: TextView(
                      imgSrc,
                      color: ColorUtils.colorWhite,
                      size: 13,
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      radius: 30,
                      bgColor: const Color(0x55000000),
                    ))),
            Visibility(
              visible: (widget.hasRotationButton ?? false) ? true : false,
              child: Positioned(
                right: 15,
                bottom: 120,
                left: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          color: ColorUtils.colorBlackLiteLite.withOpacity(0.3),
                        ),
                        child: ImageView(
                          padding: const EdgeInsets.all(12),
                          src: source('ic_rotation_left'),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          rotation = rotation - math.pi / 2;
                          photoViewController.updateMultiple(
                              rotation: rotation);
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          color: ColorUtils.colorBlackLiteLite.withOpacity(0.3),
                        ),
                        child: ImageView(
                          padding: const EdgeInsets.all(12),
                          src: source('ic_rotation_right'),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          rotation = rotation + math.pi / 2;
                          photoViewController.updateMultiple(
                              rotation: rotation);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  ImageProvider buildNetworkImage({String? u}) {
    if (null != u) {
      return NetworkImage(u);
    } else {
      if (null != widget.file && !PlatformUtils.isWeb) {
        return FileImage(widget.file!);
      } else if (widget.url != null || widget.url!.length > 10) {
        return NetworkImage(ImageUtils.share.getImageUrl(url: widget.url));
      } else {
        return AssetImage(ImageUtils.share.IMAGE_DEFAULT);
      }
    }
  }
}
