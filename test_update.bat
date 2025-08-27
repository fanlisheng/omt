@echo off
chcp 65001 >nul
echo ========================================
echo           Client Update Script
echo ========================================
echo.

REM ===== CONFIG =====
set "APP_NAME=omt.exe"
set "SOURCE_DIR=C:\Users\lc\Downloads\update_1.0.1"
set "TARGET_DIR=C:\Users\lc\Desktop\omt\windows-app(1)"
set "APP_PATH=%TARGET_DIR%\%APP_NAME%"
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
xcopy "%SOURCE_DIR%\*" "%TARGET_DIR%\" /E /Y /I /R
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