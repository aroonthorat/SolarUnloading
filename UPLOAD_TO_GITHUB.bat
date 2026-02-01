@echo off
echo =========================================
echo   Uploading to GitHub
echo =========================================
echo.

cd /d "%~dp0"

echo Step 1: Adding files...
git add .

echo.
echo Step 2: Creating commit...
git commit -m "Add Solar Unloading web app"

echo.
echo Step 3: Adding remote repository...
git remote add origin https://github.com/aroonthorat/SolarUnloading.git

echo.
echo Step 4: Pushing to GitHub...
git push -u origin main

echo.
echo =========================================
echo   Upload Complete!
echo =========================================
echo.
echo Your web app is now on GitHub!
echo.
echo Next: Enable GitHub Pages
echo 1. Go to: https://github.com/aroonthorat/SolarUnloading/settings/pages
echo 2. Source: Deploy from a branch
echo 3. Branch: main
echo 4. Folder: / (root)
echo 5. Click Save
echo.
echo Your app will be live at:
echo https://aroonthorat.github.io/SolarUnloading/web_app/
echo.
pause
