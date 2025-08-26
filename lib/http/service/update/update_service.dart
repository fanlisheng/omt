import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import '../../../bean/update/update_info.dart';
import '../../api.dart';
import 'mock_update_api.dart';

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

  // 获取当前版本信息
  Future<PackageInfo> getCurrentVersion() async {
    return await PackageInfo.fromPlatform();
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

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'update_${updateInfo.version}.zip';
      _downloadPath = '${appDir.path}/$fileName';

      await _dio.download(
        updateInfo.downloadUrl,
        _downloadPath!,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress = received / total;
            onProgress(_downloadProgress);
          }
        },
      );

      _isDownloading = false;
      return true;
    } catch (e) {
      _isDownloading = false;
      print('下载失败: $e');
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
        await extractDir.delete(recursive: true);
      }
      await extractDir.create(recursive: true);

      // 读取ZIP文件
      final bytes = await File(_downloadPath!).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 解压文件
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final outFile = File('$_extractedPath/$filename');
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        } else {
          await Directory('$_extractedPath/$filename').create(recursive: true);
        }
      }

      return true;
    } catch (e) {
      print('解压失败: $e');
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

  // 安装更新（按平台处理）
  Future<bool> installUpdate() async {
    if (_extractedPath == null) return false;
    try {
      if (Platform.isWindows) {
        final exe = await _findFirstByExtension('.exe');
        if (exe != null) {
          await Process.start(exe, []);
          exit(0);
        }
        throw Exception('未找到 .exe 安装程序');
      } else if (Platform.isMacOS) {
        // 优先 .app，其次 .dmg
        final app = await _findFirstAppBundle();
        if (app != null) {
          await Process.run('open', [app]);
          exit(0);
        }
        final dmg = await _findFirstByExtension('.dmg');
        if (dmg != null) {
          await Process.run('open', [dmg]);
          exit(0);
        }
        throw Exception('未找到 .app 或 .dmg 安装包');
      } else if (Platform.isLinux) {
        final deb = await _findFirstByExtension('.deb');
        if (deb != null) {
          await Process.run('dpkg', ['-i', deb]);
          exit(0);
        }
        throw Exception('未找到 .deb 安装包');
      }
      return false;
    } catch (e) {
      print('安装失败: $e');
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
}
