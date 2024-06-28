import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:dio/dio.dart';
import 'package:omt/bean/common/name_value.dart';
import 'package:omt/http/api.dart';

import 'package:omt/http/http_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  ///上传图片
  get _uploadNew async => '${API.share.hostFile}files';

  ///上传文件
  Future<List<NameValue>?> upload(BuildContext? context,
      {required List<File>? files, String mimeType = '.jpg'}) async {
    Map<String, dynamic> map = {};
    if (!BaseSysUtils.empty(files)) {
      for (int i = 0; i < files!.length; i++) {
        String name = BaseSysUtils.getMd5(files[i].path);
//        formData.add(name, UploadFileInfo(files[i], files[i].path));
        map.addAll({
          name: await MultipartFile.fromFile(files[i].path,
              filename: name + mimeType),
        });
      }
    }

    FormData formData = FormData.fromMap(map);

    LoadingUtils.show(data: '处理中, 请稍等');
    BaseResultData resultData = await HttpManager.share.httpUpload(
      await (_uploadNew),
      formData,
    );
    if (resultData.code == BaseCode.RESULT_OK) {
      List<NameValue> dataList = [];

      if (resultData.data is List && null != resultData.data) {
        List datas = [];
        if (!BaseSysUtils.empty(resultData.data)) {
          datas = resultData.data;
        }

        for (var data in datas) {
          var visitorData = NameValue.fromJson(data);
          dataList.add(visitorData);
        }
      }
      LoadingUtils.dismiss();
      return dataList;
    } else {
      LoadingUtils.showError(data: '上传失败，请重试！');
    }
    return null;
  }

  void down(String url,
      {String? fileName,
      String loading = '下载中, 请稍等',
      String loadingFail = '下载失败，请重试！',
      ValueChanged<String>? onPath}) async {
    LoadingUtils.show(data: loading);

    try {
      var temporaryDirectory = await getTemporaryDirectory();
      final String tmpFile =
          join((temporaryDirectory).path, fileName ?? 'file');

      var file = File(tmpFile);
      if (await file.exists()) {
        onPath?.call(tmpFile);
        LoadingUtils.dismiss();
        return;
      }

      var baseHeader = await HttpManager.share.getBaseHeader();

      await Dio().download(url, tmpFile,
          options: Options(method: 'get', headers: baseHeader));
      onPath?.call(tmpFile);
      LoadingUtils.dismiss();
    } catch (e) {
      print(e);
      LoadingUtils.showError(data: loadingFail);
    }
  }
}
