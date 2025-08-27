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
set "LOG_FILE=%TEMP%\\omt_update_log.txt"
REM ==================

echo %date% %time% - 开始安装更新 > "%LOG_FILE%"

echo [INFO] Configuration:
echo   APP_NAME: %APP_NAME%
echo   SOURCE_DIR: %SOURCE_DIR%
echo   TARGET_DIR: %TARGET_DIR%
echo   APP_PATH: %APP_PATH%
echo   LOG_FILE: %LOG_FILE%
echo.

echo %date% %time% - 配置信息已记录 >> "%LOG_FILE%"

echo [1/6] Checking source directory...
echo %date% %time% - 检查源目录: %SOURCE_DIR% >> "%LOG_FILE%"

dir "%SOURCE_DIR%" /B
if not exist "%SOURCE_DIR%" (
    echo [ERROR] Source dir not found: %SOURCE_DIR%
    echo %date% %time% - 错误：源目录未找到: %SOURCE_DIR% >> "%LOG_FILE%"
    pause
    exit /b 1
)
echo [OK] Source directory exists
echo %date% %time% - 源目录存在 >> "%LOG_FILE%"

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
echo %date% %time% - 开始复制文件: 从 %SOURCE_DIR% 到 %TARGET_DIR% >> "%LOG_FILE%"
echo Copying from %SOURCE_DIR% to %TARGET_DIR%

xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R
set "XCOPY_ERR=%ERRORLEVEL%"
echo %date% %time% - 复制文件完成，返回代码: %XCOPY_ERR% >> "%LOG_FILE%"

if %XCOPY_ERR% GEQ 4 (
    echo [ERROR] Copy failed, code: %XCOPY_ERR%
    echo %date% %time% - 错误：复制文件失败，代码: %XCOPY_ERR% >> "%LOG_FILE%"
    pause
    exit /b 1
) else (
    echo [OK] Files copied, code: %XCOPY_ERR%
    echo %date% %time% - 文件复制成功 >> "%LOG_FILE%"
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
echo %date% %time% - 尝试启动新版本: %APP_PATH% >> "%LOG_FILE%"

echo [DEBUG] Checking if app exists: %APP_PATH%
if exist "%APP_PATH%" (
    echo [INFO] Starting application: %APP_PATH%
    echo %date% %time% - 找到应用程序，正在启动: %APP_PATH% >> "%LOG_FILE%"
    
    REM 使用更可靠的启动方式
    cd /d "%TARGET_DIR%"
    echo %date% %time% - 切换到目标目录: %TARGET_DIR% >> "%LOG_FILE%"
    
    start "" "%APP_NAME%"
    set "START_ERR=%ERRORLEVEL%"
    echo %date% %time% - 启动应用程序，返回代码: %START_ERR% >> "%LOG_FILE%"
    
    if %START_ERR% EQU 0 (
        echo [OK] Started: %APP_PATH%
        echo %date% %time% - 应用程序启动成功 >> "%LOG_FILE%"
        echo Waiting for application to initialize...
        timeout /t 3 >nul
        
        REM 检查进程是否真的在运行
        tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
        if %ERRORLEVEL% EQU 0 (
            echo [OK] Application is running
            echo %date% %time% - 确认应用程序正在运行 >> "%LOG_FILE%"
        ) else (
            echo [WARN] Application process not found
            echo %date% %time% - 警告：未找到应用程序进程 >> "%LOG_FILE%"
        )
    ) else (
        echo [WARN] Application may not have started properly, code: %START_ERR%
        echo %date% %time% - 警告：应用程序可能未正确启动，代码: %START_ERR% >> "%LOG_FILE%"
    )
) else (
    echo [WARN] App not found: %APP_PATH%
    echo %date% %time% - 警告：未找到应用程序: %APP_PATH% >> "%LOG_FILE%"
    echo Available executables:
    echo %date% %time% - 查找可用的可执行文件: >> "%LOG_FILE%"
    for /f "tokens=*" %%a in ('dir "%TARGET_DIR%\\*.exe" /B 2^>nul') do (
        echo %%a
        echo %%a >> "%LOG_FILE%"
    )
    
    REM 尝试查找并启动任何可用的EXE文件
    for /f "tokens=*" %%a in ('dir "%TARGET_DIR%\\*.exe" /B 2^>nul') do (
        echo %date% %time% - 尝试启动替代应用程序: %TARGET_DIR%\\%%a >> "%LOG_FILE%"
        cd /d "%TARGET_DIR%"
        start "" "%%a"
        set "ALT_START_ERR=%ERRORLEVEL%"
        echo %date% %time% - 启动替代应用程序，返回代码: %ALT_START_ERR% >> "%LOG_FILE%"
        
        if %ALT_START_ERR% EQU 0 (
            echo Waiting for alternative application to initialize...
            timeout /t 3 >nul
            
            REM 检查替代应用程序是否在运行
            tasklist /FI "IMAGENAME eq %%a" 2>nul | find /I "%%a" >nul
            if %ERRORLEVEL% EQU 0 (
                echo [OK] Alternative application is running: %%a
                echo %date% %time% - 确认替代应用程序正在运行: %%a >> "%LOG_FILE%"
            ) else (
                echo [WARN] Alternative application process not found: %%a
                echo %date% %time% - 警告：未找到替代应用程序进程: %%a >> "%LOG_FILE%"
            )
        )
        goto :found_exe
    )
    
    echo [ERROR] No executable files found in target directory
    echo %date% %time% - 错误：目标目录中未找到可执行文件 >> "%LOG_FILE%"
    
    :found_exe
)

echo.
echo ========================================
echo           Test Update Finished!
echo ========================================
echo.
echo %date% %time% - 更新脚本执行完成 >> "%LOG_FILE%"
echo Log file location: %LOG_FILE%
echo.
echo Script will exit in 5 seconds...
echo You can check the log file for detailed information.
timeout /t 5 >nul
echo %date% %time% - 脚本正常退出 >> "%LOG_FILE%"
echo Exiting script...
''';
  }
}