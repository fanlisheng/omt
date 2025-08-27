import 'dart:io';

/// Windows安装脚本模板
/// 用于生成自动更新安装的批处理脚本
class WindowsInstallScript {
  /// 生成Windows安装脚本内容
  /// 
  /// [extractedPath] 解压后的文件路径
  /// [downloadPath] 下载的ZIP文件路径
  /// [appName] 应用名称，默认为omt.exe
  /// [targetDir] 目标安装目录，如果为空则使用解压目录的父目录
  static String generateScript({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path).replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    return '''
@echo off
chcp 65001 >nul
echo ========================================
echo           Client Update Script
echo ========================================
echo.

REM ===== CONFIG =====
set "APP_NAME=$appName"
set "SOURCE_DIR=$extractedPathWin"
set "TARGET_DIR=$targetDirWin"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
REM ==================

echo [1/5] Killing old process: %APP_NAME% ...
taskkill /IM "%APP_NAME%" /F >nul 2>&1
timeout /t 2 >nul

echo.
echo [2/5] Checking update package...
if not exist "%SOURCE_DIR%" (
    echo [ERROR] Source dir not found: %SOURCE_DIR%
    pause
    exit /b 1
)

if not exist "%TARGET_DIR%" (
    echo Target dir not found, creating...
    mkdir "%TARGET_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to create target dir
        pause
        exit /b 1
    )
    echo Target dir created
)

echo.
echo [3/5] Copying files...
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R
set "XCOPY_ERR=%ERRORLEVEL%"

if %XCOPY_ERR% GEQ 4 (
    echo [ERROR] Copy failed, code: %XCOPY_ERR%
    pause
    exit /b 1
) else (
    echo [OK] Files copied, code: %XCOPY_ERR%
)

echo.
echo [4/5] Cleaning package (optional)...
REM rmdir /s /q "%SOURCE_DIR%"
REM if exist "$downloadPathWin" del "$downloadPathWin"

echo.
echo [5/5] Launching new version...
if exist "%APP_PATH%" (
    start "" "%APP_PATH%"
    echo [OK] Started: %APP_PATH%
) else (
    echo [WARN] App not found: %APP_PATH%
)

echo.
echo ========================================
echo           Update Finished!
echo ========================================
pause >nul
''';
  }

  /// 生成简化版本的安装脚本（不启动应用）
  static String generateSimpleScript({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path).replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    return '''
@echo off
chcp 65001 >nul
echo ========================================
echo           Simple Update Script
echo ========================================
echo.

REM ===== CONFIG =====
set "SOURCE_DIR=$extractedPathWin"
set "TARGET_DIR=$targetDirWin"
REM ==================

echo [1/3] Checking update package...
if not exist "%SOURCE_DIR%" (
    echo [ERROR] Source dir not found: %SOURCE_DIR%
    pause
    exit /b 1
)

if not exist "%TARGET_DIR%" (
    echo Target dir not found, creating...
    mkdir "%TARGET_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to create target dir
        pause
        exit /b 1
    )
    echo Target dir created
)

echo.
echo [2/3] Copying files...
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R
set "XCOPY_ERR=%ERRORLEVEL%"

if %XCOPY_ERR% GEQ 4 (
    echo [ERROR] Copy failed, code: %XCOPY_ERR%
    pause
    exit /b 1
) else (
    echo [OK] Files copied, code: %XCOPY_ERR%
)

echo.
echo [3/3] Cleaning package (optional)...
REM rmdir /s /q "%SOURCE_DIR%"
REM if exist "$downloadPathWin" del "$downloadPathWin"

echo.
echo ========================================
echo           Update Finished!
echo ========================================
pause >nul
''';
  }

  /// 生成测试版本的安装脚本（包含详细日志）
  static String generateTestScript({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path).replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    return '''
@echo off
chcp 65001 >nul
echo ========================================
echo           Test Update Script
echo ========================================
echo.

REM ===== CONFIG =====
set "APP_NAME=$appName"
set "SOURCE_DIR=$extractedPathWin"
set "TARGET_DIR=$targetDirWin"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
REM ==================

echo [INFO] Configuration:
echo   APP_NAME: %APP_NAME%
echo   SOURCE_DIR: %SOURCE_DIR%
echo   TARGET_DIR: %TARGET_DIR%
echo   APP_PATH: %APP_PATH%
echo.

echo [1/6] Checking source directory...
dir "%SOURCE_DIR%" /B
if not exist "%SOURCE_DIR%" (
    echo [ERROR] Source dir not found: %SOURCE_DIR%
    pause
    exit /b 1
)
echo [OK] Source directory exists

echo.
echo [2/6] Checking target directory...
if not exist "%TARGET_DIR%" (
    echo Target dir not found, creating...
    mkdir "%TARGET_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to create target dir
        pause
        exit /b 1
    )
    echo Target dir created
) else (
    echo [OK] Target directory exists
    echo Current content:
    dir "%TARGET_DIR%" /B
)

echo.
echo [3/6] Copying files...
echo Copying from %SOURCE_DIR% to %TARGET_DIR%
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R
set "XCOPY_ERR=%ERRORLEVEL%"

if %XCOPY_ERR% GEQ 4 (
    echo [ERROR] Copy failed, code: %XCOPY_ERR%
    pause
    exit /b 1
) else (
    echo [OK] Files copied, code: %XCOPY_ERR%
)

echo.
echo [4/6] Verifying copied files...
echo New content in target directory:
dir "%TARGET_DIR%" /B

echo.
echo [5/6] Cleaning package (optional)...
REM rmdir /s /q "%SOURCE_DIR%"
REM if exist "$downloadPathWin" del "$downloadPathWin"

echo.
echo [6/6] Launching new version...
if exist "%APP_PATH%" (
    echo [INFO] Starting application: %APP_PATH%
    start "" "%APP_PATH%"
    echo [OK] Started: %APP_PATH%
) else (
    echo [WARN] App not found: %APP_PATH%
    echo Available executables:
    dir "%TARGET_DIR%\\*.exe" /B 2>nul
)

echo.
echo ========================================
echo           Test Update Finished!
echo ========================================
echo.
echo Press any key to exit...
pause >nul
''';
  }
} 