import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:image/image.dart' as img;

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

  List<FileSystemEntity> files = [];

  int fileIndex = 0;
  List<Rect> rectangles = [];

  FileSystemEntity? theFileSystemEntity;
  double theImgWidth = 1280;
  double theImgHeight = 720;

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

  void setSelectedDir() async {
    FilePicker.platform
        .getDirectoryPath(lockParentWindow: true, initialDirectory: selectedDir)
        .then((value) {
      if (null != value) {
        if (selectedDir != value) {
          files.clear();
          var directory = Directory(value);
          var listSync = directory.listSync();
          if (!BaseSysUtils.empty(listSync)) {
            for (var f in listSync) {
              if (f.path.endsWith('.jpg')) {
                files.add(f);
              }
            }
          }
          fileIndex = 0;
        }
      }
      selectedDir = value;

      notifyListeners();
    });
  }

  void nextIndex({bool pre = false}) async {
    fileIndex = pre ? fileIndex - 1 : fileIndex + 1;
    if (fileIndex > (files.length ?? 0) - 1) {
      fileIndex = (files.length ?? 0) - 1;
    }
    if (fileIndex < 0) {
      fileIndex = 0;
    }
    rectangles.clear();
    theFileSystemEntity = files.findData<FileSystemEntity>(fileIndex);

    File file = File(theFileSystemEntity!.path);
    var readAsBytesSync = file.readAsBytesSync();
    var image = img.decodeImage(readAsBytesSync);
    if (null != image) {
      var height = image.height + 0.0;
      var width = image.width + 0.0;

      theImgWidth = width * 720 / height;
      theImgHeight = 720;
    }

    var filePath = theFileSystemEntity?.path.replaceAll('.jpg', '.txt');
    if (!BaseSysUtils.empty(filePath) && File(filePath!).existsSync()) {
      var file = File(filePath);
      List<String> lines = file.readAsLinesSync();
      for (var line in lines) {
        var parts = line.split(' ');
        if (parts.length == 5) {
          double xCenter = double.parse(parts[1]);
          double yCenter = double.parse(parts[2]);
          double width = double.parse(parts[3]);
          double height = double.parse(parts[4]);
          Rect rect = Rect.fromLTRB(
              (xCenter - width / 2) * 1280,
              (yCenter - height / 2) * 720,
              (xCenter + width / 2) * 1280,
              (yCenter + height / 2) * 720);
          rectangles.add(rect);
        }
      }
    }

    notifyListeners();
  }

  void updateRectangles(List<Rect> value) {
    notifyListeners();
  }
}
