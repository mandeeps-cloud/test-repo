@echo off
:: Visual Studio 2019 Professional 16.11.40 installer batch script
:: This script installs Visual Studio 2019 Professional version 16.11.40 with specific workloads

echo Downloading Visual Studio Installer for version 16.11.40...
curl -L -o vs_installer.exe "https://download.visualstudio.microsoft.com/download/pr/d4c27f3a-2cee-4907-99e3-aa5abafc38c1/7b625c4ec9b77a02da8f4125737c593ca47ac34cfa840cf8acfae0b37be6e572/vs_Professional.exe"

echo Installing Visual Studio 2019 Professional 16.11.40 with selected workloads...

vs_installer.exe --quiet --wait --norestart --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional" --channelUri "https://aka.ms/vs/16/release/channel" --productKey "ENTER-YOUR-PRODUCT-KEY-HERE" --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Python --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.Data --add Microsoft.VisualStudio.Workload.LinuxDevelopment --add Microsoft.VisualStudio.Workload.NetCrossPlat --includeRecommended

echo Visual Studio 2019 Professional 16.11.40 installation complete.
pause
