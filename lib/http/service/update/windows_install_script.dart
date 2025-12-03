/// Windows安装脚本模板
/// 用于生成自动更新安装的批处理脚本
/// 直接覆盖应用目录中的文件，然后从原位置启动应用
class WindowsInstallScript {
  
  /// 生成安装脚本（覆盖式更新）
  /// [extractedPath] - 解压后的更新文件目录
  /// [appDir] - 应用程序所在目录（将覆盖此目录中的文件）
  /// [appName] - 应用程序名称（用于等待进程退出和启动）
  static String generateInstallScript({
    required String extractedPath,
    required String appDir,
    String appName = 'omt.exe',
  }) {
    final extractedPathWin = extractedPath.replaceAll('/', '\\');
    final appDirWin = appDir.replaceAll('/', '\\');
    
    return _getOverwriteScriptTemplate()
        .replaceAll('__APPNAME__', appName)
        .replaceAll('__EXTRACTED_PATH__', extractedPathWin)
        .replaceAll('__APP_DIR__', appDirWin);
  }

  /// 生成安装程序脚本（运行 exe 安装程序，静默模式）
  /// [installerPath] - exe 安装程序路径
  /// [appDir] - 应用程序所在目录（安装目标目录）
  /// [appName] - 应用程序名称（用于等待进程退出）
  static String generateInstallerScript({
    required String installerPath,
    required String appDir,
    String appName = 'omt.exe',
  }) {
    final installerPathWin = installerPath.replaceAll('/', '\\');
    final appDirWin = appDir.replaceAll('/', '\\');
    
    return _getInstallerScriptTemplate()
        .replaceAll('__APPNAME__', appName)
        .replaceAll('__INSTALLER_PATH__', installerPathWin)
        .replaceAll('__APP_DIR__', appDirWin);
  }

  /// 获取覆盖式更新脚本模板
  /// 将解压目录中的文件覆盖到应用目录，然后启动应用
  static String _getOverwriteScriptTemplate() {
    return '''@echo off
setlocal enabledelayedexpansion

title OMT Update

set LOG_DIR=%TEMP%\\OMT_Update
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set LOG_FILE=%LOG_DIR%\\omt_update_log.txt

echo [%date% %time%] OMT Update started > "%LOG_FILE%"
echo OMT Update starting...

set APP_NAME=__APPNAME__
set EXTRACTED_PATH=__EXTRACTED_PATH__
set APP_DIR=__APP_DIR__

echo [%date% %time%] APP_NAME=%APP_NAME% >> "%LOG_FILE%"
echo [%date% %time%] EXTRACTED_PATH=%EXTRACTED_PATH% >> "%LOG_FILE%"
echo [%date% %time%] APP_DIR=%APP_DIR% >> "%LOG_FILE%"

:: Check if extracted path exists
if not exist "%EXTRACTED_PATH%" goto source_not_found

:: Check if app dir exists
if not exist "%APP_DIR%" goto app_dir_not_found

:: Wait for app to exit
echo Waiting for application to exit...
echo [%date% %time%] Waiting for app to exit >> "%LOG_FILE%"

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
taskkill /F /IM "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 2 >nul 2>&1
goto process_exited

:process_exited
echo [%date% %time%] Application exited >> "%LOG_FILE%"
echo Application closed

:: Wait a moment for file handles to release
ping 127.0.0.1 -n 3 >nul 2>&1

:: Copy files from extracted path to app directory (overwrite)
echo Copying update files...
echo [%date% %time%] Copying files from %EXTRACTED_PATH% to %APP_DIR% >> "%LOG_FILE%"

:: Use xcopy to overwrite all files
xcopy "%EXTRACTED_PATH%\\*" "%APP_DIR%\\" /E /Y /I /Q >>"%LOG_FILE%" 2>&1
set COPY_RESULT=%ERRORLEVEL%
echo [%date% %time%] Copy result: %COPY_RESULT% >> "%LOG_FILE%"

if %COPY_RESULT% NEQ 0 goto copy_failed

echo [%date% %time%] Files copied successfully >> "%LOG_FILE%"
echo Files updated!

:: Wait a moment before starting app
ping 127.0.0.1 -n 2 >nul 2>&1

:: Start the application from original location
echo Starting application...
echo [%date% %time%] Starting application: %APP_DIR%\\%APP_NAME% >> "%LOG_FILE%"

start "" "%APP_DIR%\\%APP_NAME%"
set START_RESULT=%ERRORLEVEL%
echo [%date% %time%] Application started, result: %START_RESULT% >> "%LOG_FILE%"

echo [%date% %time%] Update completed successfully >> "%LOG_FILE%"
echo Update completed!
goto finish

:source_not_found
echo [%date% %time%] ERROR: Extracted path not found: %EXTRACTED_PATH% >> "%LOG_FILE%"
echo ERROR: Update files not found
exit /b 1

:app_dir_not_found
echo [%date% %time%] ERROR: App directory not found: %APP_DIR% >> "%LOG_FILE%"
echo ERROR: Application directory not found
exit /b 1

:copy_failed
echo [%date% %time%] ERROR: Copy failed >> "%LOG_FILE%"
echo ERROR: Failed to copy update files
exit /b 1

:finish
echo.
timeout /t 2 /nobreak >nul 2>&1
exit /b 0
''';
  }

  /// 安装程序脚本模板（运行 exe 安装程序到指定目录）
  static String _getInstallerScriptTemplate() {
    return '''@echo off
setlocal enabledelayedexpansion

title OMT Update

set LOG_DIR=%TEMP%\\OMT_Update
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set LOG_FILE=%LOG_DIR%\\omt_update_log.txt

echo [%date% %time%] OMT Update started > "%LOG_FILE%"
echo OMT Update starting...

set APP_NAME=__APPNAME__
set INSTALLER_PATH=__INSTALLER_PATH__
set APP_DIR=__APP_DIR__

echo [%date% %time%] APP_NAME=%APP_NAME% >> "%LOG_FILE%"
echo [%date% %time%] INSTALLER_PATH=%INSTALLER_PATH% >> "%LOG_FILE%"
echo [%date% %time%] APP_DIR=%APP_DIR% >> "%LOG_FILE%"

:: 显示当前目录
echo [%date% %time%] Current directory: %CD% >> "%LOG_FILE%"

:: Check if installer exists
echo [%date% %time%] Checking if installer exists... >> "%LOG_FILE%"
if not exist "%INSTALLER_PATH%" (
    echo [%date% %time%] ERROR: Installer file not found! >> "%LOG_FILE%"
    dir "%INSTALLER_PATH%" >> "%LOG_FILE%" 2>&1
    goto installer_not_found
)
echo [%date% %time%] Installer file found >> "%LOG_FILE%"

:: Wait for app to exit
echo Waiting for application to exit...
echo [%date% %time%] Waiting for app to exit >> "%LOG_FILE%"

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
taskkill /F /IM "%APP_NAME%" >nul 2>&1
ping 127.0.0.1 -n 2 >nul 2>&1
goto process_exited

:process_exited
echo [%date% %time%] Application exited >> "%LOG_FILE%"
echo Application closed

:: Wait a moment for file handles to release
ping 127.0.0.1 -n 3 >nul 2>&1

:: Run the installer (completely silent, install to APP_DIR)
echo Running installer...
echo [%date% %time%] Running installer (silent) to: %APP_DIR% >> "%LOG_FILE%"
echo [%date% %time%] Installer command: "%INSTALLER_PATH%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /DIR="%APP_DIR%" >> "%LOG_FILE%"

:: 尝试解除下载文件的阻止（可能被 Windows 安全策略阻止）
powershell -Command "Unblock-File -Path '%INSTALLER_PATH%'" >nul 2>&1

:: 直接运行安装程序并等待完成
echo [%date% %time%] Starting installer... >> "%LOG_FILE%"
"%INSTALLER_PATH%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /DIR="%APP_DIR%"
set RUN_RESULT=%ERRORLEVEL%
echo [%date% %time%] Installer finished, result: %RUN_RESULT% >> "%LOG_FILE%"

:: 无论结果如何，尝试启动应用
echo [%date% %time%] Starting application after install... >> "%LOG_FILE%"
start "" "%APP_DIR%\\omt.exe"

echo [%date% %time%] Update completed, result: %RUN_RESULT% >> "%LOG_FILE%"
echo Update completed!
goto finish

:installer_not_found
echo [%date% %time%] ERROR: Installer not found: %INSTALLER_PATH% >> "%LOG_FILE%"
echo ERROR: Installer not found
exit /b 1

:install_failed
echo [%date% %time%] ERROR: Install failed >> "%LOG_FILE%"
echo ERROR: Installation failed
exit /b 1

:finish
echo.
timeout /t 2 /nobreak >nul 2>&1
exit /b 0
''';
  }
}