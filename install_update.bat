@echo off
setlocal enabledelayedexpansion

REM Set log file path
set "LOG_DIR=%TEMP%\OMT_Update"
set "LOG_FILE=%LOG_DIR%\update_log.txt"

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
set "APP_NAME=omt.exe"
set "SOURCE_DIR=C:\Users\lc\Desktop\omt\windows-app\update_extracted"
set "TARGET_DIR=C:\Users\lc\Desktop\omt\windows-app"
set "ZIP_PATH=C:\Users\lc\Desktop\omt\windows-app\downloads\update_1.0.8.zip"

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
    xcopy "%SOURCE_DIR%\*" "%TARGET_DIR%\" /E /Y /I /R /H >nul 2>&1
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