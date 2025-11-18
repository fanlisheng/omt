import 'dart:io';

/// Windows安装脚本模板
/// 用于生成自动更新安装的批处理脚本
class WindowsInstallScript {
  
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

  /// 获取兼容Windows 7+的脚本模板（带日志和增强兼容性）
  static String _getSimplifiedScriptTemplate() {
    return '''
@echo off
setlocal enabledelayedexpansion

REM Set code page to UTF-8 for Chinese support
chcp 65001 >nul 2>&1

REM Set window title
title OMT 更新安装程序

REM Use TEMP directory for log file (always writable, no permission issues)
set "LOG_DIR=%TEMP%\\OMT_Update"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\\omt_update_log.txt"

REM Initialize log file
echo [%date% %time%] OMT 更新安装程序启动... > "%LOG_FILE%"
echo OMT 更新安装程序启动...
echo 日志文件: %LOG_FILE%

REM Check admin privileges
echo [%date% %time%] 检查管理员权限... >> "%LOG_FILE%"
net session >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "IS_ADMIN=1"
    echo [%date% %time%] 以管理员权限运行 >> "%LOG_FILE%"
    echo 以管理员权限运行...
) else (
    set "IS_ADMIN=0"
    echo [%date% %time%] 以普通用户权限运行 >> "%LOG_FILE%"
    echo 以普通用户权限运行...
)

REM Set variables early for process checking
set "APP_NAME=\${appName}"

REM Critical: Initial delay to let application exit gracefully
echo [%date% %time%] 等待5秒让应用程序退出... >> "%LOG_FILE%"
echo 等待应用程序退出...
ping 127.0.0.1 -n 6 >nul 2>&1

REM Wait for application to exit with active checking
echo [%date% %time%] 开始检查进程是否退出... >> "%LOG_FILE%"

REM Check if process is still running and wait up to 30 seconds
set "WAIT_COUNT=0"
:wait_loop
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% NEQ 0 goto process_exited

set /a WAIT_COUNT+=1
if %WAIT_COUNT% GEQ 30 goto force_kill

echo [%date% %time%] Process still running, waiting... (attempt %WAIT_COUNT%/30) >> "%LOG_FILE%"
ping 127.0.0.1 -n 2 >nul 2>&1
goto wait_loop

:force_kill
echo [%date% %time%] 警告: 进程未正常退出，强制终止... >> "%LOG_FILE%"
echo 警告: 强制关闭应用程序...
taskkill /F /IM "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 3 >nul 2>&1
echo [%date% %time%] 进程已强制终止 >> "%LOG_FILE%"
goto process_exited

:process_exited
echo [%date% %time%] 应用程序进程已退出 >> "%LOG_FILE%"
echo 应用程序已关闭

REM Critical: Wait to ensure ALL file handles are released (including DLLs)
echo [%date% %time%] 等待5秒释放文件句柄... >> "%LOG_FILE%"
echo 等待文件句柄释放...
ping 127.0.0.1 -n 6 >nul 2>&1

REM Detect Windows version and set compatibility
echo [%date% %time%] Detecting Windows version... >> "%LOG_FILE%"
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%"=="6.1" (
    set "WIN7=1"
    echo [%date% %time%] Windows 7 detected >> "%LOG_FILE%"
) else (
    set "WIN7=0"
    echo [%date% %time%] Windows 8+ detected >> "%LOG_FILE%"
)

REM Set path variables
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "ZIP_PATH=\${zipPath}"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"

echo [%date% %time%] Variables set: >> "%LOG_FILE%"
echo [%date% %time%] APP_NAME=%APP_NAME% >> "%LOG_FILE%"
echo [%date% %time%] SOURCE_DIR=%SOURCE_DIR% >> "%LOG_FILE%"
echo [%date% %time%] TARGET_DIR=%TARGET_DIR% >> "%LOG_FILE%"
echo [%date% %time%] APP_PATH=%APP_PATH% >> "%LOG_FILE%"

echo 检查源目录: %SOURCE_DIR%
echo [%date% %time%] 检查源目录: %SOURCE_DIR% >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" (
    echo [%date% %time%] 错误: 源目录不存在: %SOURCE_DIR% >> "%LOG_FILE%"
    echo 错误: 源目录不存在 >> "%LOG_FILE%"
    exit /b 1
)
echo [%date% %time%] 源目录存在 >> "%LOG_FILE%"

echo 准备目标目录: %TARGET_DIR%
echo [%date% %time%] 准备目标目录: %TARGET_DIR% >> "%LOG_FILE%"
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    if %ERRORLEVEL% NEQ 0 (
        echo [%date% %time%] 错误: 无法创建目标目录 >> "%LOG_FILE%"
        echo 错误: 无法创建目标目录 >> "%LOG_FILE%"
        exit /b 1
    )
    echo [%date% %time%] 目标目录已创建 >> "%LOG_FILE%"
) else (
    echo [%date% %time%] 目标目录已存在 >> "%LOG_FILE%"
)

REM Double-check process is really gone before copying
echo [%date% %time%] Final process check before copying... >> "%LOG_FILE%"
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] WARNING: Process still detected, waiting additional 5 seconds... >> "%LOG_FILE%"
    ping 127.0.0.1 -n 6 >nul 2>&1
)

echo 正在复制文件...
echo [%date% %time%] 开始文件复制操作... >> "%LOG_FILE%"
REM Use xcopy for Win7 compatibility, robocopy for Win8+
if "%WIN7%"=="1" (
    echo [%date% %time%] Using xcopy for Windows 7 compatibility >> "%LOG_FILE%"
    xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R /H >nul 2>&1
    set "COPY_RESULT=!ERRORLEVEL!"
    echo [%date% %time%] xcopy completed with exit code: !COPY_RESULT! >> "%LOG_FILE%"
    if !COPY_RESULT! GEQ 4 (
        echo [%date% %time%] ERROR: xcopy failed with code !COPY_RESULT! >> "%LOG_FILE%"
        echo ERROR: Copy failed with xcopy >> "%LOG_FILE%"
        exit /b 1
    )
) else (
    echo [%date% %time%] Using robocopy for Windows 8+ >> "%LOG_FILE%"
    robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:3 /W:2 >> "%LOG_FILE%" 2>&1
    set "COPY_RESULT=!ERRORLEVEL!"
    echo [%date% %time%] robocopy completed with exit code: !COPY_RESULT! >> "%LOG_FILE%"
    if !COPY_RESULT! GTR 7 (
        echo [%date% %time%] ERROR: robocopy failed with code !COPY_RESULT! >> "%LOG_FILE%"
        echo ERROR: Copy failed, check log file >> "%LOG_FILE%"
        exit /b 1
    )
)
echo [%date% %time%] File copy operation completed successfully >> "%LOG_FILE%"

echo 清理临时文件...
echo [%date% %time%] 开始清理... >> "%LOG_FILE%"
if exist "%ZIP_PATH%" (
    del "%ZIP_PATH%" >nul 2>&1
    echo [%date% %time%] Deleted zip file: %ZIP_PATH% >> "%LOG_FILE%"
) else (
    echo [%date% %time%] Zip file not found for cleanup: %ZIP_PATH% >> "%LOG_FILE%"
)

echo 启动应用程序...
echo [%date% %time%] 切换到目标目录: %TARGET_DIR% >> "%LOG_FILE%"
cd /d "%TARGET_DIR%"

REM Verify executable exists
if not exist "%APP_PATH%" (
    echo [%date% %time%] ERROR: Executable not found: %APP_PATH% >> "%LOG_FILE%"
    echo ERROR: Application executable not found >> "%LOG_FILE%"
    exit /b 1
)

echo [%date% %time%] Starting application with multiple methods... >> "%LOG_FILE%"

REM Method 1: Standard start command with relative path
echo [%date% %time%] 尝试方法1: 相对路径启动 >> "%LOG_FILE%"
start "" "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] 成功: 方法1启动成功 >> "%LOG_FILE%"
    echo 应用程序启动成功！
    goto launch_success
)

REM Method 2: Start command with full path
echo [%date% %time%] 尝试方法2: 完整路径启动 >> "%LOG_FILE%"
start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] 成功: 方法2启动成功 >> "%LOG_FILE%"
    echo 应用程序启动成功！
    goto launch_success
)

REM Method 3: CMD start as fallback
echo [%date% %time%] 尝试方法3: CMD启动 >> "%LOG_FILE%"
cmd /c start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 6 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] 成功: 方法3启动成功 >> "%LOG_FILE%"
    echo 应用程序启动成功！
    goto launch_success
)

REM All methods failed
echo [%date% %time%] ERROR: All launch methods failed >> "%LOG_FILE%"
echo [%date% %time%] Please check: >> "%LOG_FILE%"
echo [%date% %time%] 1. Application permissions >> "%LOG_FILE%"
echo [%date% %time%] 2. Antivirus software blocking >> "%LOG_FILE%"
echo [%date% %time%] 3. Windows Defender SmartScreen >> "%LOG_FILE%"
echo [%date% %time%] 4. User Account Control settings >> "%LOG_FILE%"
exit /b 1

:launch_success
echo [%date% %time%] 最终验证... >> "%LOG_FILE%"
ping 127.0.0.1 -n 3 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] 确认: 应用程序正在运行 >> "%LOG_FILE%"
    echo [%date% %time%] 更新过程成功完成 >> "%LOG_FILE%"
    echo.
    echo ========================================
    echo       更新成功完成！
    echo ========================================
    echo 应用程序正在运行
    echo 日志: %LOG_FILE%
) else (
    echo [%date% %time%] 警告: 应用程序可能立即关闭 >> "%LOG_FILE%"
    echo.
    echo ========================================
    echo       更新完成
    echo ========================================
    echo 注意: 应用程序状态不确定
    echo 日志: %LOG_FILE%
)

echo.
echo 此窗口将在3秒后自动关闭...
timeout /t 3 /nobreak >nul 2>&1
exit /b 0
''';
  }
}