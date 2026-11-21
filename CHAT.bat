@echo off
chcp 65001 >nul
title GGUF Runner Hub
cd /d "%~dp0"
set "GGUF_ROOT=%~dp0"
if "%GGUF_ROOT:~-1%"=="\" set "GGUF_ROOT=%GGUF_ROOT:~0,-1%"

rem --- تنظیم مسیرهای آفلاین و Tcl/Tk ---
set "OFFLINE_PY=%~dp0installer\payload\python-offline-amd64"
set "TCL_LIBRARY=%OFFLINE_PY%\tcl\tcl8.6"
set "TK_LIBRARY=%OFFLINE_PY%\tcl\tk8.6"
set "PYTHONPATH=%OFFLINE_PY%\project_scripts;%~dp0"

call "%~dp0scripts\env_python.bat" 2>nul

if not exist "models" mkdir models 2>nul
if not exist "sessions" mkdir sessions 2>nul
if not exist "workspace" mkdir workspace 2>nul

rem --- پیدا کردن پایتون آفلاین ---
set "PY="
if exist "%OFFLINE_PY%\python.exe" (
    set "PY=%OFFLINE_PY%\python.exe"
    echo [OK] Using offline Python.
) else (
    rem اگر نسخه آفلاین نبود، از پایتون سیستمی استفاده کن
    where python >nul 2>&1 && for /f "delims=" %%P in ('where python') do (
        if not defined PY set "PY=%%P"
    )
    if defined PY echo [WARN] Offline Python not found. Using system Python.
)

if not defined PY (
  echo [ERROR] Python پیدا نشد.
  pause
  exit /b 1
)

rem --- بررسی نصب customtkinter ---
"%PY%" -c "import customtkinter" 2>nul
if errorlevel 1 (
  echo [ERROR] customtkinter/tkinter موجود نیست.
  echo       لطفا ابتدا Setup.exe آفلاین را نصب کنید.
  pause
  exit /b 1
)

rem --- اجرای برنامه ---
if exist "%OFFLINE_PY%\project_scripts\app_hub.py" (
  echo Starting GGUF Runner Hub...
  "%PY%" "%OFFLINE_PY%\project_scripts\app_hub.py"
) else if exist "scripts\python\app_hub.py" (
  echo Starting classic chat...
  "%PY%" "%~dp0scripts\python\app_hub.py"
) else (
  echo [ERROR] app_hub.py پیدا نشد.
  pause
  exit /b 1
)

set ERR=%ERRORLEVEL%
if not "%ERR%"=="0" (
  echo Exit code %ERR%
  pause
)
exit /b %ERR%
