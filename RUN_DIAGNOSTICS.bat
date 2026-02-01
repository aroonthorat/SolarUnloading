@echo off
echo =========================================
echo   Solar Unloading - Complete Diagnostic
echo =========================================
echo.
echo Running diagnostics... Please wait...
echo.

cd /d "%~dp0"

echo [1/5] Checking Flutter installation...
C:\flutter\bin\flutter --version > diagnostic_flutter_version.txt 2>&1
type diagnostic_flutter_version.txt
echo.

echo [2/5] Running Flutter Doctor...
C:\flutter\bin\flutter doctor -v > diagnostic_flutter_doctor.txt 2>&1
type diagnostic_flutter_doctor.txt
echo.

echo [3/5] Checking available devices...
C:\flutter\bin\flutter devices > diagnostic_devices.txt 2>&1
type diagnostic_devices.txt
echo.

echo [4/5] Checking project dependencies...
C:\flutter\bin\flutter pub get > diagnostic_pub_get.txt 2>&1
type diagnostic_pub_get.txt
echo.

echo [5/5] Analyzing code...
C:\flutter\bin\flutter analyze > diagnostic_analyze.txt 2>&1
type diagnostic_analyze.txt
echo.

echo =========================================
echo   Diagnostic Complete!
echo =========================================
echo.
echo Results saved to:
echo   - diagnostic_flutter_version.txt
echo   - diagnostic_flutter_doctor.txt
echo   - diagnostic_devices.txt
echo   - diagnostic_pub_get.txt
echo   - diagnostic_analyze.txt
echo.
echo Please share these files with me for analysis.
echo.
pause
