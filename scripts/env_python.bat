@echo off
REM Shared env for offline embeddable Python (tkinter / Tcl / Tk)
REM Called by CHAT.bat, FirstRun.bat, run_py.bat before python.exe

if not defined GGUF_ROOT (
  if exist "%~dp0..\python\python.exe" (
    for %%I in ("%~dp0..") do set "GGUF_ROOT=%%~fI"
  ) else if exist "%cd%\python\python.exe" (
    set "GGUF_ROOT=%cd%"
  )
)

if not defined GGUF_ROOT exit /b 0
if not exist "%GGUF_ROOT%\python\python.exe" exit /b 0

set "GGUF_PY_HOME=%GGUF_ROOT%\python"

REM Tcl/Tk libraries (required for tkinter + customtkinter on embeddable CPython)
if exist "%GGUF_PY_HOME%\tcl\tcl8.6" set "TCL_LIBRARY=%GGUF_PY_HOME%\tcl\tcl8.6"
if exist "%GGUF_PY_HOME%\tcl\tk8.6" set "TK_LIBRARY=%GGUF_PY_HOME%\tcl\tk8.6"
if exist "%GGUF_PY_HOME%\Lib\tcl8.6" if not defined TCL_LIBRARY set "TCL_LIBRARY=%GGUF_PY_HOME%\Lib\tcl8.6"
if exist "%GGUF_PY_HOME%\Lib\tk8.6" if not defined TK_LIBRARY set "TK_LIBRARY=%GGUF_PY_HOME%\Lib\tk8.6"

REM Prefer DLLs next to python.exe
set "PATH=%GGUF_PY_HOME%;%PATH%"
