@echo off
setlocal

echo ==========================================
echo Building HTML5 package for itch.io...
echo ==========================================

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js is not installed.
  echo Install Node.js LTS from https://nodejs.org/
  pause
  exit /b 1
)

echo [1/4] Installing dependencies...
call npm install
if errorlevel 1 (
  echo [ERROR] npm install failed.
  pause
  exit /b 1
)

echo [2/4] Building production files...
call npm run build
if errorlevel 1 (
  echo [ERROR] Build failed.
  pause
  exit /b 1
)

if not exist "dist\index.html" (
  echo [ERROR] Build output missing: dist\index.html
  pause
  exit /b 1
)

echo [3/4] Creating upload zip...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "if (Test-Path 'itch-upload.zip') { Remove-Item 'itch-upload.zip' -Force }; Compress-Archive -Path 'dist\*' -DestinationPath 'itch-upload.zip' -Force"
if errorlevel 1 (
  echo [ERROR] Could not create itch-upload.zip
  pause
  exit /b 1
)

echo [4/4] Done.
echo.
echo Upload this file to itch.io:
echo   itch-upload.zip
echo.
echo IMPORTANT:
echo - In itch project settings, choose HTML5.
echo - Keep index.html at the zip root (this script already does that).
echo.
pause
