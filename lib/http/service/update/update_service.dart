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

  /// 测试脚本创建和执行（用于诊断）
  Future<Map<String, dynamic>> testScriptCreation() async {
    final result = <String, dynamic>{};
    
    try {
      await logMessage('=== 开始脚本创建测试 ===');
      await logMessage('日志文件位置: 项目目录/logs/update_YYYYMMDD.log');
      
      // 1. 检查平台
      result['platform'] = Platform.operatingSystem;
      result['isWindows'] = Platform.isWindows;
      await logMessage('平台检查: ${result['platform']}, isWindows: ${result['isWindows']}');
      
      if (!Platform.isWindows) {
        result['error'] = '非Windows平台';
        return result;
      }
      
      // 2. 获取应用程序目录
      final appDir = Directory(Platform.resolvedExecutable).parent;
      result['appDir'] = appDir.path;
      result['appDirExists'] = await appDir.exists();
      await logMessage('应用程序目录: ${appDir.path}, 存在: ${result['appDirExists']}');
      
      // 3. 为测试目的，临时设置模拟的解压路径
      final originalExtractedPath = _extractedPath;
      final originalDownloadPath = _downloadPath;
      String? scriptPath;
      
      try {
        // 设置模拟路径用于测试 - 使用项目目录
        String projectDir;
        try {
          if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
            // 桌面平台：使用可执行文件所在目录作为项目根目录
            final executablePath = Platform.resolvedExecutable;
            projectDir = Directory(executablePath).parent.path;
          } else {
            // 移动端：回退到应用文档目录
            final appDocDir = await getApplicationDocumentsDirectory();
            projectDir = appDocDir.path;
          }
        } catch (e) {
          // 如果获取项目目录失败，使用应用文档目录
          final appDocDir = await getApplicationDocumentsDirectory();
          projectDir = appDocDir.path;
        }
        
        _extractedPath = '$projectDir/test_update_extracted';
        _downloadPath = '$projectDir/test_update.zip';
        
        await logMessage('项目目录: $projectDir');
        await logMessage('测试用解压路径: $_extractedPath');
        await logMessage('测试用下载路径: $_downloadPath');
        
        // 创建脚本
        scriptPath = await _createInstallScript();
        result['scriptPath'] = scriptPath;
        result['scriptCreated'] = scriptPath != null;
        await logMessage('脚本路径: $scriptPath, 创建成功: ${result['scriptCreated']}');
        
        // 恢复原始路径
        _extractedPath = originalExtractedPath;
        _downloadPath = originalDownloadPath;
      } catch (e) {
        // 确保恢复原始路径
        _extractedPath = originalExtractedPath;
        _downloadPath = originalDownloadPath;
        rethrow;
      }
      
      if (scriptPath == null) {
        result['error'] = '脚本创建失败';
        return result;
      }
      
      // 4. 验证脚本文件
      final scriptFile = File(scriptPath);
      result['scriptExists'] = await scriptFile.exists();
      await logMessage('脚本文件存在: ${result['scriptExists']}');
      
      if (result['scriptExists']) {
        final fileSize = await scriptFile.length();
        result['scriptSize'] = fileSize;
        await logMessage('脚本文件大小: $fileSize 字节');
        
        // 读取脚本内容
        try {
          final content = await scriptFile.readAsString();
          result['scriptContentLength'] = content.length;
          result['scriptFirstLine'] = content.split('\n').first;
          await logMessage('脚本内容长度: ${content.length}');
          await logMessage('脚本第一行: ${result['scriptFirstLine']}');
        } catch (e) {
          result['scriptReadError'] = e.toString();
          await logMessage('读取脚本内容失败: $e');
        }
      }
      
      // 5. 检查cmd命令可用性
      try {
        final cmdResult = await Process.run('cmd', ['/c', 'echo', 'test']);
        result['cmdAvailable'] = cmdResult.exitCode == 0;
        result['cmdOutput'] = cmdResult.stdout.toString().trim();
        await logMessage('cmd命令可用: ${result['cmdAvailable']}, 输出: ${result['cmdOutput']}');
      } catch (e) {
        result['cmdError'] = e.toString();
        await logMessage('cmd命令测试失败: $e');
      }
      
      // 6. 测试脚本执行（不实际启动，只测试命令构造）
       if (result['scriptExists']) {
         try {
           // 测试不同的启动方式
           final testCommands = [
             {'exe': 'cmd', 'args': ['/c', scriptPath]},
             {'exe': 'cmd', 'args': ['/c', 'start', '/min', scriptPath]},
           ];
           
           for (int i = 0; i < testCommands.length; i++) {
             final cmd = testCommands[i];
             try {
               // 只测试命令构造，不实际执行
               final exe = cmd['exe'] as String;
               final args = cmd['args'] as List<String>;
               await logMessage('测试命令 ${i + 1}: $exe ${args.join(' ')}');
               result['testCommand${i + 1}'] = '$exe ${args.join(' ')}';
             } catch (e) {
               result['testCommand${i + 1}Error'] = e.toString();
               await logMessage('测试命令 ${i + 1} 失败: $e');
             }
           }
         } catch (e) {
           result['commandTestError'] = e.toString();
           await logMessage('命令测试失败: $e');
         }
       }
      
      // 7. 检查工作目录权限
      try {
        final workDir = Directory(scriptPath).parent;
        result['workDir'] = workDir.path;
        result['workDirExists'] = await workDir.exists();
        
        // 尝试在工作目录创建测试文件
        final testFile = File('${workDir.path}/test_permissions.txt');
        await testFile.writeAsString('test');
        result['workDirWritable'] = await testFile.exists();
        if (result['workDirWritable']) {
          await testFile.delete();
        }
        await logMessage('工作目录: ${workDir.path}, 可写: ${result['workDirWritable']}');
      } catch (e) {
        result['workDirError'] = e.toString();
        await logMessage('工作目录权限测试失败: $e');
      }
      
      await logMessage('=== 脚本创建测试完成 ===');
      result['success'] = true;
      
    } catch (e) {
      result['error'] = e.toString();
      await logMessage('脚本创建测试失败: $e');
    }
    
    return result;
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
      // 使用项目目录存储下载文件
      String projectDir;
      try {
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // 桌面平台：使用可执行文件所在目录作为项目根目录
          final executablePath = Platform.resolvedExecutable;
          projectDir = Directory(executablePath).parent.path;
        } else {
          // 移动端：回退到应用文档目录
          final appDir = await getApplicationDocumentsDirectory();
          projectDir = appDir.path;
        }
      } catch (e) {
        // 如果获取项目目录失败，使用应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        projectDir = appDir.path;
      }
      
      final baseDir = Directory('$projectDir/downloads');
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }

      final fileName = 'update_${updateInfo.version}.zip';
      _downloadPath = '${baseDir.path}/$fileName';
      
      await logMessage('下载目录设置为: ${baseDir.path}');

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
      // 使用项目目录存储脚本
      String projectDir;
      try {
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // 桌面平台：使用可执行文件所在目录作为项目根目录
          final executablePath = Platform.resolvedExecutable;
          projectDir = Directory(executablePath).parent.path;
        } else {
          // 移动端：回退到应用文档目录
          final appDir = await getApplicationDocumentsDirectory();
          projectDir = appDir.path;
        }
      } catch (e) {
        // 如果获取项目目录失败，使用应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        projectDir = appDir.path;
      }
      
      final scriptDir = Directory('$projectDir/install_scripts');
      if (!await scriptDir.exists()) {
        await scriptDir.create(recursive: true);
      }
      
      await logMessage('脚本存储目录: ${scriptDir.path}');

      String scriptPath;
      String scriptContent;
      
      if (Platform.isWindows) {
        scriptPath = '${scriptDir.path}/install_update.bat';
        // 使用项目目录作为安装目标目录
        String currentAppDir = projectDir;
        await logMessage('使用项目目录作为安装目标: $currentAppDir');
        
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
      await logMessage('当前工作目录: ${Directory.current.path}');
      await logMessage('Platform.resolvedExecutable: ${Platform.resolvedExecutable}');
      
      // 创建安装脚本
      final scriptPath = await _createInstallScript();
      if (scriptPath == null) {
        await logMessage('ERROR: 创建安装脚本失败');
        return false;
      }

      await logMessage('安装脚本路径: $scriptPath');
      await logMessage('解压路径: $_extractedPath');
      await logMessage('下载路径: $_downloadPath');

      // 验证脚本文件
      final scriptFile = File(scriptPath);
      if (!await scriptFile.exists()) {
        await logMessage('ERROR: 脚本文件不存在: $scriptPath');
        return false;
      }
      
      final fileSize = await scriptFile.length();
      await logMessage('脚本文件大小: $fileSize 字节');
      
      if (fileSize == 0) {
        await logMessage('ERROR: 脚本文件为空');
        return false;
      }

      // 读取脚本内容的前几行进行验证
      try {
        final lines = await scriptFile.readAsLines();
        await logMessage('脚本总行数: ${lines.length}');
        if (lines.isNotEmpty) {
          await logMessage('脚本第一行: ${lines.first}');
        }
        if (lines.length > 1) {
          await logMessage('脚本第二行: ${lines[1]}');
        }
      } catch (e) {
        await logMessage('WARNING: 无法读取脚本内容进行验证: $e');
      }

      // 启动安装脚本
      await logMessage('准备启动安装脚本...');
      try {
        // 尝试多种启动方式
        Process? process;
        
        // 方法1: 使用cmd /c
        try {
          await logMessage('尝试方法1: cmd /c "$scriptPath"');
          process = await Process.start('cmd', ['/c', scriptPath], 
            mode: ProcessStartMode.detached,
            workingDirectory: Directory(scriptPath).parent.path);
          await logMessage('方法1成功: Windows安装脚本已启动，PID: ${process.pid}');
        } catch (e1) {
          await logMessage('方法1失败: $e1');
          
          // 方法2: 直接启动bat文件
          try {
            await logMessage('尝试方法2: 直接启动 "$scriptPath"');
            process = await Process.start(scriptPath, [], 
              mode: ProcessStartMode.detached,
              workingDirectory: Directory(scriptPath).parent.path);
            await logMessage('方法2成功: Windows安装脚本已启动，PID: ${process.pid}');
          } catch (e2) {
            await logMessage('方法2失败: $e2');
            
            // 方法3: 使用start命令
            try {
              await logMessage('尝试方法3: start /min "$scriptPath"');
              process = await Process.start('cmd', ['/c', 'start', '/min', scriptPath], 
                mode: ProcessStartMode.detached,
                workingDirectory: Directory(scriptPath).parent.path);
              await logMessage('方法3成功: Windows安装脚本已启动，PID: ${process.pid}');
            } catch (e3) {
              await logMessage('方法3失败: $e3');
              await logMessage('ERROR: 所有启动方法都失败了');
              await logMessage('最后的错误信息: $e3');
              return false;
            }
          }
        }
        
        if (process != null) {
          // 等待脚本完全启动
          await Future.delayed(Duration(milliseconds: 1000));
          await logMessage('脚本启动延迟完成');
          
          // 检查进程是否还在运行
          try {
            final isRunning = !process.kill(ProcessSignal.sigusr1); // 发送无害信号测试进程状态
            await logMessage('进程状态检查: ${isRunning ? "运行中" : "已退出"}');
          } catch (e) {
            await logMessage('无法检查进程状态: $e');
          }
        }
        
      } catch (e) {
        await logMessage('启动安装脚本失败，详细错误: $e');
        await logMessage('错误类型: ${e.runtimeType}');
        if (e is ProcessException) {
          await logMessage('ProcessException详情:');
          await logMessage('  executable: ${e.executable}');
          await logMessage('  arguments: ${e.arguments}');
          await logMessage('  message: ${e.message}');
          await logMessage('  errorCode: ${e.errorCode}');
        }
        return false;
      }

      await logMessage('安装脚本启动成功，应用将退出...');
      
      // 退出应用，让脚本接管更新过程
      await logMessage('正在退出应用...');
      
      // 退出应用
      exit(0);
      
      return true;
    } catch (e) {
      await logMessage('installUpdate总体失败: $e');
      await logMessage('错误堆栈: ${StackTrace.current}');
      return false;
    }
  }

  // 解压ZIP更新包
  Future<bool> extractUpdatePackage() async {
    if (_downloadPath == null) return false;

    try {
      // 使用项目目录存储解压文件
      String projectDir;
      try {
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // 桌面平台：使用可执行文件所在目录作为项目根目录
          final executablePath = Platform.resolvedExecutable;
          projectDir = Directory(executablePath).parent.path;
        } else {
          // 移动端：回退到应用文档目录
          final appDir = await getApplicationDocumentsDirectory();
          projectDir = appDir.path;
        }
      } catch (e) {
        // 如果获取项目目录失败，使用应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        projectDir = appDir.path;
      }
      
      _extractedPath = '$projectDir/update_extracted';
      await logMessage('解压目录设置为: $_extractedPath');

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
