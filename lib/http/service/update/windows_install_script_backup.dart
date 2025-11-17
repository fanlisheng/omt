import 'dart:io';

/// Windows 安装脚本生成器
/// 用于生成 Windows 平台的应用更新安装脚本
class WindowsInstallScript {
  /// 生成安装脚本
  /// 
  /// [extractedPath] 解压后的文件路径
  /// [downloadPath] 下载的zip文件路径
  /// [appName] 应用程序名称，默认为 'omt.exe'
  /// [targetDir] 目标安装目录，如果为null则使用extractedPath的父目录
  /// 
  /// 返回生成的批处理脚本内容
  static String generateScript({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    return _getSimplifiedScriptTemplate()
        .replaceAll('\${appName}', appName)
        .replaceAll('\${sourceDir}', extractedPathWin)
        .replaceAll('\${targetDir}', targetDirWin)
        .replaceAll('\${zipPath}', downloadPathWin);
  }

  /// 获取简化的脚本模板
  static String _getSimplifiedScriptTemplate() {
    return '''
@echo off
echo OMT Update Installer Starting...

REM Wait for application to exit
timeout /t 3 /nobreak >nul 2>&1

REM Set variables
set "APP_NAME=\${appName}"
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "ZIP_PATH=\${zipPath}"

echo Checking source: %SOURCE_DIR%
if not exist "%SOURCE_DIR%" (
    echo ERROR: Source not found
    pause
    exit /b 1
)

echo Preparing target: %TARGET_DIR%
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Copying files...
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:1 /W:1 >nul
if %ERRORLEVEL% GTR 7 (
    echo ERROR: Copy failed
    pause
    exit /b 1
)

echo Cleaning up...
if exist "%ZIP_PATH%" del "%ZIP_PATH%" >nul 2>&1

echo Starting application...
cd /d "%TARGET_DIR%"
start "" "%APP_NAME%"

echo Update completed!
exit /b 0
''';
  }

  /// 生成测试版本的安装脚本（简化版本）
  static String generateTestScript({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    // 使用简化的脚本模板
    return _getSimplifiedScriptTemplate()
        .replaceAll('\${appName}', appName)
        .replaceAll('\${sourceDir}', extractedPathWin)
        .replaceAll('\${targetDir}', targetDirWin)
        .replaceAll('\${zipPath}', downloadPathWin);
  }

  /// 获取默认的脚本模板（作为备用）
  static String _getDefaultScriptTemplate() {
    return '''
@echo off
REM ========================================
REM     OMT Update Installer
REM ========================================

REM Wait for application to exit
ping 127.0.0.1 -n 3 >nul 2>&1

REM Set encoding for better compatibility
chcp 65001 >nul 2>&1

set "APP_NAME=\${appName}"
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
set "ZIP_PATH=\${zipPath}"

echo Starting update process...

REM Step 1: Check source directory
echo Step 1: Checking source directory...
if not exist "%SOURCE_DIR%" (
    echo ERROR: Source directory not found: %SOURCE_DIR%
    exit /b 1
)
echo OK: Source directory exists

REM Step 2: Create target directory if needed
echo Step 2: Preparing target directory...
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    if errorlevel 1 (
        echo ERROR: Failed to create target directory
        exit /b 1
    )
    echo OK: Target directory created
) else (
    echo OK: Target directory exists
)

REM Step 3: Copy files
echo Step 3: Copying files...
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R >nul 2>&1
if %ERRORLEVEL% GEQ 4 (
    echo ERROR: File copy failed with code %ERRORLEVEL%
    exit /b 1
)
echo OK: Files copied successfully

REM Step 4: Clean up
echo Step 4: Cleaning up...
if exist "%ZIP_PATH%" del "%ZIP_PATH%" >nul 2>&1
echo OK: Cleanup completed

REM Step 5: Launch application
echo Step 5: Launching application...
cd /d "%TARGET_DIR%"
if exist "%APP_PATH%" (
    start "" "%APP_PATH%" >nul 2>&1
    echo OK: Application started
) else (
    echo WARNING: Application not found at %APP_PATH%
)

echo Update process completed!
exit /b 0
''';
  }
}