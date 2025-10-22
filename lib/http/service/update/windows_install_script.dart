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
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');

    return '''
@echo off
title OMT Update Installer - Please Wait...
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
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
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
  static String generateTestScript2({
    required String extractedPath,
    required String downloadPath,
    String appName = 'omt.exe',
    String? targetDir,
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
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
echo.
echo ========================================
echo          OMT UPDATE INSTALLER
echo ========================================
echo.
echo %date% %time% - 开始安装更新
echo Script is running... Please wait...
echo.

echo [INFO] Waiting for application to exit completely...
echo %date% %time% - 等待应用程序完全退出 >> "%LOG_FILE%"
echo.
echo *** UPDATE SCRIPT IS NOW RUNNING ***
echo Please keep this window open during the update process.
echo.
echo Waiting 3 seconds for application to close...
for /l %%i in (3,-1,1) do (
    echo Countdown: %%i seconds remaining...
    timeout /t 1 >nul
)
echo [OK] Application should be closed now
echo %date% %time% - 应用程序应该已经关闭 >> "%LOG_FILE%"
echo.

echo [INFO] Configuration:
echo   APP_NAME: %APP_NAME%
echo   SOURCE_DIR: %SOURCE_DIR%
echo   TARGET_DIR: %TARGET_DIR%
echo   APP_PATH: %APP_PATH%
echo   LOG_FILE: %LOG_FILE%
echo.

echo %date% %time% - 配置信息已记录 >> "%LOG_FILE%"

title OMT Update Installer - Step 1/6: Checking Files
echo [1/6] Checking source directory...
echo %date% %time% - 检查源目录: %SOURCE_DIR% >> "%LOG_FILE%"
echo Checking source directory: %SOURCE_DIR%

dir "%SOURCE_DIR%" /B
if not exist "%SOURCE_DIR%" (
    echo [ERROR] Source dir not found: %SOURCE_DIR%
    echo %date% %time% - 错误：源目录未找到: %SOURCE_DIR% >> "%LOG_FILE%"
    call :save_error_log
    echo Press any key to exit...
    pause
    exit /b 1
)
echo [OK] Source directory exists
echo %date% %time% - 源目录存在 >> "%LOG_FILE%"

echo.
title OMT Update Installer - Step 2/6: Preparing Directory
echo [2/6] Checking target directory...
echo Checking target directory: %TARGET_DIR%
if not exist "%TARGET_DIR%" (
    echo Target dir not found, creating...
    mkdir "%TARGET_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to create target dir
        call :save_error_log
        echo Press any key to exit...
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
title OMT Update Installer - Step 3/6: Copying Files
echo [3/6] Copying files...
echo %date% %time% - 开始复制文件: 从 %SOURCE_DIR% 到 %TARGET_DIR% >> "%LOG_FILE%"
echo Copying from %SOURCE_DIR% to %TARGET_DIR%
echo This may take a few moments...

xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R
set "XCOPY_ERR=%ERRORLEVEL%"
echo %date% %time% - 复制文件完成，返回代码: %XCOPY_ERR% >> "%LOG_FILE%"
echo Copy operation completed with code: %XCOPY_ERR%

if %XCOPY_ERR% GEQ 4 (
    echo [ERROR] Copy failed, code: %XCOPY_ERR%
    echo %date% %time% - 错误：复制文件失败，代码: %XCOPY_ERR% >> "%LOG_FILE%"
    call :save_error_log
    echo Press any key to exit...
    pause
    exit /b 1
) else (
    echo [OK] Files copied successfully, code: %XCOPY_ERR%
    echo %date% %time% - 文件复制成功 >> "%LOG_FILE%"
)

echo.
title OMT Update Installer - Step 4/6: Verifying Files
echo [4/6] Verifying copied files...
echo %date% %time% - 验证复制的文件 >> "%LOG_FILE%"
echo Verifying files in target directory: %TARGET_DIR%
echo Files in target directory:
dir "%TARGET_DIR%" /B
echo %date% %time% - 目标目录文件列表完成 >> "%LOG_FILE%"
echo File verification completed

echo.
title OMT Update Installer - Step 5/6: Cleaning Up
echo [5/6] Cleaning package (optional)...
echo %date% %time% - 清理旧包 >> "%LOG_FILE%"
echo Cleaning up temporary files...
REM rmdir /s /q "%SOURCE_DIR%"
REM if exist "$downloadPathWin" del "$downloadPathWin"
echo Cleanup completed

echo.
title OMT Update Installer - Step 6/6: Starting Application
echo [6/6] Starting new version...
echo %date% %time% - 启动新版本应用程序 >> "%LOG_FILE%"
echo Attempting to start: %APP_PATH%
echo %date% %time% - 尝试启动: %APP_PATH% >> "%LOG_FILE%"
echo Changing to target directory: %TARGET_DIR%

echo [DEBUG] Checking if app exists: %APP_PATH%
if exist "%APP_PATH%" (
    echo [INFO] Starting application: %APP_PATH%
    echo %date% %time% - 找到应用程序，正在启动: %APP_PATH% >> "%LOG_FILE%"
    
    REM 使用更可靠的启动方式
    cd /d "%TARGET_DIR%"
    echo %date% %time% - 切换到目标目录: %TARGET_DIR% >> "%LOG_FILE%"
    echo Starting main application: %APP_NAME%
    
    start "" "%APP_NAME%"
    set "START_ERR=%ERRORLEVEL%"
    echo %date% %time% - 启动应用程序，返回代码: %START_ERR% >> "%LOG_FILE%"
    echo Start command returned code: %START_ERR%
    
    if %START_ERR% EQU 0 (
        echo [OK] Started: %APP_PATH%
        echo %date% %time% - 应用程序启动成功 >> "%LOG_FILE%"
        echo Waiting for application to initialize...
        timeout /t 3 >nul
        
        REM 检查进程是否真的在运行
        echo Checking if application is running...
        tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /I "%APP_NAME%" >nul
        if %ERRORLEVEL% EQU 0 (
            echo [OK] Application is running successfully
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
    
    echo [WARNING] Main app not found, looking for alternatives...
    echo %date% %time% - 警告：主应用程序未找到，寻找替代程序 >> "%LOG_FILE%"
    echo Searching for executable files in: %TARGET_DIR%
    
    REM 尝试查找并启动任何可用的EXE文件
    for /f "tokens=*" %%a in ('dir "%TARGET_DIR%\\*.exe" /B 2^>nul') do (
        echo Found alternative executable: %TARGET_DIR%\\%%a
        echo %date% %time% - 尝试启动替代应用程序: %TARGET_DIR%\\%%a >> "%LOG_FILE%"
        cd /d "%TARGET_DIR%"
        echo Starting alternative application: %%a
        start "" "%%a"
        set "ALT_START_ERR=%ERRORLEVEL%"
        echo %date% %time% - 启动替代应用程序，返回代码: %ALT_START_ERR% >> "%LOG_FILE%"
        echo Alternative start command returned code: %ALT_START_ERR%
        
        if %ALT_START_ERR% EQU 0 (
            echo [OK] Alternative started successfully
            echo %date% %time% - 替代程序启动成功 >> "%LOG_FILE%"
            echo Waiting for alternative application to initialize...
            timeout /t 3 >nul
            
            REM 检查替代应用程序是否在运行
            echo Checking if alternative application is running...
            tasklist /FI "IMAGENAME eq %%a" 2>nul | find /I "%%a" >nul
            if %ERRORLEVEL% EQU 0 (
                echo [OK] Alternative application is running: %%a
                echo %date% %time% - 确认替代应用程序正在运行: %%a >> "%LOG_FILE%"
            ) else (
                echo [WARN] Alternative application process not found: %%a
                echo %date% %time% - 警告：未找到替代应用程序进程: %%a >> "%LOG_FILE%"
            )
        ) else (
            echo [ERROR] Failed to start alternative: %%a
            echo %date% %time% - 启动替代程序失败: %%a >> "%LOG_FILE%"
        )
        goto :found_exe
    )
    
    echo [ERROR] No executable files found in target directory
    echo %date% %time% - 错误：目标目录中未找到可执行文件 >> "%LOG_FILE%"
    
    :found_exe
)

echo.
title OMT Update Installer - Completed Successfully!
echo ========================================
echo          UPDATE PROCESS COMPLETED!
echo ========================================
echo.
echo Status: Update installation finished
echo Log file: %LOG_FILE%
echo Target directory: %TARGET_DIR%
echo.
echo The script will automatically exit in 5 seconds...
echo Press any key to exit immediately.
echo ========================================
echo %date% %time% - 更新脚本完成 >> "%LOG_FILE%"
echo %date% %time% - 脚本即将退出 >> "%LOG_FILE%"

REM 处理日志文件
echo Processing log file...
if exist "%TARGET_DIR%\\%APP_NAME%" (
    echo Update completed successfully, cleaning up log file...
    echo %date% %time% - 更新成功，清理日志文件 >> "%LOG_FILE%"
    REM 成功完成，删除日志文件
    timeout /t 2 >nul
    del "%LOG_FILE%" 2>nul
    echo Log file cleaned up
) else (
    echo Update may have failed, preserving log file...
    echo %date% %time% - 更新可能失败，保存日志到程序目录 >> "%LOG_FILE%"
    REM 失败时，将日志复制到程序目录
    if exist "%TARGET_DIR%" (
        copy "%LOG_FILE%" "%TARGET_DIR%\\update_error.log" >nul 2>&1
        echo Log file saved to: %TARGET_DIR%\\update_error.log
    )
)

timeout /t 5 >nul
echo Script exiting...
goto :eof

:save_error_log
REM 保存错误日志到程序目录
echo Saving error log to program directory...
if exist "%TARGET_DIR%" (
    copy "%LOG_FILE%" "%TARGET_DIR%\\update_error.log" >nul 2>&1
    echo Error log saved to: %TARGET_DIR%\\update_error.log
) else (
    echo Cannot save error log: target directory not accessible
)
return

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
    final targetDirWin = (targetDir ?? Directory(extractedPath).parent.path)
        .replaceAll('/', '\\');
    final downloadPathWin = downloadPath.replaceAll('/', '\\');
    
    // 直接调用脚本模板文件
    return _readScriptTemplate()
        .replaceAll('\${appName}', appName)
        .replaceAll('\${sourceDir}', extractedPathWin)
        .replaceAll('\${targetDir}', targetDirWin)
        .replaceAll('\${zipPath}', downloadPathWin);
  }
  
  /// 读取脚本模板内容
  /// 返回Windows安装脚本模板字符串
  static String _readScriptTemplate() {
    // 直接使用内置模板，确保在所有环境下都能正常工作
    return _getDefaultScriptTemplate();
  }
  
  /// 获取默认的脚本模板（作为备用）
  static String _getDefaultScriptTemplate() {
    return '''
@echo off
REM ========================================
REM     OMT Update Installer (Win7+ Compatible) - Silent Mode
REM ========================================

REM Detect Windows version and set encoding (silent)
ver | find "Version 6.1" >nul 2>&1 && set "WIN7=1" || set "WIN7=0"
if "%WIN7%"=="0" (
    chcp 65001 >nul 2>&1
)

REM Disable all console output by redirecting to log file

set "APP_NAME=\${appName}"
set "SOURCE_DIR=\${sourceDir}"
set "TARGET_DIR=\${targetDir}"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
set "ZIP_PATH=\${zipPath}"
set "LOG_FILE=%~dp0omt_update_log.txt"

REM All output redirected to log file for silent operation
echo ======================================== > "%LOG_FILE%"
echo        OMT Update Installer - Silent Mode >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo LOG FILE: %LOG_FILE% >> "%LOG_FILE%"
echo ZIP PATH: %ZIP_PATH% >> "%LOG_FILE%"
echo Windows Version: Win7=%WIN7% >> "%LOG_FILE%"
echo Start update: %date% %time% >> "%LOG_FILE%"

echo ======== INITIAL PATH ANALYSIS ======== >> "%LOG_FILE%"
echo Analyzing passed SOURCE_DIR: %SOURCE_DIR% >> "%LOG_FILE%"

REM Check if SOURCE_DIR variable is empty
if "%SOURCE_DIR%"=="" (
    echo ERROR: SOURCE_DIR is empty >> "%LOG_FILE%"
    goto error_end
)

REM Check path format and accessibility
echo Testing path accessibility... >> "%LOG_FILE%"
pushd "%SOURCE_DIR%" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS: Can access SOURCE_DIR >> "%LOG_FILE%"
    echo Current directory after pushd: %CD% >> "%LOG_FILE%"
    popd
) else (
    echo FAILED: Cannot access SOURCE_DIR (Error: %ERRORLEVEL%) >> "%LOG_FILE%"
)

REM Check if it's a directory
if exist "%SOURCE_DIR%\\." (
    echo SUCCESS: SOURCE_DIR is a valid directory >> "%LOG_FILE%"
) else (
    echo FAILED: SOURCE_DIR is not a valid directory >> "%LOG_FILE%"
)

REM List directory contents
echo Directory contents: >> "%LOG_FILE%"
dir "%SOURCE_DIR%" >> "%LOG_FILE%" 2>&1

REM Check for key files
if exist "%SOURCE_DIR%\\omt.exe" (
    echo SUCCESS: Found omt.exe in SOURCE_DIR >> "%LOG_FILE%"
) else (
    echo WARNING: omt.exe not found in SOURCE_DIR >> "%LOG_FILE%"
)

REM Check path length
echo Path length analysis: >> "%LOG_FILE%"
echo SOURCE_DIR length: >> "%LOG_FILE%"
echo %SOURCE_DIR% | find /c /v "" >> "%LOG_FILE%"

echo ======== END PATH ANALYSIS ======== >> "%LOG_FILE%"
echo.

REM Find 7-Zip installation path
set "SEVENZIP_PATH="
if exist "C:\\Program Files\\7-Zip\\7z.exe" (
    set "SEVENZIP_PATH=C:\\Program Files\\7-Zip\\7z.exe"
) else if exist "C:\\Program Files (x86)\\7-Zip\\7z.exe" (
    set "SEVENZIP_PATH=C:\\Program Files (x86)\\7-Zip\\7z.exe"
) else (
    REM Try to find from PATH environment variable
    where 7z.exe >nul 2>&1
    if not errorlevel 1 (
        set "SEVENZIP_PATH=7z.exe"
    )
)

REM Step 0: Checking and extracting ZIP (silent)
echo [0/6] Checking and extracting ZIP... >> "%LOG_FILE%"
echo DEBUG: SOURCE_DIR = %SOURCE_DIR% >> "%LOG_FILE%"
echo DEBUG: ZIP_PATH = %ZIP_PATH% >> "%LOG_FILE%"
echo DEBUG: SEVENZIP_PATH = %SEVENZIP_PATH% >> "%LOG_FILE%"

if exist "%SOURCE_DIR%" goto source_exists
if not exist "%ZIP_PATH%" goto zip_missing

if "%SEVENZIP_PATH%"=="" (
    echo [ERROR] 7-Zip not found. Please install 7-Zip. >> "%LOG_FILE%"
    goto error_end
)

echo Extracting %ZIP_PATH% to %SOURCE_DIR%... >> "%LOG_FILE%"
"%SEVENZIP_PATH%" x "%ZIP_PATH%" -o"%SOURCE_DIR%" -y > "%TEMP%\\7z_output.txt" 2>&1
type "%TEMP%\\7z_output.txt" >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 goto extract_failed
echo [OK] ZIP extracted >> "%LOG_FILE%"
echo DEBUG: Checking extracted contents... >> "%LOG_FILE%"
dir "%SOURCE_DIR%" >> "%LOG_FILE%" 2>&1
echo DEBUG: Verifying source directory after extraction... >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%\\omt.exe" (
    echo DEBUG: omt.exe not found in expected location, checking subdirectories... >> "%LOG_FILE%"
    for /d %%d in ("%SOURCE_DIR%\\*") do (
        echo DEBUG: Found subdirectory: %%d >> "%LOG_FILE%"
        if exist "%%d\\omt.exe" (
            echo DEBUG: Found omt.exe in %%d, updating SOURCE_DIR... >> "%LOG_FILE%"
            set "SOURCE_DIR=%%d"
            goto extract_done
        )
    )
)
goto extract_done

:extract_failed
echo [ERROR] Extraction failed, code: %ERRORLEVEL% >> "%LOG_FILE%"
goto error_end

:zip_missing
echo [ERROR] ZIP not found: %ZIP_PATH% >> "%LOG_FILE%"
goto error_end

:source_exists
echo [OK] Source dir exists, skipping extract >> "%LOG_FILE%"
:extract_done

REM Step 1: Checking source directory (silent)
echo [1/6] Checking source directory... >> "%LOG_FILE%"
echo DEBUG: Checking if %SOURCE_DIR% exists... >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" goto source_missing
echo [OK] Source directory exists >> "%LOG_FILE%"
goto step1_done

:source_missing
echo [ERROR] Source dir not found: %SOURCE_DIR% >> "%LOG_FILE%"
echo DEBUG: Listing parent directory... >> "%LOG_FILE%"
for %%i in ("%SOURCE_DIR%") do dir "%%~dpi" >> "%LOG_FILE%" 2>&1
goto error_end

:step1_done

REM Step 2: Preparing target directory (silent)
echo [2/6] Preparing target dir... >> "%LOG_FILE%"
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
  if errorlevel 1 goto target_create_failed
  echo Target dir created >> "%LOG_FILE%"
  goto target_ready
)
echo [OK] Target directory exists >> "%LOG_FILE%"
:target_ready
echo Target ready >> "%LOG_FILE%"
goto step2_done

:target_create_failed
echo [ERROR] Failed to create target dir >> "%LOG_FILE%"
goto error_end

:step2_done

REM Step 3: Copying files (silent)
echo [3/6] Copying files from "%SOURCE_DIR%" to "%TARGET_DIR%"... >> "%LOG_FILE%"
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R > "%TEMP%\\xcopy_output.txt" 2>&1
set "XCOPY_ERR=%ERRORLEVEL%"
type "%TEMP%\\xcopy_output.txt" >> "%LOG_FILE%"
if %XCOPY_ERR% GEQ 4 goto copy_failed
echo [OK] Files copied successfully >> "%LOG_FILE%"
echo Copy complete, code: %XCOPY_ERR% >> "%LOG_FILE%"
goto step3_done

:copy_failed
echo [ERROR] Copy failed, code: %XCOPY_ERR% >> "%LOG_FILE%"
goto error_end

:step3_done

REM Step 4: Verifying files (silent)
echo [4/6] Verifying target directory... >> "%LOG_FILE%"
dir "%TARGET_DIR%" /B >> "%LOG_FILE%"
echo [OK] Verification complete >> "%LOG_FILE%"

REM Step 5: Cleaning up (silent)
echo [5/6] Cleaning temporary files... >> "%LOG_FILE%"
if exist "%ZIP_PATH%" (
  del "%ZIP_PATH%" >nul 2>&1
  echo Deleted ZIP: %ZIP_PATH% >> "%LOG_FILE%"
)
if exist "%TEMP%\\7z_output.txt" (
  del "%TEMP%\\7z_output.txt" >nul 2>&1
  echo Deleted temp file: 7z_output.txt >> "%LOG_FILE%"
)
if exist "%TEMP%\\xcopy_output.txt" (
  del "%TEMP%\\xcopy_output.txt" >nul 2>&1
  echo Deleted temp file: xcopy_output.txt >> "%LOG_FILE%"
)
echo Cleanup complete >> "%LOG_FILE%"

REM Step 6: Starting application (silent)
echo [6/6] Launching app... >> "%LOG_FILE%"
cd /d "%TARGET_DIR%"
if exist "%APP_PATH%" (
  echo [INFO] Launching: %APP_PATH% >> "%LOG_FILE%"
  start "" "%APP_PATH%"
  echo [OK] Application started >> "%LOG_FILE%"
) else (
  echo [ERROR] Executable not found: %APP_PATH% >> "%LOG_FILE%"
  goto error_end
)

echo ======================================== >> "%LOG_FILE%"
echo       UPDATE PROCESS COMPLETED! >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Update complete: %date% %time% >> "%LOG_FILE%"

REM Silent exit - no delay, no console output
exit /b 0

:error_end
echo [ERROR] Process failed. Check log: %LOG_FILE% >> "%LOG_FILE%"
REM Silent error exit - no console output
exit /b 1
''';
  }
}
