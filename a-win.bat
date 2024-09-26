@echo off
powershell -Command "Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile %TEMP%\AppInstaller.appx"
powershell -Command "Add-AppxPackage -Path %TEMP%\AppInstaller.appx"
echo winget has been installed.
pause
