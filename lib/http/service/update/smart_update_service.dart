import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bean/update/update_info.dart';
import '../../http_manager.dart';
import 'package:omt/http/api.dart';
import 'app_optimizer.dart';

class SmartUpdateService {
  static final SmartUpdateService _instance = SmartUpdateService._internal();
  factory SmartUpdateService() => _instance;
  SmartUpdateService._internal();

  final Dio _dio = Dio();
  final AppOptimizer _appOptimizer = AppOptimizer();
  
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadPath;
  String? _tempPath;

  // 智能版本检查
  Future<UpdateInfo?> checkForUpdate({bool useMock = false}) async {
    try {
      if (useMock) {
        // 使用模拟API进行测试
        await Future.delayed(const Duration(seconds: 1));
        final mockResponse = _getMockUpdateResponse();
        final updateInfo = UpdateInfo.fromJson(mockResponse);
        final currentVersion = await getCurrentVersion();
        
        if (_compareVersions(updateInfo.version, currentVersion.version) > 0) {
          return updateInfo;
        }
        return null;
      }
      
      // 获取应用大小信息（保留，便于后续分析使用）
      final appInfo = await _appOptimizer.getAppSizeInfo();
      
      // 使用统一的 HttpManager 请求版本接口（GET）
      final completer = Completer<UpdateInfo?>();
      final timer = Timer(const Duration(seconds: 8), () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });
      HttpManager.share.doHttpPost<UpdateInfo>(
        await '${API.share.host}api/client_version/last',
        {},
        method: 'GET',
        autoHideDialog: true,
        autoShowDialog: false,
        onSuccess: (data) {
          if (!completer.isCompleted) completer.complete(data);
          if (timer.isActive) timer.cancel();
        },
        onCache: (data) {
          if (!completer.isCompleted) completer.complete(data);
          if (timer.isActive) timer.cancel();
        },
        onError: (msg) {
          if (!completer.isCompleted) completer.complete(null);
          if (timer.isActive) timer.cancel();
        },
      );

      final updateInfo = await completer.future;
      if (updateInfo != null) {
        final currentVersion = await getCurrentVersion();
        if (_compareVersions(updateInfo.version, currentVersion.version) > 0) {
          // 分析更新包大小和类型
          await _analyzeUpdatePackage(updateInfo);
          return updateInfo;
        }
      }
    } catch (e) {
      print('智能检查更新失败: $e');
    }
    return null;
  }

  // 分析更新包
  Future<void> _analyzeUpdatePackage(UpdateInfo updateInfo) async {
    try {
      final appInfo = await _appOptimizer.getAppSizeInfo();
      final currentSize = appInfo['appSize'] ?? 0;
      
      // 计算更新包大小
      final updateSize = updateInfo.fileSize;
      final sizeRatio = updateSize > 0 ? updateSize / currentSize : 0;
      
      print('更新包分析:');
      print('当前应用大小: ${_formatFileSize(currentSize)}');
      print('更新包大小: ${_formatFileSize(updateSize)}');
      print('大小比例: ${(sizeRatio * 100).toStringAsFixed(1)}%');
      
      // 根据大小比例选择更新策略
      if (sizeRatio > 0.5) {
        print('建议使用完整更新');
        updateInfo.forceUpdate = true; // 大更新建议强制安装
      } else {
        print('建议使用增量更新');
      }
    } catch (e) {
      print('分析更新包失败: $e');
    }
  }

  // 智能下载更新
  Future<bool> downloadUpdate(UpdateInfo updateInfo, Function(double) onProgress) async {
    if (_isDownloading) return false;
    
    _isDownloading = true;
    _downloadProgress = 0.0;
    
    try {
      // 创建临时下载目录
      final tempDir = await getTemporaryDirectory();
      _tempPath = '${tempDir.path}/update_temp';
      final tempDirectory = Directory(_tempPath!);
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
      await tempDirectory.create(recursive: true);
      
      // 下载更新包
      final fileName = _getUpdateFileName(updateInfo);
      _downloadPath = '$_tempPath/$fileName';
      
      // 配置下载选项
      final downloadOptions = await _getDownloadOptions(updateInfo);
      
      await _dio.download(
        updateInfo.downloadUrl,
        _downloadPath!,
        options: downloadOptions,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress = received / total;
            onProgress(_downloadProgress);
          }
        },
      );
      
      // 验证下载文件
      if (await _verifyDownloadedFile(updateInfo)) {
        _isDownloading = false;
        return true;
      } else {
        throw Exception('文件验证失败');
      }
    } catch (e) {
      _isDownloading = false;
      print('智能下载失败: $e');
      return false;
    }
  }

  // 获取下载选项
  Future<Options> _getDownloadOptions(UpdateInfo updateInfo) async {
    final appInfo = await _appOptimizer.getAppSizeInfo();
    final currentSize = appInfo['appSize'] ?? 0;
    
    // 根据文件大小设置超时时间
    final timeout = Duration(seconds: max(30, (updateInfo.fileSize / (1024 * 1024)).round()));
    
    return Options(
      sendTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'User-Agent': 'OMT-Update-Client/${appInfo['version']}',
        'Accept': 'application/octet-stream',
        'Accept-Encoding': 'gzip, deflate',
      },
    );
  }

  // 验证下载的文件
  Future<bool> _verifyDownloadedFile(UpdateInfo updateInfo) async {
    try {
      if (_downloadPath == null) return false;
      
      final file = File(_downloadPath!);
      if (!await file.exists()) return false;
      
      // 检查文件大小
      final fileSize = await file.length();
      if (fileSize != updateInfo.fileSize && updateInfo.fileSize > 0) {
        print('文件大小不匹配: 期望 ${updateInfo.fileSize}, 实际 $fileSize');
        return false;
      }
      
      // 检查文件扩展名
      final extension = _getFileExtension(_downloadPath!);
      if (!_isValidUpdateFile(extension)) {
        print('无效的更新文件类型: $extension');
        return false;
      }
      
      return true;
    } catch (e) {
      print('文件验证失败: $e');
      return false;
    }
  }

  // 获取更新文件名
  String _getUpdateFileName(UpdateInfo updateInfo) {
    final platform = Platform.operatingSystem;
    final version = updateInfo.version;
    
    switch (platform) {
      case 'windows':
        return 'omt_update_$version.exe';
      case 'macos':
        return 'omt_update_$version.dmg';
      case 'linux':
        return 'omt_update_$version.deb';
      default:
        return 'omt_update_$version.zip';
    }
  }

  // 检查是否为有效的更新文件
  bool _isValidUpdateFile(String extension) {
    final validExtensions = ['.exe', '.dmg', '.deb', '.zip', '.tar.gz'];
    return validExtensions.contains(extension.toLowerCase());
  }

  // 获取文件扩展名
  String _getFileExtension(String path) {
    final parts = path.split('.');
    if (parts.length > 1) {
      return '.${parts.last}';
    }
    return '';
  }

  // 格式化文件大小
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // 智能安装更新
  Future<bool> installUpdate() async {
    if (_downloadPath == null || !File(_downloadPath!).existsSync()) {
      return false;
    }
    
    try {
      final platform = Platform.operatingSystem;
      
      if (platform == 'windows') {
        // Windows: 启动安装程序并退出
        await Process.start(_downloadPath!, []);
        exit(0);
      } else if (platform == 'macos') {
        // macOS: 打开DMG文件
        await Process.run('open', [_downloadPath!]);
        exit(0);
      } else if (platform == 'linux') {
        // Linux: 安装deb包
        await Process.run('dpkg', ['-i', _downloadPath!]);
        exit(0);
      }
      
      return true;
    } catch (e) {
      print('智能安装失败: $e');
      return false;
    }
  }

  // 清理更新文件
  Future<void> cleanupUpdateFiles() async {
    try {
      if (_tempPath != null && Directory(_tempPath!).existsSync()) {
        await Directory(_tempPath!).delete(recursive: true);
        _tempPath = null;
      }
      
      if (_downloadPath != null && File(_downloadPath!).existsSync()) {
        await File(_downloadPath!).delete();
        _downloadPath = null;
      }
    } catch (e) {
      print('清理更新文件失败: $e');
    }
  }

  // 获取当前版本
  Future<PackageInfo> getCurrentVersion() async {
    return await PackageInfo.fromPlatform();
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

  // 获取模拟更新响应
  Map<String, dynamic> _getMockUpdateResponse() {
    return {
      'version': '1.1.0',
      'downloadUrl': 'https://example.com/downloads/omt_update_v1.1.0.zip',
      'changelog': '''
• 应用优化：
  - 减少应用包大小
  - 优化系统文件结构
  - 清理不必要的缓存文件

• 性能改进：
  - 提升启动速度
  - 优化内存使用
  - 改进文件管理

• 更新策略：
  - 支持增量更新
  - 智能文件压缩
  - 断点续传下载
      ''',
      'forceUpdate': false,
      'fileSize': 104857600, // 100MB
      'md5': 'a1b2c3d4e5f6g7h8i9j0',
    };
  }

  // 获取下载进度
  double get downloadProgress => _downloadProgress;
  
  // 是否正在下载
  bool get isDownloading => _isDownloading;
  
  // 获取下载路径
  String? get downloadPath => _downloadPath;
} 