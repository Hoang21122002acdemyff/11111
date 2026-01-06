@echo off
REM ==============================================
REM START SCRIPT - Face Recognition Attendance
REM Fixed Qt + Conda (CMD / PowerShell / VS Code)
REM ==============================================

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "ENV_NAME=face_attendance"
set "CONDA_PATH="

echo.
echo ============================================
echo   Face Recognition Attendance System
echo   Starting Application...
echo ============================================
echo.

REM ============================================
REM Step 1: Find Conda installation
REM ============================================
echo [1/3] Finding Conda installation...

for %%p in (
    "%USERPROFILE%\miniconda3"
    "%USERPROFILE%\anaconda3"
    "C:\ProgramData\miniconda3"
    "C:\ProgramData\anaconda3"
    "C:\miniconda3"
    "C:\anaconda3"
) do (
    if exist "%%~p\condabin\conda.bat" (
        set "CONDA_PATH=%%~p"
        echo [OK] Found Conda at: %%~p
        goto :found_conda
    )
)

echo.
echo [ERROR] Conda not found!
pause
exit /b 1

:found_conda

REM ============================================
REM Step 2: Check environment
REM ============================================
echo [2/3] Checking environment...

set "ENV_PATH=!CONDA_PATH!\envs\%ENV_NAME%"
set "PYTHON_EXE=!ENV_PATH!\python.exe"

if not exist "!PYTHON_EXE!" (
    echo.
    echo [ERROR] Environment %ENV_NAME% not found!
    pause
    exit /b 1
)

echo [OK] Environment found: !ENV_PATH!

REM ============================================
REM Step 3: Fix Qt plugin path (CRITICAL)
REM ============================================
set "QT_QPA_PLATFORM_PLUGIN_PATH=!ENV_PATH!\Lib\site-packages\PySide6\plugins\platforms"

REM ============================================
REM Step 4: Run application
REM ============================================
echo [3/3] Starting application...
echo.
echo ============================================
echo   Launching Face Recognition Attendance
echo ============================================
echo.

cd /d "%SCRIPT_DIR%"

"!PYTHON_EXE!" app_main.py

if errorlevel 1 (
    echo.
    echo [ERROR] Application exited with error code: %errorlevel%
    pause
)

endlocal
exit /b 0
