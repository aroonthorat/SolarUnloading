@echo off
echo ===================================================
echo     SOLAR UNLOADING APP - LAUNCHER (FIXED)
echo ===================================================
echo.
echo Found Flutter at: C:\flutter\bin\flutter.bat
echo.

echo 1. Updating dependencies...
call C:\flutter\bin\flutter.bat pub get

echo.
echo 2. Launching Admin Dashboard...
echo (This may take a minute to compile)
echo.

call C:\flutter\bin\flutter.bat run -d chrome

pause
