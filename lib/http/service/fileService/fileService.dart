import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
  
  /// 下载文件并允许用户选择保存位置
  Future<void> downloadWithSaveDialog(BuildContext context, String url,
      {String? fileName,
      String loading = '下载中, 请稍等',
      String loadingFail = '下载失败，请重试！',
      ValueChanged<String>? onSuccess,
      VoidCallback? onCancel}) async {
    try {
      // 先选择保存位置
      String? saveDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '选择保存位置',
      );
      
      if (saveDirectory == null) {
        // 用户取消了选择
        onCancel?.call();
        return;
      }
      
      // 构建目标文件路径
      final String targetPath = join(saveDirectory, fileName ?? 'file');
      
      // 显示下载进度
      LoadingUtils.show(data: loading);
      
      var baseHeader = await HttpManager.share.getBaseHeader();
      
      // 直接下载到用户选择的位置
      await Dio().download(url, targetPath,
          options: Options(method: 'get', headers: baseHeader));
      
      LoadingUtils.dismiss();
      
      // 回调成功
      onSuccess?.call(targetPath);
    } catch (e) {
      print(e);
      LoadingUtils.showError(data: loadingFail);
      // 确保在出错时也调用取消回调，以便重置状态
      onCancel?.call();
    }
  }

  /// 上传升级文件到本地设备
  Future<void> uploadUpgradeFile(
    String deviceIp,
    String filePath,
    String apiPath, {
    ValueChanged<double>? onProgress,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    try {
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        onError?.call('文件不存在: $filePath');
        return;
      }

      // 读取文件并转换为Base64
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final fileName = basename(filePath);

      // 构建请求URL和数据
      final url = 'http://$deviceIp:8000$apiPath';
      final data = {
        'file': base64String,
        'filename': fileName,
      };

      // 发送POST请求
      final dio = Dio();
      final response = await dio.post(
        url,
        data: data,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call('上传失败: ${response.statusMessage}');
      }
    } catch (e) {
      onError?.call('上传失败: $e');
    }
  }

  /// 从本地设备下载文件
  Future<void> downloadFromLocalDevice(
    String deviceIp,
    String apiPath, {
    ValueChanged<double>? onProgress,
    ValueChanged<String>? onSuccess, // 返回下载文件的路径
    ValueChanged<String>? onError,
  }) async {
    try {
      // 先选择保存位置
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) {
        onError?.call('未选择保存位置');
        return;
      }

      // 构建请求URL
      final url = 'http://$deviceIp:8000$apiPath';

      // 发送GET请求下载文件
      final dio = Dio();
      
      // 先获取文件信息
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (received, total) {
          if (onProgress != null && total > 0) {
            onProgress(received / total);
          }
        },
      );

      if (response.statusCode == 200) {
        // 生成文件名（可以从响应头获取或使用默认名称）
        String fileName = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
        
        // 尝试从响应头获取文件名
        final contentDisposition = response.headers.value('content-disposition');
        if (contentDisposition != null) {
          final match = RegExp(r'filename="?([^"]+)"?').firstMatch(contentDisposition);
          if (match != null) {
            fileName = match.group(1) ?? fileName;
          }
        }

        // 保存文件到选择的位置
        final filePath = '$selectedDirectory/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.data);
        
        onSuccess?.call(filePath);
      } else {
        onError?.call('下载失败: ${response.statusMessage}');
      }
    } catch (e) {
      onError?.call('下载失败: $e');
    }
  }
}
