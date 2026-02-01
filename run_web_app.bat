@echo off
echo ===========================================
echo   Solar Unloading - Web App Launcher
echo ===========================================
echo.
echo Starting web server...
echo The app will open in your default browser
echo.
echo If it doesn't open automatically:
echo Open your browser and go to: http://localhost:PORT
echo (Check the output below for the actual port number)
echo.
echo Press Ctrl+C to stop the server
echo ===========================================
echo.

cd /d "%~dp0"
C:\flutter\bin\flutter run -d chrome --web-port=8080

pause
