import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 文件日志工具类
/// 用于将日志写入本地文件
class FileLogUtils {
  static final FileLogUtils _instance = FileLogUtils._internal();

  factory FileLogUtils() => _instance;

  FileLogUtils._internal();

  Map<String, String> _logFilePaths = {};

  /// 确保日志文件存在
  /// [logType] 日志类型，用于区分不同的日志文件
  Future<String?> ensureLogFile(String logType) async {
    if (_logFilePaths.containsKey(logType)) return _logFilePaths[logType];
    
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
      
      final logsDir = Directory('${baseDir.path}/omt_logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      
      final date = DateTime.now();
      final y = date.year.toString().padLeft(4, '0');
      final m = date.month.toString().padLeft(2, '0');
      final d = date.day.toString().padLeft(2, '0');
      
      final logFilePath = '${logsDir.path}/${logType}_${y}${m}${d}.log';
      _logFilePaths[logType] = logFilePath;
      
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
      if (logFilePath == null) return;
      
      final now = DateTime.now().toIso8601String();
      final line = '[$now] $message\n';
      
      final file = File(logFilePath);
      await file.writeAsString(line, mode: FileMode.append, flush: true);
    } catch (_) {
      // 忽略日志写入失败
    }
  }
}