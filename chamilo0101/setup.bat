@echo off
REM ==============================================
REM SETUP SCRIPT - Face Recognition Attendance
REM Compatible: Windows 10/11 (CMD and PowerShell)
REM ==============================================

setlocal EnableDelayedExpansion

echo.
echo ============================================
echo   Face Recognition Attendance - Setup
echo   Windows Installation Script
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "ENV_NAME=face_attendance"
set "CONDA_PATH="

REM ============================================
REM Step 1: Find Conda installation
REM ============================================
echo [1/5] Checking Conda installation...

REM Check common Conda paths
for %%p in (
    "%USERPROFILE%\miniconda3"
    "%USERPROFILE%\anaconda3"
    "%USERPROFILE%\miniforge3"
    "%USERPROFILE%\mambaforge"
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

REM Try conda from PATH
where conda >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Conda is available in PATH
    for /f "delims=" %%i in ('where conda') do (
        for %%j in ("%%~dpi..") do (
            if exist "%%~fj\condabin\conda.bat" (
                set "CONDA_PATH=%%~fj"
                goto :found_conda
            )
        )
    )
)

REM Conda not found - install it
echo [!] Conda not found. Installing Miniconda...
goto :install_conda

:install_conda
echo.
echo ============================================
echo   Installing Miniconda
echo ============================================
echo.

set "MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
set "INSTALLER=%TEMP%\miniconda_installer.exe"
set "MINICONDA_DIR=%USERPROFILE%\miniconda3"

echo Downloading Miniconda...
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%MINICONDA_URL%' -OutFile '%INSTALLER%'}"

if not exist "%INSTALLER%" (
    echo [ERROR] Failed to download Miniconda
    echo Please download manually from: https://docs.conda.io/en/latest/miniconda.html
    pause
    exit /b 1
)

echo Installing Miniconda (this may take a few minutes)...
start /wait "" "%INSTALLER%" /InstallationType=JustMe /RegisterPython=0 /AddToPath=1 /S /D=%MINICONDA_DIR%

if exist "%MINICONDA_DIR%\condabin\conda.bat" (
    echo [OK] Miniconda installed successfully
    set "CONDA_PATH=%MINICONDA_DIR%"
    del "%INSTALLER%" 2>nul
    
    echo Initializing Conda...
    call "%MINICONDA_DIR%\condabin\conda.bat" init cmd.exe >nul 2>&1
    call "%MINICONDA_DIR%\condabin\conda.bat" init powershell >nul 2>&1
    
    echo.
    echo [IMPORTANT] Miniconda was just installed.
    echo Please CLOSE this window and run setup.bat again!
    echo.
    pause
    exit /b 0
) else (
    echo [ERROR] Miniconda installation failed
    pause
    exit /b 1
)

:found_conda
echo [OK] Conda path: !CONDA_PATH!

REM ============================================
REM Step 2: Initialize Conda shell
REM ============================================
echo.
echo ============================================
echo [2/5] Initializing Conda Shell
echo ============================================
echo.

REM This is the key fix - properly initialize conda hooks
call "!CONDA_PATH!\condabin\conda_hook.bat" >nul 2>&1
if %errorlevel% neq 0 (
    call "!CONDA_PATH!\condabin\conda.bat" activate >nul 2>&1
)
echo [OK] Conda shell initialized

REM ============================================
REM Step 3: Setup Environment
REM ============================================
echo.
echo ============================================
echo [3/5] Setting up Conda Environment
echo ============================================
echo.

REM Check if environment exists using conda directly
"!CONDA_PATH!\condabin\conda.bat" env list | findstr /C:"%ENV_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Environment '%ENV_NAME%' already exists
    set /p "RECREATE=Do you want to recreate it? [y/N]: "
    if /i "!RECREATE!"=="y" (
        echo Removing old environment...
        call "!CONDA_PATH!\condabin\conda.bat" env remove -n %ENV_NAME% -y
        if %errorlevel% neq 0 (
            echo [WARNING] Could not remove environment, will try to update it
        )
    ) else (
        echo Using existing environment
        goto :create_dirs
    )
)

REM Create new environment
echo Creating Conda environment: %ENV_NAME% with Python 3.10
call "!CONDA_PATH!\condabin\conda.bat" create -n %ENV_NAME% python=3.10 -y
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create conda environment
    echo.
    echo Try manually: conda create -n %ENV_NAME% python=3.10 -y
    pause
    exit /b 1
)

echo [OK] Environment created successfully

REM ============================================
REM Step 4: Install dependencies
REM ============================================
echo.
echo ============================================
echo [4/5] Installing Dependencies
echo ============================================
echo.

echo Activating environment...
call "!CONDA_PATH!\condabin\conda.bat" activate %ENV_NAME%
if %errorlevel% neq 0 (
    echo [WARNING] Activation returned error, trying alternative method...
    call "!CONDA_PATH!\envs\%ENV_NAME%\Scripts\activate.bat" 2>nul
)

REM Verify we're in the right environment by checking python path
set "PYTHON_EXE=!CONDA_PATH!\envs\%ENV_NAME%\python.exe"
if not exist "!PYTHON_EXE!" (
    echo [ERROR] Python not found in environment
    pause
    exit /b 1
)

set "PIP_EXE=!CONDA_PATH!\envs\%ENV_NAME%\Scripts\pip.exe"
echo [OK] Using Python: !PYTHON_EXE!
echo.
echo Installing packages (this may take 5-10 minutes)...
echo.

echo [1/7] Installing numpy, pandas, openpyxl...
"!PIP_EXE!" install numpy==1.26.4 pandas==2.1.4 openpyxl==3.1.2 --quiet
if %errorlevel% neq 0 (
    echo [WARNING] Some packages may have issues, continuing...
)

echo [2/7] Installing OpenCV...
"!PIP_EXE!" install opencv-python-headless==4.9.0.80 --quiet
if %errorlevel% neq 0 (
    "!PIP_EXE!" install opencv-python-headless --quiet
)

echo [3/7] Installing PySide6...
"!PIP_EXE!" install PySide6==6.6.1 --quiet
if %errorlevel% neq 0 (
    "!PIP_EXE!" install PySide6 --quiet
)

echo [4/7] Installing mediapipe...
"!PIP_EXE!" install mediapipe==0.10.9 --quiet
if %errorlevel% neq 0 (
    "!PIP_EXE!" install mediapipe --quiet
)

echo [5/7] Installing cmake (required for dlib)...
"!PIP_EXE!" install cmake --quiet

echo [6/7] Installing dlib (this may take several minutes)...
"!PIP_EXE!" install dlib==19.24.2 --quiet
if %errorlevel% neq 0 (
    echo [!] Pre-built dlib failed, trying conda-forge...
    call "!CONDA_PATH!\condabin\conda.bat" install -n %ENV_NAME% -c conda-forge dlib -y
)

echo [7/7] Installing face_recognition...
"!PIP_EXE!" install face_recognition==1.3.0 --quiet
if %errorlevel% neq 0 (
    "!PIP_EXE!" install face_recognition --quiet
)

echo.
echo [OK] Dependencies installation completed

:create_dirs
REM ============================================
REM Step 5: Create directories
REM ============================================
echo.
echo ============================================
echo [5/5] Creating Directories
echo ============================================
echo.

if not exist "%SCRIPT_DIR%known_faces" mkdir "%SCRIPT_DIR%known_faces"
if not exist "%SCRIPT_DIR%attendance_records" mkdir "%SCRIPT_DIR%attendance_records"
if not exist "%SCRIPT_DIR%Logo" mkdir "%SCRIPT_DIR%Logo"

echo [OK] Created: known_faces\
echo [OK] Created: attendance_records\
echo [OK] Created: Logo\

REM ============================================
REM Finish
REM ============================================
echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo To run the application:
echo   - Double-click start.bat
echo   - Or right-click start.bat and select "Run as administrator"
echo.
echo If double-click opens text editor instead of running:
echo   - Right-click start.bat -^> Open with -^> Choose another app
echo   - Select "Windows Command Processor" or browse to C:\Windows\System32\cmd.exe
echo.

endlocal
pause
exit /b 0
