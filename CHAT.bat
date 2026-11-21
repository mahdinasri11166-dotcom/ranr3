@echo off
chcp 65001 >nul
title GGUF Runner Hub
cd /d "%~dp0"
set "GGUF_ROOT=%~dp0"
if "%GGUF_ROOT:~-1%"=="\" set "GGUF_ROOT=%GGUF_ROOT:~0,-1%"
call "%~dp0scripts\env_python.bat" 2>nul

if not exist "models" mkdir models 2>nul
if not exist "sessions" mkdir sessions 2>nul
if not exist "workspace" mkdir workspace 2>nul

set "PY="
if exist "python\python.exe" set "PY=%~dp0python\python.exe"
if not defined PY (
  where python >nul 2>&1 && for /f "delims=" %%P in ('where python') do (
    if not defined PY set "PY=%%P"
  )
)
if not defined PY (
  echo [ERROR] Python پیدا نشد.
  pause
  exit /b 1
)

"%PY%" -c "import customtkinter" 2>nul
if errorlevel 1 (
  echo [ERROR] customtkinter/tkinter موجود نیست.
  echo       SETUP.bat یا INSTALL.bat یا Setup.exe آفلاین GitHub
  pause
  exit /b 1
)

if exist "scripts\python\app_hub.py" (
  echo Starting GGUF Runner Hub...
  "%PY%" "%~dp0scripts\python\app_hub.py"
) else (
  echo Starting classic chat...
  "%PY%" "%~dp0scripts\python\desktop_chat.py"
)
set ERR=%ERRORLEVEL%
if not "%ERR%"=="0" (
  echo Exit code %ERR%
  pause
)
exit /b %ERR%
