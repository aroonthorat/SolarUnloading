@echo off
echo =====================================
echo Solar Unloading App - Run Script
echo =====================================
echo.

echo Step 1: Checking Flutter installation...
C:\flutter\bin\flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found!
    pause
    exit /b 1
)
echo.

echo Step 2: Checking connected devices...
C:\flutter\bin\flutter devices
echo.

echo Step 3: Starting the app...
echo (First build takes 5-10 minutes)
echo.
C:\flutter\bin\flutter run

pause
