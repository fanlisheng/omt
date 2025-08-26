import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppOptimizer {
  static final AppOptimizer _instance = AppOptimizer._internal();
  factory AppOptimizer() => _instance;
  AppOptimizer._internal();

  // 获取应用大小信息
  Future<Map<String, dynamic>> getAppSizeInfo() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final appPath = appDir.path;
      
      // 获取应用包信息
      final packageInfo = await PackageInfo.fromPlatform();
      
      // 计算应用大小
      final appSize = await _calculateDirectorySize(appPath);
      
      // 获取系统信息
      final platform = Platform.operatingSystem;
      final version = Platform.operatingSystemVersion;
      
      return {
        'appName': packageInfo.appName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'packageName': packageInfo.packageName,
        'appSize': appSize,
        'platform': platform,
        'osVersion': version,
        'appPath': appPath,
      };
    } catch (e) {
      print('获取应用信息失败: $e');
      return {};
    }
  }

  // 计算目录大小
  Future<int> _calculateDirectorySize(String path) async {
    try {
      final dir = Directory(path);
      if (!await dir.exists()) return 0;
      
      int totalSize = 0;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          try {
            totalSize += await entity.length();
          } catch (e) {
            // 忽略无法访问的文件
          }
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  // 获取可优化的文件列表
  Future<List<Map<String, dynamic>>> getOptimizableFiles() async {
    final List<Map<String, dynamic>> optimizableFiles = [];
    
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final appPath = appDir.path;
      
      // 常见的可优化文件类型
      final optimizableExtensions = [
        '.log', '.tmp', '.cache', '.dll', '.so', '.dylib',
        '.framework', '.bundle', '.app', '.exe'
      ];
      
      final dir = Directory(appPath);
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) {
            final extension = _getFileExtension(entity.path);
            if (optimizableExtensions.contains(extension)) {
              try {
                final size = await entity.length();
                if (size > 1024 * 1024) { // 大于1MB的文件
                  optimizableFiles.add({
                    'path': entity.path,
                    'name': entity.path.split('/').last,
                    'size': size,
                    'sizeFormatted': _formatFileSize(size),
                    'extension': extension,
                    'canOptimize': true,
                  });
                }
              } catch (e) {
                // 忽略无法访问的文件
              }
            }
          }
        }
      }
    } catch (e) {
      print('获取可优化文件失败: $e');
    }
    
    return optimizableFiles;
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

  // 清理缓存文件
  Future<bool> cleanupCache() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/cache');
      
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      print('清理缓存失败: $e');
      return false;
    }
  }

  // 获取更新策略建议
  Map<String, dynamic> getUpdateStrategy() {
    return {
      'strategy': 'incremental', // 增量更新策略
      'compression': 'lzma', // 使用LZMA压缩
      'deltaUpdate': true, // 启用增量更新
      'fileFilter': [
        '*.dll', '*.so', '*.dylib', '*.framework', '*.bundle'
      ],
      'excludePatterns': [
        '*.log', '*.tmp', '*.cache', 'temp/*', 'logs/*'
      ],
      'recommendations': [
        '使用增量更新减少下载大小',
        '压缩核心文件',
        '排除临时文件和日志',
        '保留用户数据',
        '使用断点续传'
      ]
    };
  }
} 