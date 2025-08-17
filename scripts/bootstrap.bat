@echo off
setlocal

set REPO_URL=https://github.com/anfalovK/ai_kb
set TARGET_DIR=ai_kb

git clone %REPO_URL% %TARGET_DIR%
if %errorlevel% neq 0 exit /b %errorlevel%
cd %TARGET_DIR%

call scripts\setup.bat
if %errorlevel% neq 0 exit /b %errorlevel%
