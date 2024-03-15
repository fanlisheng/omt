import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/image_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:photo_view/photo_view.dart';

///  smart_community
///  views.widget.base.camera.bigimage
///
///  Created by kayoxu on 2019/2/20 10:35 AM.
///  Copyright © 2019 kayoxu. All rights reserved.

class PhotoViewPage extends StatelessWidget {
  final String? url;
  final File? file;
  final File? src;

  final String? title;
  final String? subTitle;
  final Widget? imgDesc;

  PhotoViewPage(
      {this.url, this.src, this.file, this.title, this.subTitle, this.imgDesc});

  @override
  Widget build(BuildContext context) {
    bool showTitle = !BaseSysUtils.empty(title);
    bool showSubTitle = !BaseSysUtils.empty(subTitle);

    var children2 = <Widget>[];

    if (showTitle) {
      children2.add(TextView(
        title,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        color: Color(0xff191D2D),
        size: 17,
      ));
    }

    if (showSubTitle) {
      children2.add(TextView(
        subTitle,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        color: Color(0xff191D2D),
        size: 10,
      ));
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
                  icon: Icon(
                    Icons.close,
//                    Icons.arrow_back_ios,
                  ),
                  iconSize: 25,
                  color: Color(0xff50525c),
                  onPressed: () async {
                    if (Navigator.canPop(context)) {
                      return Navigator.of(context).pop();
                    } else {
                      return await SystemNavigator.pop();
                    }
                  }),
            )
          : null,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            PhotoView(
              imageProvider: buildNetworkImage(),
              minScale: PhotoViewComputedScale.contained,
              loadingBuilder: (c, e) {
                return Container(
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: new SpinKitFoldingCube(
                              color: Colors.white, size: 60.0)),
                    ],
                  ),
                );
              },
            ),
            Positioned(
                top: 23, left: 0, right: 0, child: imgDesc ?? Container()),
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
                      backgroundColor: Color(0x22000000),
                      onPressed: () {
                        IntentUtils.share.pop(context,
                            data: {'data': IntentUtils.share.RESULT_OK});
                      },
                      child: const Icon(
//                        Icons.arrow_back_ios,
                        Icons.close,
                        size: 25,
                        color: Color(0xffffffff),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  ImageProvider buildNetworkImage() {
    if (null != file && !PlatformUtils.isWeb) {
      return FileImage(file!);
    } else if (url != null && url!.length > 10) {
      return NetworkImage(url ?? ImageUtils.share.IMAGE_DEFAULT);
    } else {
      return AssetImage(ImageUtils.share.IMAGE_DEFAULT);
    }
  }
}
