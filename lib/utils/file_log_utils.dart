import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 文件日志工具类
/// 用于将日志写入本地文件
class FileLogUtils {
  static final FileLogUtils _instance = FileLogUtils._internal();

  factory FileLogUtils() => _instance;

  FileLogUtils._internal();

  Map<String, String> _logFilePaths = {};
  String? _customProjectDir; // 自定义项目目录
  String? _cachedProjectDir; // 缓存的项目目录路径

  /// 设置自定义项目目录（用于确保路径一致性）
  void setProjectDirectory(String projectDir) {
    _customProjectDir = projectDir;
    _cachedProjectDir = projectDir; // 同时更新缓存
    // 清除已缓存的日志文件路径，强制重新计算
    _logFilePaths.clear();
  }

  /// 统一的项目目录获取方法
  /// 这是整个应用获取项目目录的唯一入口，确保路径一致性
  Future<String> getProjectDirectory() async {
    // 如果已有缓存，直接返回
    if (_cachedProjectDir != null) {
      print('FileLogUtils: 使用缓存的项目目录: $_cachedProjectDir');
      return _cachedProjectDir!;
    }

    String projectDir;
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // 桌面平台：使用可执行文件所在目录作为项目根目录
        final executablePath = Platform.resolvedExecutable;
        projectDir = Directory(executablePath).parent.path;
        print('FileLogUtils: Platform.resolvedExecutable = $executablePath');
        print('FileLogUtils: 计算出的项目目录 = $projectDir');
      } else {
        // 移动端：回退到应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        projectDir = appDir.path;
        print('FileLogUtils: 移动端应用文档目录 = $projectDir');
      }
    } catch (e) {
      // 如果获取项目目录失败，使用应用文档目录
      final appDir = await getApplicationDocumentsDirectory();
      projectDir = appDir.path;
      print('FileLogUtils: 获取项目目录失败，使用应用文档目录 = $projectDir');
      print('FileLogUtils: 错误详情: $e');
    }

    // 缓存项目目录
    _cachedProjectDir = projectDir;
    print('FileLogUtils: 项目目录已缓存: $_cachedProjectDir');
    
    return projectDir;
  }

  /// 清除项目目录缓存（在应用重启后可能需要重新获取）
  void clearProjectDirectoryCache() {
    _cachedProjectDir = null;
    _customProjectDir = null;
    _logFilePaths.clear();
    print('FileLogUtils: 项目目录缓存已清除');
  }

  /// 确保日志文件存在
  /// [logType] 日志类型，用于区分不同的日志文件
  Future<String?> ensureLogFile(String logType) async {
    if (_logFilePaths.containsKey(logType)) return _logFilePaths[logType];
    
    try {
      // 使用统一的项目目录获取方法
      final projectDirPath = await getProjectDirectory();
      final baseDir = Directory(projectDirPath);
      
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }
      
      // 在项目目录下创建logs文件夹
      final logsDir = Directory('${baseDir.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      
      final date = DateTime.now();
      final y = date.year.toString().padLeft(4, '0');
      final m = date.month.toString().padLeft(2, '0');
      final d = date.day.toString().padLeft(2, '0');
      
      final logFilePath = '${logsDir.path}/${logType}_${y}${m}${d}.log';
      _logFilePaths[logType] = logFilePath;
      
      // 输出调试信息到控制台（因为日志文件可能还没创建）
      print('FileLogUtils: 日志文件路径已设置: $logFilePath');
      print('FileLogUtils: 使用的项目目录: ${baseDir.path}');
      print('FileLogUtils: 自定义项目目录: $_customProjectDir');
      
      return logFilePath;
    } catch (_) {
      // 忽略日志初始化失败
      return null;
    }
  }

  /// 写入日志
  /// [logType] 日志类型，用于区分不同的日志文件
  /// [message] 日志消息
  Future<void> log(String logType, String message) async {
    try {
      final logFilePath = await ensureLogFile(logType);
      if (logFilePath == null) {
        print('FileLogUtils: 日志文件路径为空，无法写入日志');
        return;
      }
      
      final now = DateTime.now().toIso8601String();
      final line = '[$now] $message\n';
      
      final file = File(logFilePath);
      await file.writeAsString(line, mode: FileMode.append, flush: true);
      
      // 第一次写入时输出调试信息
      if (message.contains('UpdateService 初始化开始') || message.contains('DEBUG: Platform.resolvedExecutable')) {
        print('FileLogUtils: 日志已写入到: $logFilePath');
      }
    } catch (e) {
      // 输出日志写入失败的详细信息
      print('FileLogUtils: 日志写入失败: $e');
    }
  }
}