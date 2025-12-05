import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'package:window_manager/window_manager.dart';
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
  // 获取项目目录（使用FileLogUtils统一管理）
  Future<String> _getProjectDirectory() async {
    final projectDir = await _fileLogger.getProjectDirectory();
    await logMessage('DEBUG: 从FileLogUtils获取项目目录: $projectDir');
    return projectDir;
  }

  // 清除项目目录缓存（委托给FileLogUtils）
  void _clearProjectDirectoryCache() {
    _fileLogger.clearProjectDirectoryCache();
    logMessage('DEBUG: 项目目录缓存已清除（通过FileLogUtils）');
  }

  // 初始化更新服务，确保日志系统正确配置
  Future<void> initialize() async {
    await logMessage('=== UpdateService 初始化开始 ===');
    try {
      // 获取项目目录（FileLogUtils会自动管理缓存和配置）
      final projectDir = await _getProjectDirectory();
      await logMessage('UpdateService 初始化完成，项目目录: $projectDir');
    } catch (e) {
      await logMessage('UpdateService 初始化失败: $e');
    }
    await logMessage('=== UpdateService 初始化结束 ===');
  }

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
      
      // 2. 获取应用程序目录（使用FileLogUtils统一管理）
      final projectDir = await _getProjectDirectory();
      final appDir = Directory(projectDir);
      result['appDir'] = appDir.path;
      result['appDirExists'] = await appDir.exists();
      await logMessage('应用程序目录: ${appDir.path}, 存在: ${result['appDirExists']}');
      
      // 3. 为测试目的，临时设置模拟的解压路径
      final originalExtractedPath = _extractedPath;
      final originalDownloadPath = _downloadPath;
      String? scriptPath;
      
      try {
        // 设置模拟路径用于测试 - 使用FileLogUtils统一获取项目目录
        final projectDir = await _getProjectDirectory();
        
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

  // 下载更新包（支持 exe 和 zip）
  Future<bool> downloadUpdate(
      UpdateInfo updateInfo, Function(double) onProgress) async {
    if (_isDownloading) return false;

    _isDownloading = true;
    _downloadProgress = 0.0;
    _cancelToken = CancelToken();

    try {
      // 使用统一的项目目录获取方法
      final projectDir = await _getProjectDirectory();
      
      final baseDir = Directory('$projectDir/downloads');
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }

      // 根据 URL 扩展名决定保存文件名（固定文件名，避免旧文件堆积）
      final url = updateInfo.downloadUrl.toLowerCase();
      final String fileName;
      if (url.endsWith('.exe')) {
        fileName = 'OMT-Setup.exe';
      } else if (url.endsWith('.zip')) {
        fileName = 'update.zip';
      } else {
        // 默认为 exe
        fileName = 'OMT-Setup.exe';
      }
      _downloadPath = '${baseDir.path}/$fileName';
      
      await logMessage('保存文件名: $fileName');
      
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
      // 使用统一的项目目录获取方法
      final projectDir = await _getProjectDirectory();
      
      final scriptDir = Directory('$projectDir${Platform.pathSeparator}install_scripts');
      if (!await scriptDir.exists()) {
        await scriptDir.create(recursive: true);
      }
      
      await logMessage('脚本存储目录: ${scriptDir.path}');

      String scriptPath;
      String scriptContent;
      
      if (Platform.isWindows) {
        scriptPath = '${scriptDir.path}${Platform.pathSeparator}install_update.bat';
        
        // 获取应用程序所在目录（omt.exe的父目录）
        final appDir = File(Platform.resolvedExecutable).parent.path;
        
        if (isExeInstaller) {
          // exe 安装程序：直接运行静默安装到应用目录
          await logMessage('=== EXE 安装模式 ===');
          await logMessage('安装程序路径: $_extractedPath');
          await logMessage('安装程序路径(Windows格式): ${_extractedPath!.replaceAll('/', '\\')}');
          await logMessage('安装目标目录: $appDir');
          await logMessage('安装目标目录(Windows格式): ${appDir.replaceAll('/', '\\')}');
          
          // 检查安装程序文件是否存在
          final installerFile = File(_extractedPath!);
          final installerExists = await installerFile.exists();
          await logMessage('安装程序文件存在: $installerExists');
          if (installerExists) {
            final installerSize = await installerFile.length();
            await logMessage('安装程序文件大小: $installerSize 字节');
          }
          
          scriptContent = WindowsInstallScript.generateInstallerScript(
            installerPath: _extractedPath!,
            appDir: appDir,
          );
          
          await logMessage('将运行 EXE 安装程序完成更新（静默模式，安装到原目录）');
          await logMessage('生成的脚本内容长度: ${scriptContent.length} 字符');
        } else {
          // zip 解压后：覆盖文件
          await logMessage('解压目录: $_extractedPath');
          await logMessage('应用目录: $appDir');
          
          scriptContent = WindowsInstallScript.generateInstallScript(
            extractedPath: _extractedPath!,
            appDir: appDir,
          );
          
          await logMessage('将覆盖应用目录中的文件完成更新');
        }
      } else {
        // 非Windows平台不支持
        await logMessage('当前平台不支持自动安装: ${Platform.operatingSystem}');
        return null;
      }

      final scriptFile = File(scriptPath);
      // 使用latin1编码写入bat脚本（脚本只包含ASCII字符，避免编码问题）
      // 注意：不要使用systemEncoding，因为某些Windows系统可能无法正确处理
      await scriptFile.writeAsString(scriptContent, encoding: latin1);
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

      // 脚本内部已包含延迟，直接启动
      await logMessage('开始执行安装脚本');

      // 读取脚本内容的前几行进行验证（使用latin1编码匹配写入时的编码）
      try {
        final lines = await scriptFile.readAsLines(encoding: latin1);
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

      // 启动安装脚本（静默模式）
      await logMessage('准备启动安装脚本（静默模式）...');
      
      // 获取脚本所在目录作为工作目录
      final scriptDir = File(scriptPath).parent.path;
      await logMessage('脚本工作目录: $scriptDir');
      
      // 检查脚本文件是否可执行
      final scriptFileCheck = File(scriptPath);
      if (!await scriptFileCheck.exists()) {
        await logMessage('ERROR: 脚本文件不存在: $scriptPath');
        return false;
      }
      
      // 尝试多种异步启动方式
      bool scriptStarted = false;
      
      try {
        
        // 方法0: 使用 cmd /c 正确执行 bat 文件
        if (!scriptStarted) {
          try {
            await logMessage('尝试方法0: 使用cmd /c执行bat文件');
            await logMessage('启动脚本: $scriptPath');
            // 使用 cmd /c 来正确执行 .bat 文件（/c 参数会在执行完后自动关闭窗口）
            final process = await Process.start(
              'cmd', 
              ['/c', 'start', '/B', scriptPath],  // /B 参数表示在后台运行，不创建新窗口
              workingDirectory: scriptDir,
              mode: ProcessStartMode.detached,
            );
            await logMessage('方法0成功: 脚本进程已启动，PID: ${process.pid}');
            scriptStarted = true;
          } catch (e0) {
            await logMessage('方法0失败: $e0');
          }
        }
        
        // 方法1: 使用 cmd start 异步启动（隐藏窗口）
        if (!scriptStarted) {
          try {
            await logMessage('尝试方法1: CMD异步启动（隐藏窗口）');
            await logMessage('执行命令: cmd /c start /MIN "" "$scriptPath"');
            await logMessage('工作目录: $scriptDir');
            // 使用 start /MIN 命令异步启动并最小化窗口
            final process = await Process.start('cmd', ['/c', 'start', '/MIN', '', scriptPath], 
              workingDirectory: scriptDir,
              mode: ProcessStartMode.detached);
            await logMessage('方法1成功: 安装脚本已异步启动（隐藏窗口），PID: ${process.pid}');
            scriptStarted = true;
          } catch (e1) {
            await logMessage('方法1失败: $e1');
          }
        }
        
        // 方法2: 使用 PowerShell 隐藏窗口启动
        if (!scriptStarted) {
          try {
            await logMessage('尝试方法2: PowerShell隐藏窗口启动');
            await logMessage('执行命令: powershell -WindowStyle Hidden -Command "Start-Process \\"$scriptPath\\" -WindowStyle Hidden"');
            final result = await Process.run('powershell', [
              '-WindowStyle', 'Hidden',
              '-Command', 'Start-Process "$scriptPath" -WindowStyle Hidden'
            ], workingDirectory: scriptDir);
            if (result.exitCode == 0) {
              await logMessage('方法2成功: 安装脚本已通过PowerShell隐藏启动');
              scriptStarted = true;
            } else {
              await logMessage('方法2失败: 退出码 ${result.exitCode}');
              await logMessage('stderr: ${result.stderr}');
            }
          } catch (e2) {
            await logMessage('方法2失败: $e2');
          }
        }
        
        // 方法3: 使用 wscript 完全静默启动
        if (!scriptStarted) {
          try {
            await logMessage('尝试方法3: WScript静默启动');
            // 创建临时VBS脚本来静默启动批处理文件
            final vbsPath = '${scriptDir}${Platform.pathSeparator}silent_start.vbs';
            final vbsContent = '''
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """$scriptPath""", 0, False
''';
            await File(vbsPath).writeAsString(vbsContent, encoding: latin1);
            await logMessage('VBS脚本已创建: $vbsPath');
            
            final result = await Process.run('wscript', [vbsPath], 
              workingDirectory: scriptDir);
            if (result.exitCode == 0) {
              await logMessage('方法3成功: 安装脚本已通过VBS静默启动');
              scriptStarted = true;
            } else {
              await logMessage('方法3失败: 退出码 ${result.exitCode}');
              await logMessage('stderr: ${result.stderr}');
            }
          } catch (e3) {
            await logMessage('方法3失败: $e3');
          }
        }
        
        // 如果所有方法都失败了
        if (!scriptStarted) {
          await logMessage('ERROR: 所有启动方法都失败了');
          await logMessage('WARNING: 即使脚本启动失败，也将退出应用以释放文件锁定');
        } else {
          await logMessage('脚本已成功启动（异步模式）');
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

      await logMessage('安装脚本启动成功，应用将立即退出...');
      
      // 立即退出应用，让脚本处理延迟
      await logMessage('脚本已启动，立即退出应用以释放文件锁定...');
      await _forceExitApp(0);
    } catch (e) {
      await logMessage('installUpdate总体失败: $e');
      await logMessage('错误堆栈: ${StackTrace.current}');
      await logMessage('ERROR: 更新过程中发生异常，但仍将强制退出应用以释放文件锁定');
      
      // 即使发生异常也要退出应用，避免文件被占用
      await _forceExitApp(1); // 使用退出码1表示异常退出
    }
    
    // 这行代码永远不会执行，因为上面总是调用exit()
    // 但是为了满足返回类型要求而添加
    return false;
  }

  // 判断下载的是否为 exe 安装程序
  bool get isExeInstaller => _downloadPath?.toLowerCase().endsWith('.exe') ?? false;

  // 解压ZIP更新包（如果是exe则跳过解压）
  Future<bool> extractUpdatePackage() async {
    if (_downloadPath == null) return false;

    try {
      // 如果是 exe 安装程序，不需要解压，直接标记为准备好
      if (isExeInstaller) {
        await logMessage('下载的是 EXE 安装程序，跳过解压步骤');
        _extractedPath = _downloadPath; // 直接使用 exe 路径
        return true;
      }

      // 使用统一的项目目录获取方法
      final projectDir = await _getProjectDirectory();
      
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
    if (_extractedPath == null) return false;
    
    // 如果是 exe 安装程序，直接检查文件本身
    if (isExeInstaller) {
      return _extractedPath!.toLowerCase().endsWith(extLower);
    }
    
    // 否则遍历目录查找
    final dir = Directory(_extractedPath!);
    if (!await dir.exists()) return false;
    
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

  // 强制退出应用程序
  Future<void> _forceExitApp(int exitCode) async {
    await logMessage('强制退出应用，退出码: $exitCode');
    
    try {
      // 先记录日志
      await logMessage('准备强制退出进程，PID: ${pid}');
      
      // 尝试销毁窗口（异步，不等待结果）
      windowManager.destroy().catchError((e) {
        print('销毁窗口失败: $e');
      });
      
      // 等待100ms让窗口销毁
      await Future.delayed(Duration(milliseconds: 100));
      
      // 在Windows上，使用taskkill确保进程被杀死
      if (Platform.isWindows) {
        await logMessage('使用taskkill强制终止当前进程...');
        try {
          // 异步执行taskkill，不等待结果
          Process.run('taskkill', ['/F', '/PID', pid.toString()]).then((_) {
            print('taskkill执行完成');
          }).catchError((e) {
            print('taskkill失败: $e');
          });
        } catch (e) {
          await logMessage('taskkill失败: $e');
        }
      }
      
      // 立即强制退出进程
      await logMessage('执行 exit($exitCode) 强制退出');
      exit(exitCode);
      
    } catch (e) {
      await logMessage('退出失败: $e');
      // 最终保障：无论如何都要退出
      exit(exitCode);
    }
  }

  /// 调试方法：直接测试安装 downloads 目录中已存在的 exe
  /// 不需要下载，直接运行安装流程
  Future<Map<String, dynamic>> debugTestInstall() async {
    final result = <String, dynamic>{};
    
    try {
      await logMessage('=== 调试测试安装开始 ===');
      
      // 获取项目目录
      final projectDir = await _getProjectDirectory();
      result['projectDir'] = projectDir;
      await logMessage('项目目录: $projectDir');
      
      // 查找 downloads 目录中的 exe
      final downloadsDir = Directory('$projectDir/downloads');
      result['downloadsDir'] = downloadsDir.path;
      result['downloadsDirExists'] = await downloadsDir.exists();
      await logMessage('下载目录: ${downloadsDir.path}');
      await logMessage('下载目录存在: ${result['downloadsDirExists']}');
      
      if (!result['downloadsDirExists']) {
        result['error'] = '下载目录不存在';
        return result;
      }
      
      // 查找 exe 文件
      String? exePath;
      await for (final entity in downloadsDir.list()) {
        if (entity is File && entity.path.toLowerCase().endsWith('.exe')) {
          exePath = entity.path;
          break;
        }
      }
      
      result['exePath'] = exePath;
      await logMessage('找到的 EXE: $exePath');
      
      if (exePath == null) {
        result['error'] = '未找到 exe 文件';
        return result;
      }
      
      // 设置路径
      _downloadPath = exePath;
      _extractedPath = exePath;
      
      result['isExeInstaller'] = isExeInstaller;
      await logMessage('isExeInstaller: ${result['isExeInstaller']}');
      
      // 检查 exe 文件信息
      final exeFile = File(exePath);
      result['exeExists'] = await exeFile.exists();
      result['exeSize'] = await exeFile.length();
      await logMessage('EXE 存在: ${result['exeExists']}');
      await logMessage('EXE 大小: ${result['exeSize']} 字节');
      
      // 测试 existsByExtension
      final hasExe = await existsByExtension('.exe');
      result['existsByExtension'] = hasExe;
      await logMessage('existsByExtension(.exe): $hasExe');
      
      // 获取应用目录
      final appDir = File(Platform.resolvedExecutable).parent.path;
      result['appDir'] = appDir;
      await logMessage('应用目录: $appDir');
      
      result['success'] = true;
      result['message'] = '调试信息收集完成，可以调用 installUpdate() 进行安装';
      await logMessage('=== 调试测试安装结束 ===');
      
    } catch (e) {
      result['error'] = e.toString();
      await logMessage('调试测试出错: $e');
    }
    
    return result;
  }

  /// 调试方法：直接执行安装（危险：会退出应用）
  Future<bool> debugRunInstall() async {
    await logMessage('=== 调试执行安装 ===');
    
    // 先收集信息
    final info = await debugTestInstall();
    if (info['error'] != null) {
      await logMessage('调试信息收集失败: ${info['error']}');
      return false;
    }
    
    // 执行安装
    return await installUpdate();
  }
}
