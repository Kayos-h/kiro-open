@echo off
REM ============================================================
REM  kiro-open : double-click launcher (just in case)
REM  Starts the keep-awake watcher hidden in the background.
REM  It keeps the laptop awake while Kiro Crew is open, then
REM  stops on its own when Kiro Crew closes.
REM ============================================================

cd /d "%~dp0"

start "" /b powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0keep-awake.ps1"

echo kiro-open keep-awake started in the background.
echo It will keep this laptop awake while Kiro Crew is open.
echo (This window can be closed - the watcher keeps running.)
timeout /t 4 >nul
