@echo off
echo OMT Update Installer Starting...

REM Wait for application to exit
timeout /t 3 /nobreak >nul 2>&1

REM Set variables
set "APP_NAME=omt.exe"
set "SOURCE_DIR=C:\Users\lc\Desktop\omt\windows-app\update_extracted"
set "TARGET_DIR=C:\Users\lc\Desktop\omt\windows-app"
set "ZIP_PATH=C:\Users\lc\Desktop\omt\windows-app\downloads\update_1.0.8.zip"

echo Checking source: %SOURCE_DIR%
if not exist "%SOURCE_DIR%" (
    echo ERROR: Source not found
    pause
    exit /b 1
)

echo Preparing target: %TARGET_DIR%
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Copying files...
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:1 /W:1 >nul
if %ERRORLEVEL% GTR 7 (
    echo ERROR: Copy failed
    pause
    exit /b 1
)

echo Cleaning up...
if exist "%ZIP_PATH%" del "%ZIP_PATH%" >nul 2>&1

echo Starting application...
cd /d "%TARGET_DIR%"
start "" "%APP_NAME%"

echo Update completed!
exit /b 0