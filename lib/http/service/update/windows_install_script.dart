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

  /// 获取兼容Windows 7+的脚本模板（带日志）
  static String _getSimplifiedScriptTemplate() {
    return '''
@echo off
setlocal enabledelayedexpansion

REM Set log file path
set "LOG_DIR=%TEMP%\\OMT_Update"
set "LOG_FILE=%LOG_DIR%\\update_log.txt"

REM Create log directory
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

REM Initialize log file
echo [%date% %time%] OMT Update Installer Starting... > "%LOG_FILE%"
echo OMT Update Installer Starting...

REM Wait for application to exit (compatible with Win7+)
echo [%date% %time%] Waiting for application to exit... >> "%LOG_FILE%"
ping 127.0.0.1 -n 4 >nul 2>&1

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

REM Set variables
set "APP_NAME=\${appName}"
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "ZIP_PATH=\${zipPath}"

echo [%date% %time%] Variables set: APP_NAME=%APP_NAME%, SOURCE_DIR=%SOURCE_DIR%, TARGET_DIR=%TARGET_DIR% >> "%LOG_FILE%"

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
echo [%date% %time%] Starting application: %APP_NAME% >> "%LOG_FILE%"
start "" "%APP_NAME%"

echo [%date% %time%] Update process completed successfully >> "%LOG_FILE%"
echo Update completed!
echo Log file saved to: %LOG_FILE%
exit /b 0
''';
  }

  /// 获取默认的脚本模板（作为备用）
  static String _getDefaultScriptTemplate() {
    return '''
@echo off
REM ========================================
REM     OMT Update Installer (Win7+ Compatible) - Silent Mode
REM ========================================

REM CRITICAL: Wait for application to completely exit before starting update
echo (SCRIPT) Waiting for application to exit completely...
echo (SCRIPT) Please wait 3 seconds...

REM Use more compatible waiting method
ping 127.0.0.1 -n 4 >nul 2>&1

echo (SCRIPT) Application should be closed now, continuing...
echo (SCRIPT) Starting update process...

REM Detect Windows version and set encoding (silent)
set "WIN7=0"
ver | find "Version 6.1" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "WIN7=1"
) else (
    set "WIN7=0"
)
if "%WIN7%"=="0" (
    chcp 65001 >nul 2>&1
)
echo (SCRIPT) Windows version detection completed, WIN7=%WIN7%

set "APP_NAME=\${appName}"
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
set "ZIP_PATH=\${zipPath}"

echo (SCRIPT) Variables set:
echo (SCRIPT) APP_NAME=%APP_NAME%
echo (SCRIPT) SOURCE_DIR=%SOURCE_DIR%
echo (SCRIPT) TARGET_DIR=%TARGET_DIR%

REM Get script directory more reliably
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR%"=="" (
    REM Fallback: use current directory
    set "SCRIPT_DIR=%CD%"
)
REM Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "LOG_FILE=%SCRIPT_DIR%\\omt_update_log.txt"

REM All output redirected to log file for silent operation
REM First, test if we can create the log file
echo Testing log file creation... > "%LOG_FILE%" 2>&1
if %ERRORLEVEL% NEQ 0 (
    REM If log file creation fails, try using TEMP directory
    set "LOG_FILE=%TEMP%\\omt_update_log.txt"
    echo Testing TEMP log file creation... > "%LOG_FILE%" 2>&1
)

echo ======================================== > "%LOG_FILE%"
echo        OMT Update Installer - Silent Mode >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Start update: %date% %time% >> "%LOG_FILE%"

REM Step 1: Checking source directory (silent)
echo (SCRIPT) (1/6) Checking source directory...
echo (1/6) Checking source directory... >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" goto source_missing
echo (SCRIPT) (OK) Source directory exists
echo (OK) Source directory exists >> "%LOG_FILE%"
goto step1_done

:source_missing
echo (SCRIPT) (ERROR) Source dir not found: %SOURCE_DIR%
echo (ERROR) Source dir not found: %SOURCE_DIR% >> "%LOG_FILE%"
goto error_end

:step1_done

REM Step 2: Preparing target directory (silent)
echo (SCRIPT) (2/6) Preparing target directory...
echo (2/6) Preparing target dir... >> "%LOG_FILE%"
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
  if errorlevel 1 goto target_create_failed
  echo (SCRIPT) Target directory created
  echo Target dir created >> "%LOG_FILE%"
  goto target_ready
)
echo (SCRIPT) (OK) Target directory exists
echo (OK) Target directory exists >> "%LOG_FILE%"
:target_ready
goto step2_done

:target_create_failed
echo (ERROR) Failed to create target dir >> "%LOG_FILE%"
goto error_end

:step2_done
echo (SCRIPT) Step 2 completed, proceeding to step 3...
echo Step 2 completed, proceeding to step 3... >> "%LOG_FILE%"

REM Step 3: Copying files (silent)
echo (SCRIPT) (3/6) Copying files...
echo (3/6) Copying files from "%SOURCE_DIR%" to "%TARGET_DIR%"... >> "%LOG_FILE%"
echo (DEBUG) About to execute xcopy command... >> "%LOG_FILE%"
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R > "%TEMP%\\xcopy_output.txt" 2>&1
set "XCOPY_ERR=%ERRORLEVEL%"
type "%TEMP%\\xcopy_output.txt" >> "%LOG_FILE%"
if %XCOPY_ERR% GEQ 4 goto copy_failed
echo (SCRIPT) (OK) Files copied successfully
echo (OK) Files copied successfully >> "%LOG_FILE%"
goto step3_done

:copy_failed
echo (SCRIPT) (ERROR) Copy failed, code: %XCOPY_ERR%
echo (ERROR) Copy failed, code: %XCOPY_ERR% >> "%LOG_FILE%"
goto error_end

:step3_done

REM Step 4: Verifying files (silent)
echo (SCRIPT) (4/6) Verifying files...
echo (4/6) Verifying target directory... >> "%LOG_FILE%"
dir "%TARGET_DIR%" /B >> "%LOG_FILE%"
echo (SCRIPT) (OK) Verification complete
echo (OK) Verification complete >> "%LOG_FILE%"

REM Step 5: Cleaning up (silent)
echo (SCRIPT) (5/6) Cleaning up...
echo (5/6) Cleaning temporary files... >> "%LOG_FILE%"
if exist "%ZIP_PATH%" (
  del "%ZIP_PATH%" >nul 2>&1
  echo Deleted ZIP: %ZIP_PATH% >> "%LOG_FILE%"
)
if exist "%TEMP%\\xcopy_output.txt" (
  del "%TEMP%\\xcopy_output.txt" >nul 2>&1
  echo Deleted temp file: xcopy_output.txt >> "%LOG_FILE%"
)

REM Step 6: Starting application (silent)
echo (SCRIPT) (6/6) Launching application...
echo (6/6) Launching app... >> "%LOG_FILE%"

cd /d "%TARGET_DIR%"

if exist "%APP_PATH%" (
  echo (SCRIPT) Found executable: %APP_PATH%
  echo (INFO) Found executable: %APP_PATH% >> "%LOG_FILE%"
  
  echo (SCRIPT) Attempting to launch application...
  echo (INFO) Attempting to launch: %APP_PATH% >> "%LOG_FILE%"
  
  REM Try multiple launch methods for better reliability
  start "" "%APP_PATH%" >> "%LOG_FILE%" 2>&1
  
  REM Wait a moment and check if process started
  ping 127.0.0.1 -n 3 >nul 2>&1
  tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
  if %ERRORLEVEL% EQU 0 (
    echo (SCRIPT) (SUCCESS) Application started with method 1
    echo (OK) Application is running >> "%LOG_FILE%"
    goto launch_success
  )
  
  echo (SCRIPT) Trying method 2...
  start "" "%APP_NAME%" >> "%LOG_FILE%" 2>&1
  
  REM Wait a moment and check if process started
  ping 127.0.0.1 -n 3 >nul 2>&1
  tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
  if %ERRORLEVEL% EQU 0 (
    echo (SCRIPT) (SUCCESS) Application started with method 2
    echo (OK) Application is running >> "%LOG_FILE%"
    goto launch_success
  )
  
  echo (SCRIPT) Trying method 3...
  "%APP_PATH%" >> "%LOG_FILE%" 2>&1 &
  
  REM Wait a moment and check if process started
  ping 127.0.0.1 -n 4 >nul 2>&1
  tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
  if %ERRORLEVEL% EQU 0 (
    echo (SCRIPT) (SUCCESS) Application started with method 3
    echo (OK) Application is running >> "%LOG_FILE%"
    goto launch_success
  )
  
  echo (SCRIPT) (WARNING) All launch methods failed
  echo (WARNING) All launch methods failed >> "%LOG_FILE%"
  
  :launch_success
  echo (SCRIPT) Application launch completed
  echo (OK) Application launch completed >> "%LOG_FILE%"
) else (
  echo (SCRIPT) (ERROR) Executable not found: %APP_PATH%
  echo (ERROR) Executable not found: %APP_PATH% >> "%LOG_FILE%"
  goto error_end
)

echo (SCRIPT) ========================================
echo (SCRIPT)       UPDATE PROCESS COMPLETED!
echo (SCRIPT) ========================================
echo ======================================== >> "%LOG_FILE%"
echo       UPDATE PROCESS COMPLETED! >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Update complete: %date% %time% >> "%LOG_FILE%"

REM Final verification that application is running
echo (SCRIPT) Final verification...
ping 127.0.0.1 -n 4 >nul 2>&1
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
if %ERRORLEVEL% EQU 0 (
  echo (SCRIPT) (SUCCESS) Application is confirmed running!
  echo (SUCCESS) Application is confirmed running >> "%LOG_FILE%"
) else (
  echo (SCRIPT) (WARNING) Application process not detected in final check
  echo (WARNING) Application process not detected in final check >> "%LOG_FILE%"
)

echo (SCRIPT) Script completed. Check log file for details.
echo Script exit: %date% %time% >> "%LOG_FILE%"
REM Silent exit - no delay, no console output
exit /b 0

:error_end
echo (ERROR) Process failed. Check log: %LOG_FILE% >> "%LOG_FILE%"
REM Silent error exit - no console output
exit /b 1
''';
  }
}