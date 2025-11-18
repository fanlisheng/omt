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

REM Use TEMP directory for log file (always writable, no permission issues)
set "LOG_DIR=%TEMP%\\OMT_Update"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\\omt_update_log.txt"

REM Initialize log file
echo [%date% %time%] OMT Update Installer Starting... > "%LOG_FILE%"
echo OMT Update Installer Starting...
echo Log file: %LOG_FILE%

REM Check admin privileges
echo [%date% %time%] Checking admin privileges... >> "%LOG_FILE%"
net session >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "IS_ADMIN=1"
    echo [%date% %time%] Running with administrator privileges >> "%LOG_FILE%"
    echo Running with admin privileges...
) else (
    set "IS_ADMIN=0"
    echo [%date% %time%] Running without administrator privileges >> "%LOG_FILE%"
    echo Running without admin privileges...
)

REM Set variables early for process checking
set "APP_NAME=\${appName}"

REM Wait for application to exit with active checking
echo [%date% %time%] Waiting for application to exit... >> "%LOG_FILE%"
echo Waiting for application to exit...

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
echo [%date% %time%] WARNING: Process did not exit gracefully, forcing termination... >> "%LOG_FILE%"
echo WARNING: Forcing application to close...
taskkill /F /IM "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 3 >nul 2>&1
echo [%date% %time%] Process forcefully terminated >> "%LOG_FILE%"
goto process_exited

:process_exited
echo [%date% %time%] Application process has exited >> "%LOG_FILE%"
echo Application closed successfully
REM Additional wait to ensure file handles are released
ping 127.0.0.1 -n 3 >nul 2>&1

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

echo Checking source: %SOURCE_DIR%
echo [%date% %time%] Checking source directory: %SOURCE_DIR% >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" (
    echo [%date% %time%] ERROR: Source directory not found: %SOURCE_DIR% >> "%LOG_FILE%"
    echo ERROR: Source not found
    echo Check log file: %LOG_FILE%
    pause
    exit /b 1
)
echo [%date% %time%] Source directory exists >> "%LOG_FILE%"

echo Preparing target: %TARGET_DIR%
echo [%date% %time%] Preparing target directory: %TARGET_DIR% >> "%LOG_FILE%"
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    if %ERRORLEVEL% NEQ 0 (
        echo [%date% %time%] ERROR: Failed to create target directory >> "%LOG_FILE%"
        echo ERROR: Cannot create target directory
        echo Check log file: %LOG_FILE%
        pause
        exit /b 1
    )
    echo [%date% %time%] Target directory created >> "%LOG_FILE%"
) else (
    echo [%date% %time%] Target directory already exists >> "%LOG_FILE%"
)

echo Copying files...
echo [%date% %time%] Starting file copy operation... >> "%LOG_FILE%"
REM Use xcopy for Win7 compatibility, robocopy for Win8+
if "%WIN7%"=="1" (
    echo [%date% %time%] Using xcopy for Windows 7 compatibility >> "%LOG_FILE%"
    xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R /H >nul 2>&1
    set "COPY_RESULT=!ERRORLEVEL!"
    echo [%date% %time%] xcopy completed with exit code: !COPY_RESULT! >> "%LOG_FILE%"
    if !COPY_RESULT! GEQ 4 (
        echo [%date% %time%] ERROR: xcopy failed with code !COPY_RESULT! >> "%LOG_FILE%"
        echo ERROR: Copy failed with xcopy
        echo Check log file: %LOG_FILE%
        pause
        exit /b 1
    )
) else (
    echo [%date% %time%] Using robocopy for Windows 8+ >> "%LOG_FILE%"
    robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:1 /W:1 >nul 2>&1
    set "COPY_RESULT=!ERRORLEVEL!"
    echo [%date% %time%] robocopy completed with exit code: !COPY_RESULT! >> "%LOG_FILE%"
    if !COPY_RESULT! GTR 7 (
        echo [%date% %time%] ERROR: robocopy failed with code !COPY_RESULT! >> "%LOG_FILE%"
        echo ERROR: Copy failed with robocopy
        echo Check log file: %LOG_FILE%
        pause
        exit /b 1
    )
)
echo [%date% %time%] File copy operation completed successfully >> "%LOG_FILE%"

echo Cleaning up...
echo [%date% %time%] Starting cleanup... >> "%LOG_FILE%"
if exist "%ZIP_PATH%" (
    del "%ZIP_PATH%" >nul 2>&1
    echo [%date% %time%] Deleted zip file: %ZIP_PATH% >> "%LOG_FILE%"
) else (
    echo [%date% %time%] Zip file not found for cleanup: %ZIP_PATH% >> "%LOG_FILE%"
)

echo Starting application...
echo [%date% %time%] Changing to target directory: %TARGET_DIR% >> "%LOG_FILE%"
cd /d "%TARGET_DIR%"

REM Verify executable exists
if not exist "%APP_PATH%" (
    echo [%date% %time%] ERROR: Executable not found: %APP_PATH% >> "%LOG_FILE%"
    echo ERROR: Application executable not found
    echo Check log file: %LOG_FILE%
    pause
    exit /b 1
)

echo [%date% %time%] Starting application with multiple methods... >> "%LOG_FILE%"

REM Method 1: Standard start command with relative path
echo [%date% %time%] Trying Method 1: start with relative path >> "%LOG_FILE%"
start "" "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] SUCCESS: Application started with Method 1 >> "%LOG_FILE%"
    echo Application started successfully!
    goto launch_success
)

REM Method 2: Start command with full path
echo [%date% %time%] Trying Method 2: start with full path >> "%LOG_FILE%"
start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] SUCCESS: Application started with Method 2 >> "%LOG_FILE%"
    echo Application started successfully!
    goto launch_success
)

REM Method 3: CMD start as fallback
echo [%date% %time%] Trying Method 3: cmd /c start >> "%LOG_FILE%"
cmd /c start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 6 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] SUCCESS: Application started with Method 3 >> "%LOG_FILE%"
    echo Application started successfully!
    goto launch_success
)

REM All methods failed
echo [%date% %time%] ERROR: All launch methods failed >> "%LOG_FILE%"
echo ERROR: Failed to start application with all methods
echo Please check:
echo 1. Application permissions
echo 2. Antivirus software blocking
echo 3. Windows Defender SmartScreen
echo 4. User Account Control settings
echo Check detailed log: %LOG_FILE%
pause
exit /b 1

:launch_success
echo [%date% %time%] Final verification... >> "%LOG_FILE%"
ping 127.0.0.1 -n 3 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] CONFIRMED: Application is running >> "%LOG_FILE%"
    echo [%date% %time%] Update process completed successfully >> "%LOG_FILE%"
    echo Update completed successfully!
    echo Log file: %LOG_FILE%
) else (
    echo [%date% %time%] WARNING: Application may have closed immediately >> "%LOG_FILE%"
    echo Update completed, but application status uncertain
    echo Check log file: %LOG_FILE%
)

exit /b 0
''';
  }
}