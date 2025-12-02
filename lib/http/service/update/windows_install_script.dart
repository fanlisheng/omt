/// Windows安装脚本模板
/// 用于生成自动更新安装的批处理脚本
/// 现在下载的是 exe 安装程序，直接运行即可完成安装和覆盖
class WindowsInstallScript {
  
  /// 生成安装脚本（运行下载的 exe 安装程序）
  /// [installerPath] - 下载的 exe 安装程序路径
  /// [appName] - 应用程序名称（用于等待进程退出）
  static String generateInstallScript({
    required String installerPath,
    String appName = 'omt.exe',
  }) {
    final installerPathWin = installerPath.replaceAll('/', '\\');
    
    return _getInstallerScriptTemplate()
        .replaceAll('__APPNAME__', appName)
        .replaceAll('__INSTALLER_PATH__', installerPathWin);
  }

  /// 获取安装程序脚本模板
  /// 简化版本：只需等待旧进程退出，然后运行安装程序
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

echo [%date% %time%] APP_NAME=%APP_NAME% >> "%LOG_FILE%"
echo [%date% %time%] INSTALLER_PATH=%INSTALLER_PATH% >> "%LOG_FILE%"

:: Check if installer exists
if not exist "%INSTALLER_PATH%" goto installer_not_found

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
ping 127.0.0.1 -n 2 >nul 2>&1

:: Run the installer (silent install)
echo Running installer...
echo [%date% %time%] Running installer: %INSTALLER_PATH% >> "%LOG_FILE%"

start "" "%INSTALLER_PATH%"
set RUN_RESULT=%ERRORLEVEL%
echo [%date% %time%] Installer started, result: %RUN_RESULT% >> "%LOG_FILE%"

if %RUN_RESULT% NEQ 0 goto install_failed

echo [%date% %time%] Update completed successfully >> "%LOG_FILE%"
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