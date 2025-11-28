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
    
     // 使用简化的脚本模板，使用安全的占位符格式
    return _getSimplifiedScriptTemplate()
        .replaceAll('__APPNAME__', appName)
        .replaceAll('__SOURCEDIR__', extractedPathWin)
        .replaceAll('__TARGETDIR__', targetDirWin)
        .replaceAll('__ZIPPATH__', downloadPathWin);
  }

  /// 获取兼容Windows 7+的脚本模板（带日志和增强兼容性）
  /// 注意：使用纯ASCII避免编码问题
  static String _getSimplifiedScriptTemplate() {
    return '''@echo off
setlocal enabledelayedexpansion

title OMT Update Installer

set LOG_DIR=%TEMP%\\OMT_Update
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set LOG_FILE=%LOG_DIR%\\omt_update_log.txt

echo [%date% %time%] OMT Update started > "%LOG_FILE%"
echo OMT Update Installer starting...
echo Log file: %LOG_FILE%

echo [%date% %time%] Checking admin privileges >> "%LOG_FILE%"
net session >nul 2>&1
if %ERRORLEVEL% EQU 0 goto admin_ok
echo [%date% %time%] Running as normal user >> "%LOG_FILE%"
echo Running as normal user...
goto set_vars

:admin_ok
echo [%date% %time%] Running as admin >> "%LOG_FILE%"
echo Running as administrator...

:set_vars
set APP_NAME=__APPNAME__
set SOURCE_DIR=__SOURCEDIR__
set TARGET_DIR=__TARGETDIR__
set ZIP_PATH=__ZIPPATH__

echo [%date% %time%] APP_NAME=%APP_NAME% >> "%LOG_FILE%"
echo [%date% %time%] SOURCE_DIR=%SOURCE_DIR% >> "%LOG_FILE%"
echo [%date% %time%] TARGET_DIR=%TARGET_DIR% >> "%LOG_FILE%"

echo [%date% %time%] Waiting 5 seconds for app to exit >> "%LOG_FILE%"
echo Waiting for application to exit...
ping 127.0.0.1 -n 6 >nul 2>&1

echo [%date% %time%] Checking process status >> "%LOG_FILE%"

set WAIT_COUNT=0

:wait_loop
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% NEQ 0 goto process_exited

set /a WAIT_COUNT=WAIT_COUNT+1
echo [%date% %time%] Process running, attempt %WAIT_COUNT% >> "%LOG_FILE%"
if %WAIT_COUNT% GEQ 30 goto force_kill

ping 127.0.0.1 -n 2 >nul 2>&1
goto wait_loop

:force_kill
echo [%date% %time%] Force killing process >> "%LOG_FILE%"
echo Warning: Force closing application...
taskkill /F /IM "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 3 >nul 2>&1
echo [%date% %time%] Process force killed >> "%LOG_FILE%"
goto process_exited

:process_exited
echo [%date% %time%] Application process exited >> "%LOG_FILE%"
echo Application closed

echo [%date% %time%] Waiting for file handles >> "%LOG_FILE%"
echo Waiting for file handles to release...
ping 127.0.0.1 -n 6 >nul 2>&1

echo [%date% %time%] Detecting Windows version >> "%LOG_FILE%"
set WIN7=0
ver | find "6.1" >nul 2>&1
if %ERRORLEVEL% EQU 0 set WIN7=1
echo [%date% %time%] WIN7=%WIN7% >> "%LOG_FILE%"

set APP_PATH=%TARGET_DIR%\\%APP_NAME%

echo Checking source: %SOURCE_DIR%
echo [%date% %time%] Checking source: %SOURCE_DIR% >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" goto source_not_exist
echo [%date% %time%] Source exists >> "%LOG_FILE%"
goto source_ok

:source_not_exist
echo [%date% %time%] ERROR: Source not found: %SOURCE_DIR% >> "%LOG_FILE%"
echo ERROR: Source directory not found
exit /b 1

:source_ok
echo Preparing target: %TARGET_DIR%
echo [%date% %time%] Preparing target: %TARGET_DIR% >> "%LOG_FILE%"
if exist "%TARGET_DIR%" goto target_exists
mkdir "%TARGET_DIR%" >nul 2>&1
if %ERRORLEVEL% NEQ 0 goto target_create_failed
echo [%date% %time%] Target created >> "%LOG_FILE%"
goto target_ready

:target_create_failed
echo [%date% %time%] ERROR: Cannot create target >> "%LOG_FILE%"
echo ERROR: Cannot create target directory
exit /b 1

:target_exists
echo [%date% %time%] Target exists >> "%LOG_FILE%"

:target_ready
echo [%date% %time%] Final process check >> "%LOG_FILE%"
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 ping 127.0.0.1 -n 6 >nul 2>&1

echo Copying files...
echo [%date% %time%] Starting file copy >> "%LOG_FILE%"

if "%WIN7%"=="1" goto use_xcopy
goto use_robocopy

:use_xcopy
echo [%date% %time%] Using xcopy >> "%LOG_FILE%"
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R /H >nul 2>&1
set COPY_RESULT=%ERRORLEVEL%
echo [%date% %time%] xcopy result: %COPY_RESULT% >> "%LOG_FILE%"
if %COPY_RESULT% GEQ 4 goto copy_failed
goto copy_success

:use_robocopy
echo [%date% %time%] Using robocopy >> "%LOG_FILE%"
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:3 /W:2 >> "%LOG_FILE%" 2>&1
set COPY_RESULT=%ERRORLEVEL%
echo [%date% %time%] robocopy result: %COPY_RESULT% >> "%LOG_FILE%"
if %COPY_RESULT% GTR 7 goto copy_failed
goto copy_success

:copy_failed
echo [%date% %time%] ERROR: Copy failed >> "%LOG_FILE%"
echo ERROR: File copy failed
exit /b 1

:copy_success
echo [%date% %time%] Copy completed >> "%LOG_FILE%"

echo Cleaning temp files...
echo [%date% %time%] Cleaning up >> "%LOG_FILE%"
if exist "%ZIP_PATH%" del "%ZIP_PATH%" >nul 2>&1

echo Starting application...
echo [%date% %time%] Changing to target: %TARGET_DIR% >> "%LOG_FILE%"
cd /d "%TARGET_DIR%"

if not exist "%APP_PATH%" goto exe_not_found
goto start_app

:exe_not_found
echo [%date% %time%] ERROR: Executable not found: %APP_PATH% >> "%LOG_FILE%"
echo ERROR: Application executable not found
exit /b 1

:start_app
echo [%date% %time%] Starting application >> "%LOG_FILE%"

echo [%date% %time%] Method 1: relative path >> "%LOG_FILE%"
start "" "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 goto launch_success

echo [%date% %time%] Method 2: full path >> "%LOG_FILE%"
start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 5 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 goto launch_success

echo [%date% %time%] Method 3: cmd start >> "%LOG_FILE%"
cmd /c start "" "%APP_PATH%" >nul 2>&1
ping 127.0.0.1 -n 6 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 goto launch_success

echo [%date% %time%] ERROR: All launch methods failed >> "%LOG_FILE%"
echo ERROR: Failed to start application
echo Please check antivirus or Windows Defender settings
exit /b 1

:launch_success
echo [%date% %time%] Launch successful >> "%LOG_FILE%"
echo Application started successfully!
ping 127.0.0.1 -n 3 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 goto final_success
goto final_warning

:final_success
echo [%date% %time%] Application running >> "%LOG_FILE%"
echo [%date% %time%] Update completed successfully >> "%LOG_FILE%"
echo.
echo ========================================
echo       Update Completed Successfully!
echo ========================================
echo Application is running
echo Log: %LOG_FILE%
goto finish

:final_warning
echo [%date% %time%] Warning: Application may have closed >> "%LOG_FILE%"
echo.
echo ========================================
echo       Update Completed
echo ========================================
echo Note: Application status uncertain
echo Log: %LOG_FILE%

:finish
echo.
echo Window will close in 3 seconds...
timeout /t 3 /nobreak >nul 2>&1
exit /b 0
''';
  }
}