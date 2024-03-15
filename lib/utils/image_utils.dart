import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/utils/base_sys_utils.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:kayo_package/views/widget/base/image_view.dart';
import 'package:kayo_package/views/widget/base/text_view.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/file/pdf_view_page.dart';
import 'package:omt/widget/image/photo_view_more_page.dart';
import 'package:omt/widget/image/photo_view_page.dart';
import 'package:open_filex/open_filex.dart';

///  smart_community
///  views.widget.base.camera
///
///  Created by kayoxu on 2019/2/20 10:35 AM.
///  Copyright © 2019 kayoxu. All rights reserved.

class ImageUtils {
  static ImageUtils get share => ImageUtils._share();

  static ImageUtils? _instance;

  ImageUtils._() {
    if (null == _imagePicker) _imagePicker = ImagePicker();
  }

  factory ImageUtils._share() {
    if (_instance == null) {
      _instance = ImageUtils._();
    }
    return _instance!;
  }

  ImagePicker? _imagePicker;

  takePhoto(BuildContext context,
      {ValueChanged<File?>? onSuccess,
      ValueChanged<String>? onError,
      bool? camera = true,
      bool? gallery = true}) async {
    if (PlatformUtils.isWeb) {
      camera = false;
    }

    if (camera != true && gallery != true) {
      onError?.call('获取图片失败');
      return;
    }

    if (camera == true && gallery == true) {
      showCupertinoModalPopup<int>(
        context: context,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(cxt, 0);
                },
                child: Text("取消")),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var f = await getCameraImage(camera: true);
                    Navigator.pop(cxt, 0);
                    if (null == f) {
                      onError?.call('获取图片失败');
                    } else {
                      if (null != onSuccess) onSuccess(f);
                    }
                  },
                  child: Text('相机')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var f = await getCameraImage(camera: false);
                    Navigator.pop(cxt, 0);
                    if (null == f) {
                      onError?.call('获取图片失败');
                    } else {
                      if (null != onSuccess) onSuccess(f);
                    }
                  },
                  child: Text('相册')),
            ],
          );
          return dialog;
        },
      );
    } else {
      var f = await getCameraImage(camera: camera == true);
      // Navigator.pop(context, 0);
      if (null == f) {
        onError?.call('获取图片失败');
      } else {
        if (null != onSuccess) onSuccess(f);
      }
    }
  }

  /*
  * 获取图片
  * */
  Future<File?> getCameraImage({bool camera = true, bool? front}) async {
    File? image;
    try {
      var img = await _imagePicker?.pickImage(
          source: true == camera ? ImageSource.camera : ImageSource.gallery,
          preferredCameraDevice:
              front == true ? CameraDevice.front : CameraDevice.rear,
          maxWidth: 720);
      image = null != img ? File(img.path) : null;
    } catch (e) {
      print(e);
      return null;
    }
    return image;
  }

  /*
  * 获取图片
  * */
  Future<File?> getVideo({bool camera = true, bool? front, int? maxSec}) async {
    File? image;
    try {
      var img = await _imagePicker?.pickVideo(
          source: true == camera ? ImageSource.camera : ImageSource.gallery,
          preferredCameraDevice:
              front == true ? CameraDevice.front : CameraDevice.rear,
          maxDuration: Duration(seconds: maxSec ?? 120));
      image = null != img ? File(img.path) : null;
    } catch (e) {
      print(e);
      return null;
    }
    return image;
  }

  Future showBigImg(BuildContext context,
      {String? url,
      String? src,
      File? file,
      String? title,
      String? subTitle,
      String? imgDesc}) {
    if (PlatformUtils.isWeb && null != file) {
      url = file.path;
    }

    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return PhotoViewPage(
              url: url,
              file: file,
              title: title,
              subTitle: subTitle,
              imgDesc: BaseSysUtils.empty(imgDesc)
                  ? null
                  : TextView(
                      imgDesc,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      maxLine: 2,
                      size: 12,
                      color: Color(0xffFD322C),
                    ),
            );
          },
          fullscreenDialog: true,
        ));
  }

  showFile(
    BuildContext context, {
    String? url,
    File? file,
  }) {
    if (PlatformUtils.isWeb && null != file) {
      url = file.path;
    }
    String fileType = BaseSysUtils.getSubType(url ?? file?.path) ?? '';

    switch (fileType.toLowerCase()) {
      case '.pdf':
        _pushByWidget(
            context,
            PDFViewPage(
              file: file,
              url: url,
            ));

        break;
      case '.xlsx':
      case '.xls':
      case '.csv':
        downAndOpenFile(url: url, file: file, fileType: fileType);
        break;
      case '.doc':
      case '.docx':
        downAndOpenFile(url: url, file: file, fileType: fileType);
        break;
      case '.mp4':
        downAndOpenFile(url: url, file: file, fileType: fileType);
        break;

      default:
        LoadingUtils.showToast(data: '不支持的文件格式');
        break;
    }
  }

  void downAndOpenFile({
    String? url,
    File? file,
    String? fileType,
  }) {
    if (null != file) {
      OpenFilex.open(file.path);
      return;
    }

    fileType = fileType ?? BaseSysUtils.getSubType(url ?? file?.path) ?? '';

    HttpQuery.share.fileService.down(url!,
        loading: '处理中，请稍等',
        loadingFail: '打开文件失败',
        fileName: '${BaseSysUtils.getMd5(url.toString())}.${fileType}',
        onPath: (data) {
      OpenFilex.open(data);
    });
  }

  /*
  * 查看大图
  * */
  Future? showBigImgMore(
    BuildContext context, {
    String? url,
    String? src,
    File? file,
    String? urlsStr,
    List<String>? urls,
    String? title,
    String? subTitle,
    int? selectIndex,
    List<String>? imageSrc,
    String? imgDesc,
    bool? hasRotationButton,
  }) {
    if (!BaseSysUtils.empty(urlsStr)) {
      var split = urlsStr!.split(",");
      urls = [];

      if (split.length > 0) {
        for (var i in split) {
          if (!BaseSysUtils.empty(i)) urls.add(i);
        }
      } else {
        if (!BaseSysUtils.empty(urlsStr)) urls.add(urlsStr);
      }
    } else if (BaseSysUtils.empty(url) &&
        BaseSysUtils.empty(src) &&
        BaseSysUtils.empty(urls) &&
        BaseSysUtils.empty(imageSrc)) {
      LoadingUtils.showToast(data: '没有可以查看的图片');
      return null;
    }

    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return PhotoViewMorePage(
              url: url,
              urls: urls,
              file: file,
              title: title,
              subTitle: subTitle,
              selectIndex: selectIndex,
              imageSrc: imageSrc,
              imgDesc: BaseSysUtils.empty(imgDesc)
                  ? null
                  : TextView(
                      imgDesc,
                      alignment: Alignment.center,
//                  bgColor: Color(0x99FD322C),
                      textAlign: TextAlign.center,
                      maxLine: 2,
                      size: 12,
                      color: Color(0xffFD322C),
                    ),
              hasRotationButton: hasRotationButton,
            );
          },
          fullscreenDialog: true,
        ));
  }

  String IMAGE_DEFAULT = source('ic_moren');
  String IMAGE_NO_DATA = source('ic_no_data');
  String IMAGE_NO_VIDEO = source('ic_moren_video');

  String getImageUrl({required String? url}) {
    return (url ?? '') == ''
        ? ''
        : url?.contains('http') == true
            ? url ?? ''
            : '${API.share.hostFile}${url ?? ''}';
  }

  static Future _pushByWidget(BuildContext context, Widget widget,
      {bool finish = false, bool removeAll = false}) {
    if (removeAll) {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return widget;
      }), (route) => route == null);
    } else {
      if (finish) {
        return Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return widget;
        }));
      } else {
        return Navigator.of(context, rootNavigator: false)
            .push(MaterialPageRoute(builder: (context) {
          return widget;
        }));
      }
    }
  }
}
