import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import '../../../bean/update/update_info.dart';
import '../../../utils/file_log_utils.dart';
import 'mock_update_api.dart';
import 'windows_install_script.dart';

get _clientVersion => 'http://106.75.154.221:8082/api/client_version/last';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();

  factory UpdateService() => _instance;

  UpdateService._internal();

  final Dio _dio = Dio();
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadPath;
  String? _extractedPath;
  final FileLogUtils _fileLogger = FileLogUtils();
  CancelToken? _cancelToken;
  final String _logType = 'update';

  // 获取当前版本信息
  Future<PackageInfo> getCurrentVersion() async {
    return await PackageInfo.fromPlatform();
  }

  /// 记录日志到文件
  Future<void> logMessage(String message) async {
    await _fileLogger.log(_logType, message);
  }

  // 检查更新
  Future<UpdateInfo?> checkForUpdate({bool useMock = false}) async {
    try {
      if (useMock) {
        // 使用模拟API进行测试
        await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
        final mockResponse = MockUpdateApi.getMockForceUpdateResponse();
        final updateInfo = UpdateInfo.fromJson(mockResponse);
        final currentVersion = await getCurrentVersion();

        // 比较版本号
        if (_compareVersions(updateInfo.version, currentVersion.version) > 0) {
          return updateInfo;
        }
        return null;
      }

      // 这里替换为你的实际版本检查API

      final response = await _dio.get( _clientVersion);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data["data"];
        final updateInfo = UpdateInfo.fromJson(data);
        final currentVersion = await getCurrentVersion();

        // 比较版本号
        if (_compareVersions(updateInfo.version, currentVersion.version) > 0) {
          return updateInfo;
        }
      }
    } catch (e) {
      print('检查更新失败: $e');
    }
    return null;
  }

  // 版本号比较
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();

    final maxLength = max(v1Parts.length, v2Parts.length);

    for (int i = 0; i < maxLength; i++) {
      final v1 = i < v1Parts.length ? v1Parts[i] : 0;
      final v2 = i < v2Parts.length ? v2Parts[i] : 0;

      if (v1 > v2) return 1;
      if (v1 < v2) return -1;
    }
    return 0;
  }

  // 下载更新包（固定zip）
  Future<bool> downloadUpdate(
      UpdateInfo updateInfo, Function(double) onProgress) async {
    if (_isDownloading) return false;

    _isDownloading = true;
    _downloadProgress = 0.0;
    _cancelToken = CancelToken();

    try {
      Directory baseDir;
      if (Platform.isWindows) {
        final downloads = await getDownloadsDirectory();
        baseDir = downloads ?? await getApplicationDocumentsDirectory();
      } else {
        baseDir = await getApplicationDocumentsDirectory();
      }
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }

      final fileName = 'update_${updateInfo.version}.zip';
      _downloadPath = '${baseDir.path}/$fileName';

      final targetFile = File(_downloadPath!);
      if (await targetFile.exists()) {
        try {
          await targetFile.delete();
          await logMessage('已删除旧文件: ${targetFile.absolute.path}');
        } catch (e) {
          await logMessage('删除旧文件失败: $e');
        }
      }

      await logMessage('开始下载更新包');
      await logMessage('URL: ${updateInfo.downloadUrl}');
      await logMessage('保存到: ${File(_downloadPath!).absolute.path}');

      int lastPercent = -1;
      await _dio.download(
        updateInfo.downloadUrl,
        _downloadPath!,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            _downloadProgress = received / total;
            onProgress(_downloadProgress);
            final percent = (_downloadProgress * 100).floor();
            if (percent != lastPercent && percent % 10 == 0) {
              lastPercent = percent;
              await logMessage('下载进度: $percent%');
            }
          }
        },
      );

      _isDownloading = false;

      final savedFile = File(_downloadPath!);
      final exists = await savedFile.exists();
      final size = exists ? await savedFile.length() : 0;
      await logMessage('下载完成: ${savedFile.absolute.path}');
      await logMessage('存在: $exists, 大小: $size 字节');
      return exists;
    } catch (e) {
      _isDownloading = false;
      await logMessage('下载失败: $e');
      return false;
    }
  }

  // 打开下载文件所在目录（Windows/桌面便捷操作）
  Future<void> openDownloadedFileLocation() async {
    try {
      if (_downloadPath == null) return;
      final fullPath = File(_downloadPath!).absolute.path;
      if (Platform.isWindows) {
        await Process.start('explorer', ['/select,', fullPath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', fullPath]);
      } else if (Platform.isLinux) {
        final dir = Directory(_downloadPath!).parent.path;
        await Process.run('xdg-open', [dir]);
      }
    } catch (e) {
      print('打开下载目录失败: $e');
    }
  }

  // 创建安装脚本
  Future<String?> _createInstallScript() async {
    if (_extractedPath == null) return null;
    
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final scriptDir = Directory('${appDir.path}/install_scripts');
      if (!await scriptDir.exists()) {
        await scriptDir.create(recursive: true);
      }

      String scriptPath;
      String scriptContent;
      
      if (Platform.isWindows) {
        scriptPath = '${scriptDir.path}/install_update.bat';
        // 获取当前应用程序的目录作为目标目录
        // 在Windows环境下，使用更可靠的方法获取应用程序目录
        String currentAppDir;
        try {
          final currentExePath = Platform.resolvedExecutable;
          currentAppDir = Directory(currentExePath).parent.path;
          await logMessage('从Platform.resolvedExecutable获取目录: $currentAppDir');
          
          // 如果路径包含flutter工具链路径，则使用提取路径的父目录作为目标
          if (currentAppDir.contains('flutter') || currentAppDir.contains('cache')) {
            currentAppDir = Directory(_extractedPath!).parent.path;
            await logMessage('检测到开发环境，使用提取路径的父目录: $currentAppDir');
          }
        } catch (e) {
          await logMessage('获取应用程序目录失败，使用提取路径的父目录: $e');
          currentAppDir = Directory(_extractedPath!).parent.path;
        }
        
        scriptContent = WindowsInstallScript.generateTestScript(
          extractedPath: _extractedPath!,
          downloadPath: _downloadPath ?? '',
          targetDir: currentAppDir,
        );
        
        await logMessage('最终目标安装目录: $currentAppDir');
      } else {
        // 非Windows平台不支持
        await logMessage('当前平台不支持自动安装: ${Platform.operatingSystem}');
        return null;
      }

      final scriptFile = File(scriptPath);
      await scriptFile.writeAsString(scriptContent);
      await logMessage('创建安装脚本: $scriptPath');
      
      // 确保脚本文件存在
      if (!await scriptFile.exists()) {
        await logMessage('错误：安装脚本文件未能创建');
        return null;
      }
      
      // 检查脚本文件大小
      final fileSize = await scriptFile.length();
      await logMessage('安装脚本大小: $fileSize 字节');
      
      return scriptPath;
    } catch (e) {
      await logMessage('创建安装脚本失败: $e');
      return null;
    }
  }

  // 安装更新（启动安装脚本并退出应用）
  Future<bool> installUpdate() async {
    try {
      // 检查平台支持
      if (!Platform.isWindows) {
        await logMessage('当前平台不支持自动安装: ${Platform.operatingSystem}');
        return false;
      }

      await logMessage('开始安装更新流程');
      
      // 创建安装脚本
      final scriptPath = await _createInstallScript();
      if (scriptPath == null) {
        await logMessage('创建安装脚本失败');
        return false;
      }

      await logMessage('安装脚本路径: $scriptPath');
      await logMessage('解压路径: $_extractedPath');
      await logMessage('下载路径: $_downloadPath');

      // 启动安装脚本
      try {
        final process = await Process.start('cmd', ['/c', scriptPath], 
          mode: ProcessStartMode.detached);
        await logMessage('Windows安装脚本已启动，PID: ${process.pid}');
        
        // 等待脚本完全启动
        await Future.delayed(Duration(milliseconds: 500));
        await logMessage('脚本启动延迟完成');
        
      } catch (e) {
        await logMessage('启动安装脚本失败，详细错误: $e');
        return false;
      }

      await logMessage('安装脚本启动成功，应用将退出...');
      
      // 退出应用，让脚本接管更新过程
      await logMessage('正在退出应用...');
      
      // 退出应用
      exit(0);
      
      return true;
    } catch (e) {
      await logMessage('启动安装脚本失败: $e');
      return false;
    }
  }

  // 解压ZIP更新包
  Future<bool> extractUpdatePackage() async {
    if (_downloadPath == null) return false;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _extractedPath = '${appDir.path}/update_extracted';

      // 创建解压目录
      final extractDir = Directory(_extractedPath!);
      if (await extractDir.exists()) {
        try {
          await extractDir.delete(recursive: true);
          await logMessage('已清理旧解压目录: ${extractDir.path}');
        } catch (e) {
          await logMessage('清理旧解压目录失败: $e');
        }
      }
      await extractDir.create(recursive: true);

      await logMessage('开始解压更新包');
      await logMessage('ZIP: ${File(_downloadPath!).absolute.path}');
      await logMessage('目标目录: ${extractDir.path}');

      // 读取ZIP文件
      final bytes = await File(_downloadPath!).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes, verify: true);
      final total = archive.length;
      await logMessage('ZIP 条目总数: $total');

      // 解压文件
      int done = 0;
      int lastPercent = -1;
      for (final entry in archive) {
        try {
          final name = entry.name.replaceAll('\\', '/');
          final outPath = '$_extractedPath/$name';
          if (entry.isFile) {
            final outFile = File(outPath);
            await outFile.parent.create(recursive: true);
            await outFile.writeAsBytes(entry.content);
          } else {
            await Directory(outPath).create(recursive: true);
          }
        } catch (e) {
          await logMessage('解压条目失败: ${entry.name} -> $e');
        } finally {
          done++;
          if (total > 0) {
            final percent = ((done / total) * 100).floor();
            if (percent != lastPercent && percent % 10 == 0) {
              lastPercent = percent;
              await logMessage('解压进度: $percent%');
            }
          }
        }
      }

      await logMessage('解压完成: $done/$total 条目');
      return true;
    } catch (e) {
      await logMessage('解压失败: $e');
      return false;
    }
  }

  // 平台通用：是否存在可执行安装文件
  Future<bool> hasInstallerFile() async {
    if (_extractedPath == null) return false;
    try {
      if (Platform.isWindows) {
        return await existsByExtension('.exe');
      } else if (Platform.isMacOS) {
        // .app 目录或 .dmg 文件
        final hasApp = await _existsAppBundle();
        if (hasApp) return true;
        return await existsByExtension('.dmg');
      } else if (Platform.isLinux) {
        return await existsByExtension('.deb');
      }
      return false;
    } catch (e) {
      print('检测安装文件失败: $e');
      return false;
    }
  }

  // 工具：是否存在某扩展名文件
  Future<bool> existsByExtension(String extLower) async {
    final dir = Directory(_extractedPath!);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.toLowerCase().endsWith(extLower)) {
        return true;
      }
    }
    return false;
  }

  // 工具：查找首个某扩展名文件
  Future<String?> _findFirstByExtension(String extLower) async {
    final dir = Directory(_extractedPath!);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.toLowerCase().endsWith(extLower)) {
        return entity.path;
      }
    }
    return null;
  }

  // macOS: 是否存在 .app 目录
  Future<bool> _existsAppBundle() async {
    final dir = Directory(_extractedPath!);
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is Directory && entity.path.toLowerCase().endsWith('.app')) {
        return true;
      }
    }
    return false;
  }

  // macOS: 查找首个 .app 目录
  Future<String?> _findFirstAppBundle() async {
    final dir = Directory(_extractedPath!);
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is Directory && entity.path.toLowerCase().endsWith('.app')) {
        return entity.path;
      }
    }
    return null;
  }

  // 取消下载
  Future<void> cancelDownload() async {
    if (_isDownloading && _cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('用户取消下载');
      _isDownloading = false;
      _downloadProgress = 0.0;
      await logMessage('下载已取消');
    }
  }

  // 获取取消令牌
  CancelToken? get cancelToken => _cancelToken;

  // 获取下载进度
  double get downloadProgress => _downloadProgress;

  // 是否正在下载
  bool get isDownloading => _isDownloading;

  // 获取下载路径
  String? get downloadPath => _downloadPath;

  // 获取解压路径
  String? get extractedPath => _extractedPath;

  // 清理更新文件
  Future<void> cleanupUpdate() async {
    try {
      if (_downloadPath != null && File(_downloadPath!).existsSync()) {
        await File(_downloadPath!).delete();
        _downloadPath = null;
      }
      if (_extractedPath != null && Directory(_extractedPath!).existsSync()) {
        await Directory(_extractedPath!).delete(recursive: true);
        _extractedPath = null;
      }
    } catch (e) {
      print('清理更新文件失败: $e');
    }
  }

  // 向后兼容
  Future<void> cleanupDownload() async {
    await cleanupUpdate();
  }

  // 保存更新信息到本地
  Future<void> saveUpdateInfo(UpdateInfo updateInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUpdateInfo', jsonEncode(updateInfo.toJson()));
  }

  // 获取本地保存的更新信息
  Future<UpdateInfo?> getLocalUpdateInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final infoString = prefs.getString('lastUpdateInfo');
    if (infoString != null) {
      try {
        final json = jsonDecode(infoString);
        return UpdateInfo.fromJson(json);
      } catch (e) {
        print('解析本地更新信息失败: $e');
      }
    }
    return null;
  }

  // 清除本地保存的更新信息
  Future<void> clearLocalUpdateInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUpdateInfo');
  }
}
