@echo off
echo ===================================================
echo     SOLAR UNLOADING APP - WEB SERVER (RELIABLE)
echo ===================================================
echo.
echo Found Flutter at: C:\flutter\bin\flutter.bat
echo.

echo 1. Updating dependencies...
call C:\flutter\bin\flutter.bat pub get

echo.
echo 2. Starting Web Server...
echo. 
echo     IMPORTANT:
echo     Wait for "Application finished." to appear? NO.
echo     Wait for "Listening on http://localhost:8080"
echo     Then OPEN CHROME and go to: http://localhost:8080
echo.

call C:\flutter\bin\flutter.bat run -d web-server --web-port=8080

pause
