@echo off
setlocal

rem Run the Linux setup script using bash
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%.."

bash scripts/setup.sh
if %errorlevel% neq 0 exit /b %errorlevel%
