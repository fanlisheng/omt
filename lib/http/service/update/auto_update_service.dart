import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bean/update/update_info.dart';
import '../../../utils/file_log_utils.dart';
import '../../http_manager.dart';
import 'package:omt/http/api.dart';

/// 基于 auto_updater 的自动更新服务
/// 使用 Sparkle (macOS) 和 WinSparkle (Windows) 实现自动更新
class AutoUpdateService {
  static final AutoUpdateService _instance = AutoUpdateService._internal();
  factory AutoUpdateService() => _instance;
  AutoUpdateService._internal();

  final FileLogUtils _fileLogger = FileLogUtils();
  final String _logType = 'auto_update';
  
  bool _isInitialized = false;
  String? _feedUrl;
  UpdateInfo? _latestUpdateInfo;
  
  // 更新状态
  bool _isChecking = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _updateStatus = '';
  
  // 回调函数
  Function(UpdateInfo)? onUpdateAvailable;
  Function(double)? onDownloadProgress;
  Function(String)? onStatusChanged;
  Function(String)? onError;

  /// 初始化自动更新服务
  Future<void> initialize({String? customFeedUrl}) async {
    if (_isInitialized) return;
    
    try {
      await logMessage('=== AutoUpdateService 初始化开始 ===');
      
      // 仅桌面平台支持
      if (!Platform.isWindows && !Platform.isMacOS) {
        await logMessage('当前平台不支持自动更新: ${Platform.operatingSystem}');
        return;
      }
      
      // 设置 Feed URL
      _feedUrl = customFeedUrl ?? await _getDefaultFeedUrl();
      await logMessage('Feed URL: $_feedUrl');
      
      if (_feedUrl != null && _feedUrl!.isNotEmpty) {
        await autoUpdater.setFeedURL(_feedUrl!);
        await logMessage('已设置 Feed URL');
        
        // 设置定时检查间隔（默认每小时检查一次）
        await autoUpdater.setScheduledCheckInterval(3600);
        await logMessage('已设置定时检查间隔: 3600秒');
      }
      
      _isInitialized = true;
      await logMessage('=== AutoUpdateService 初始化完成 ===');
    } catch (e, stack) {
      await logMessage('初始化失败: $e\n$stack');
      rethrow;
    }
  }

  /// 获取默认的 Feed URL
  Future<String> _getDefaultFeedUrl() async {
    try {
      final host = await API.share.host;
      // 根据平台返回对应的 appcast 地址
      if (Platform.isWindows) {
        return '${host}api/appcast/windows.xml';
      } else if (Platform.isMacOS) {
        return '${host}api/appcast/macos.xml';
      }
    } catch (e) {
      await logMessage('获取默认 Feed URL 失败: $e');
    }
    return '';
  }

  /// 检查更新
  Future<UpdateInfo?> checkForUpdate({bool silent = false}) async {
    if (_isChecking) {
      await logMessage('正在检查更新中，请稍候...');
      return null;
    }
    
    _isChecking = true;
    _updateStatus = '正在检查更新...';
    onStatusChanged?.call(_updateStatus);
    
    try {
      await logMessage('开始检查更新...');
      
      // 方式1: 先通过后端 API 检查是否有新版本
      final updateInfo = await _checkUpdateFromApi();
      if (updateInfo != null) {
        _latestUpdateInfo = updateInfo;
        await logMessage('发现新版本: ${updateInfo.version}');
        onUpdateAvailable?.call(updateInfo);
        return updateInfo;
      }
      
      // 方式2: 使用 auto_updater 原生检查
      if (_isInitialized && _feedUrl != null && _feedUrl!.isNotEmpty) {
        await autoUpdater.checkForUpdates();
        await logMessage('已触发 auto_updater 检查');
      }
      
      _updateStatus = '已是最新版本';
      onStatusChanged?.call(_updateStatus);
      await logMessage('当前已是最新版本');
      return null;
    } catch (e) {
      _updateStatus = '检查更新失败';
      onStatusChanged?.call(_updateStatus);
      onError?.call('检查更新失败: $e');
      await logMessage('检查更新失败: $e');
      return null;
    } finally {
      _isChecking = false;
    }
  }

  /// 从后端 API 检查更新
  Future<UpdateInfo?> _checkUpdateFromApi() async {
    try {
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
          return updateInfo;
        }
      }
      return null;
    } catch (e) {
      await logMessage('API 检查更新失败: $e');
      return null;
    }
  }

  /// 触发自动更新检查（使用 auto_updater 原生 UI）
  Future<void> checkForUpdatesInteractive() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      await logMessage('触发交互式更新检查...');
      await autoUpdater.checkForUpdates();
    } catch (e) {
      await logMessage('交互式更新检查失败: $e');
      onError?.call('检查更新失败: $e');
    }
  }

  /// 获取当前版本信息
  Future<PackageInfo> getCurrentVersion() async {
    return await PackageInfo.fromPlatform();
  }

  /// 版本号比较
  int _compareVersions(String version1, String version2) {
    try {
      final v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final maxLength = v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

      for (int i = 0; i < maxLength; i++) {
        final v1 = i < v1Parts.length ? v1Parts[i] : 0;
        final v2 = i < v2Parts.length ? v2Parts[i] : 0;

        if (v1 > v2) return 1;
        if (v1 < v2) return -1;
      }
    } catch (e) {
      debugPrint('版本比较失败: $e');
    }
    return 0;
  }

  /// 设置检查间隔（秒）
  /// 最小值: 3600秒（1小时）
  /// 0: 禁用定时检查
  Future<void> setCheckInterval(int seconds) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      await autoUpdater.setScheduledCheckInterval(seconds);
      await logMessage('已设置检查间隔: $seconds 秒');
    } catch (e) {
      await logMessage('设置检查间隔失败: $e');
    }
  }

  /// 禁用定时检查
  Future<void> disableScheduledCheck() async {
    await setCheckInterval(0);
  }

  /// 保存更新信息到本地
  Future<void> saveUpdateInfo(UpdateInfo updateInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastAutoUpdateInfo', jsonEncode(updateInfo.toJson()));
      await logMessage('已保存更新信息');
    } catch (e) {
      await logMessage('保存更新信息失败: $e');
    }
  }

  /// 获取本地保存的更新信息
  Future<UpdateInfo?> getLocalUpdateInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final infoString = prefs.getString('lastAutoUpdateInfo');
      if (infoString != null) {
        final json = jsonDecode(infoString);
        return UpdateInfo.fromJson(json);
      }
    } catch (e) {
      await logMessage('获取本地更新信息失败: $e');
    }
    return null;
  }

  /// 清除本地保存的更新信息
  Future<void> clearLocalUpdateInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lastAutoUpdateInfo');
      await logMessage('已清除本地更新信息');
    } catch (e) {
      await logMessage('清除本地更新信息失败: $e');
    }
  }

  /// 记录日志
  Future<void> logMessage(String message) async {
    await _fileLogger.log(_logType, message);
    debugPrint('[AutoUpdate] $message');
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isChecking => _isChecking;
  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  String get updateStatus => _updateStatus;
  UpdateInfo? get latestUpdateInfo => _latestUpdateInfo;
  String? get feedUrl => _feedUrl;
}
