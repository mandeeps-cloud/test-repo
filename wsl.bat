@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with elevated privileges...
) else (
    echo Not running as admin. Attempting to elevate...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dp0%~nx0' -Verb RunAs"
    exit /b
)

:: Ensure WSL is set to version 1
wsl --set-default-version 1

:: Update WSL to ensure it is the latest version
wsl --update

:: Check if Ubuntu 22.04 is already installed
wsl -l -v | findstr /C:"Ubuntu-22.04" >nul
if %errorlevel%==0 (
    echo Ubuntu-22.04 is already installed.
) else (
    echo Installing Ubuntu-22.04 via wsl Command

    :: Install the .appx package
    wsl --install -d Ubuntu-22.04

    :: Set Ubuntu-22.04 to use WSL1
    wsl --set-version Ubuntu-22.04 1
)

@echo Ubuntu 22.04 installation and WSL setup is complete.
pause
