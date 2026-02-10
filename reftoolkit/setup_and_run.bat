@echo off
echo ========================================
echo RefToolkit Setup and Run
echo ========================================
echo.

REM Check if Flutter is available
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter not found in PATH
    echo.
    echo Please install Flutter and add it to your PATH.
    echo See QUICK_START.md for instructions.
    echo.
    pause
    exit /b 1
)

echo [1/4] Checking Flutter installation...
flutter --version
echo.

echo [2/4] Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [3/4] Checking for whistle sound file...
if not exist "assets\sounds\whistle.mp3" (
    echo WARNING: whistle.mp3 not found in assets\sounds\
    echo The app will not produce sound without this file.
    echo See assets\sounds\README.txt for instructions.
    echo.
    echo Press any key to continue anyway, or Ctrl+C to exit...
    pause >nul
)
echo.

echo [4/4] Running Flutter doctor...
flutter doctor
echo.

echo ========================================
echo Setup complete!
echo ========================================
echo.
echo Choose an option:
echo   1) Run on Windows Desktop
echo   2) Run on Android
echo   3) Run on Chrome (web)
echo   4) Build Windows Release
echo   5) Exit
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo Starting RefToolkit on Windows...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo.
    echo Starting RefToolkit on Android...
    flutter run -d android
) else if "%choice%"=="3" (
    echo.
    echo Starting RefToolkit on Chrome...
    flutter run -d chrome
) else if "%choice%"=="4" (
    echo.
    echo Building Windows release...
    flutter build windows --release
    echo.
    echo Build complete! Find the app in:
    echo build\windows\runner\Release\
    echo.
    pause
) else (
    echo Exiting...
    exit /b 0
)

echo.
pause
