@echo off
for /f "delims=" %%i in ('ver') do set VAR=%%i

echo.
echo ==============================
echo   UnieOS install failed
echo ==============================
echo.
echo Only Linux environments supported
echo Sorry :(
echo.
echo You are using %VAR%
echo You can see supported Linux environments here:
echo https://www.ubuntu.com
echo https://linuxmint.com
echo https://debian.org
echo https://devuan.org
echo.
pause
