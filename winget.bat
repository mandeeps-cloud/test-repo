@echo off

REM Check if winget is installed
echo Checking if winget is installed...
winget --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo winget is not installed. Installing winget...

    REM Download and install App Installer (which includes winget)
    echo Downloading winget (App Installer)...
    powershell -Command "Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile %TEMP%\AppInstaller.appx"

    echo Installing winget (App Installer)...
    powershell -Command "Add-AppxPackage -Path %TEMP%\AppInstaller.appx"
    
    REM Clean up downloaded file
    del /F /Q %TEMP%\AppInstaller.appx
    
    echo winget installed successfully.
) else (
    echo winget is already installed.
)

REM Wait for a few seconds to ensure winget is ready
timeout /t 5 >nul

REM Install Winaero Tweaker
echo Installing Winaero Tweaker via winget...
winget install --id=Winaero.WinaeroTweaker --silent --accept-package-agreements --accept-source-agreements

echo Winaero Tweaker installation completed.
pause
