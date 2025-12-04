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

:: Wait for app to exit (PowerShell for fast detection)
echo [%date% %time%] Starting process wait check for: %APP_NAME% >> "%LOG_FILE%"
set WAIT_COUNT=0

:wait_loop
echo [%date% %time%] Check #%WAIT_COUNT%: Looking for process '%APP_NAME:~0,-4%' >> "%LOG_FILE%"
powershell -Command "if (Get-Process -Name '%APP_NAME:~0,-4%' -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }" >nul 2>&1
set PROCESS_CHECK=%ERRORLEVEL%
echo [%date% %time%] Check result: %PROCESS_CHECK% (0=not found, 1=found) >> "%LOG_FILE%"

if %PROCESS_CHECK% EQU 0 (
    echo [%date% %time%] Process not found, continuing... >> "%LOG_FILE%"
    goto process_exited
)

if %WAIT_COUNT% EQU 0 (
    echo Waiting for application to exit...
    echo [%date% %time%] Process still running, entering wait loop >> "%LOG_FILE%"
)

set /a WAIT_COUNT=WAIT_COUNT+1
echo [%date% %time%] Wait count: %WAIT_COUNT%/10 >> "%LOG_FILE%"

if %WAIT_COUNT% GEQ 10 goto force_kill

timeout /t 1 /nobreak >nul 2>&1
goto wait_loop

:force_kill
echo [%date% %time%] Force killing process >> "%LOG_FILE%"
taskkill /F /IM "%APP_NAME%" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
goto process_exited

:process_exited
echo [%date% %time%] Application exited >> "%LOG_FILE%"
echo Application closed

:: Wait for file handles to release
timeout /t 1 /nobreak >nul 2>&1

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

  /// 安装程序脚本模板（运行 exe 安装程序到指定目录）- 简化快速版
  static String _getInstallerScriptTemplate() {
    return '''@echo off
setlocal enabledelayedexpansion

title OMT Installer Update

set LOG_DIR=%TEMP%\\OMT_Update
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set LOG_FILE=%LOG_DIR%\\omt_update_log.txt

echo [%date% %time%] Installer update started > "%LOG_FILE%"
echo Running installer update...

set APP_NAME=__APPNAME__
set INSTALLER_PATH=__INSTALLER_PATH__
set APP_DIR=__APP_DIR__

echo [%date% %time%] Installer: %INSTALLER_PATH% >> "%LOG_FILE%"

:: Check if installer exists
if not exist "%INSTALLER_PATH%" (
    echo [%date% %time%] ERROR: Installer not found >> "%LOG_FILE%"
    echo ERROR: Installer not found
    exit /b 1
)

:: Wait for app to exit (PowerShell for fast detection)
echo [%date% %time%] Starting process wait check for: %APP_NAME% >> "%LOG_FILE%"
set /a COUNT=0

:wait_exit
echo [%date% %time%] Check #%COUNT%: Looking for process '%APP_NAME:~0,-4%' >> "%LOG_FILE%"
powershell -Command "if (Get-Process -Name '%APP_NAME:~0,-4%' -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }" >nul 2>&1
set PROCESS_CHECK=%ERRORLEVEL%
echo [%date% %time%] Check result: %PROCESS_CHECK% (0=not found, 1=found) >> "%LOG_FILE%"

if %PROCESS_CHECK% EQU 0 (
    echo [%date% %time%] Process not found, continuing... >> "%LOG_FILE%"
    goto app_closed
)

if %COUNT% EQU 0 (
    echo Waiting for application to exit...
    echo [%date% %time%] Process still running, entering wait loop >> "%LOG_FILE%"
)

set /a COUNT=COUNT+1
echo [%date% %time%] Wait count: %COUNT%/10 >> "%LOG_FILE%"

if %COUNT% GEQ 10 (
    echo [%date% %time%] Max wait reached, force killing app >> "%LOG_FILE%"
    taskkill /F /IM "%APP_NAME%" >nul 2>&1
    timeout /t 1 /nobreak >nul
    goto app_closed
)

timeout /t 1 /nobreak >nul
goto wait_exit

:app_closed
echo [%date% %time%] App exited >> "%LOG_FILE%"

:: Unblock installer file
powershell -Command "Unblock-File -Path '%INSTALLER_PATH%'" >nul 2>&1

:: Run silent installer
echo Running installer...
echo [%date% %time%] Starting installer >> "%LOG_FILE%"
"%INSTALLER_PATH%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /DIR="%APP_DIR%"
set RUN_RESULT=%ERRORLEVEL%
echo [%date% %time%] Installer finished: %RUN_RESULT% >> "%LOG_FILE%"

:: Start app
echo Starting application...
start "" "%APP_DIR%\\%APP_NAME%"

echo [%date% %time%] Update completed >> "%LOG_FILE%"
echo Update completed!
exit /b 0
''';
  }
}