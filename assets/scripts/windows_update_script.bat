@echo off
chcp 65001 >nul
title OMT Update Installer

echo ========================================
echo        OMT Update Installer
echo ========================================
echo.

set "APP_NAME=${appName}"
set "SOURCE_DIR=${sourceDir}"
set "TARGET_DIR=${targetDir}"
set "APP_PATH=%TARGET_DIR%\\%APP_NAME%"
set "ZIP_PATH=${zipPath}"
set "LOG_FILE=%~dp0omt_update_log.txt"

echo LOG FILE: %LOG_FILE%
echo ZIP PATH: %ZIP_PATH%
echo ========================================
echo.

echo Init log > "%LOG_FILE%"
echo Start update >> "%LOG_FILE%"

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
if exist "%SOURCE_DIR%\." (
    echo SUCCESS: SOURCE_DIR is a valid directory >> "%LOG_FILE%"
) else (
    echo FAILED: SOURCE_DIR is not a valid directory >> "%LOG_FILE%"
)

REM List directory contents
echo Directory contents: >> "%LOG_FILE%"
dir "%SOURCE_DIR%" >> "%LOG_FILE%" 2>&1

REM Check for key files
if exist "%SOURCE_DIR%\omt.exe" (
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

title OMT Update Installer - Step 0/6: Extracting ZIP
echo [0/6] Checking and extracting ZIP...
echo DEBUG: SOURCE_DIR = %SOURCE_DIR% >> "%LOG_FILE%"
echo DEBUG: ZIP_PATH = %ZIP_PATH% >> "%LOG_FILE%"
if exist "%SOURCE_DIR%" goto source_exists
if not exist "%ZIP_PATH%" goto zip_missing
echo Extracting %ZIP_PATH% to %SOURCE_DIR%...
"C:\\Program Files\\7-Zip\\7z.exe" x "%ZIP_PATH%" -o"%SOURCE_DIR%" -y > "%TEMP%\\7z_output.txt" 2>&1
type "%TEMP%\\7z_output.txt" >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 goto extract_failed
echo [OK] ZIP extracted
echo ZIP extracted >> "%LOG_FILE%"
echo DEBUG: Checking extracted contents... >> "%LOG_FILE%"
dir "%SOURCE_DIR%" >> "%LOG_FILE%" 2>&1
echo DEBUG: Verifying source directory after extraction... >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%\omt.exe" (
    echo DEBUG: omt.exe not found in expected location, checking subdirectories... >> "%LOG_FILE%"
    for /d %%d in ("%SOURCE_DIR%\*") do (
        echo DEBUG: Found subdirectory: %%d >> "%LOG_FILE%"
        if exist "%%d\omt.exe" (
            echo DEBUG: Found omt.exe in %%d, updating SOURCE_DIR... >> "%LOG_FILE%"
            set "SOURCE_DIR=%%d"
            goto extract_done
        )
    )
)
goto extract_done

:extract_failed
echo [ERROR] Extraction failed, code: %ERRORLEVEL%
echo Extract failed >> "%LOG_FILE%"
goto error_end

:zip_missing
echo [ERROR] ZIP not found: %ZIP_PATH%
echo ZIP not found >> "%LOG_FILE%"
goto error_end

:source_exists
echo [OK] Source dir exists, skipping extract
echo Source dir exists >> "%LOG_FILE%"
:extract_done
echo.

title OMT Update Installer - Step 1/6: Checking Files
echo [1/6] Checking source directory...
echo DEBUG: Checking if %SOURCE_DIR% exists... >> "%LOG_FILE%"
if not exist "%SOURCE_DIR%" goto source_missing
echo [OK] Source directory exists
echo Source dir exists >> "%LOG_FILE%"
goto step1_done

:source_missing
echo [ERROR] Source dir not found: %SOURCE_DIR%
echo Source dir not found >> "%LOG_FILE%"
echo DEBUG: Listing parent directory... >> "%LOG_FILE%"
for %%i in ("%SOURCE_DIR%") do dir "%%~dpi" >> "%LOG_FILE%" 2>&1
goto error_end

:step1_done
echo.

title OMT Update Installer - Step 2/6: Preparing Directory
echo [2/6] Preparing target dir...
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
  if errorlevel 1 goto target_create_failed
  echo Target dir created
  goto target_ready
)
echo [OK] Target directory exists
:target_ready
echo Target ready >> "%LOG_FILE%"
goto step2_done

:target_create_failed
echo [ERROR] Failed to create target dir
echo Target create failed >> "%LOG_FILE%"
goto error_end

:step2_done
echo.

title OMT Update Installer - Step 3/6: Copying Files
echo [3/6] Copying files from "%SOURCE_DIR%" to "%TARGET_DIR%"...
xcopy "%SOURCE_DIR%\\*" "%TARGET_DIR%\\" /E /Y /I /R > "%TEMP%\\xcopy_output.txt" 2>&1
set "XCOPY_ERR=%ERRORLEVEL%"
type "%TEMP%\\xcopy_output.txt" >> "%LOG_FILE%"
if %XCOPY_ERR% GEQ 4 goto copy_failed
echo [OK] Files copied successfully
echo Copy complete, code: %XCOPY_ERR% >> "%LOG_FILE%"
goto step3_done

:copy_failed
echo [ERROR] Copy failed, code: %XCOPY_ERR%
echo Copy failed %XCOPY_ERR% >> "%LOG_FILE%"
goto error_end

:step3_done
echo.

title OMT Update Installer - Step 4/6: Verifying Files
echo [4/6] Verifying target directory...
dir "%TARGET_DIR%" /B >> "%LOG_FILE%"
echo [OK] Verification complete
echo Verify complete >> "%LOG_FILE%"
echo.

title OMT Update Installer - Step 5/6: Cleaning Up
echo [5/6] Cleaning temporary files...
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
echo Cleanup done.
echo.

title OMT Update Installer - Step 6/6: Starting Application
echo [6/6] Launching app...
cd /d "%TARGET_DIR%"
if exist "%APP_PATH%" (
  echo [INFO] Launching: %APP_PATH%
  echo Application launched: %APP_PATH% >> "%LOG_FILE%"
  start "" "%APP_PATH%"
  echo [OK] Application started >> "%LOG_FILE%"
) else (
  echo [ERROR] Executable not found: %APP_PATH%
  echo App not found >> "%LOG_FILE%"
  goto error_end
)

echo.
title OMT Update Installer - Completed
echo ========================================
echo       UPDATE PROCESS COMPLETED!
echo ========================================
echo.
echo Update complete >> "%LOG_FILE%"
echo.
echo Auto closing in 3 seconds...
timeout /t 3 /nobreak >nul
exit /b 0

:error_end
echo [ERROR] Process failed. Check log.
type "%LOG_FILE%"
timeout /t 5 /nobreak >nul
exit /b 1