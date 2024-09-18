@echo off
:: Visual Studio 2019 Professional 16.11.40 installer batch script
:: This script installs Visual Studio 2019 Professional version 16.11.40 with specific workloads

echo Downloading Visual Studio Installer for version 16.11.40...
curl -L -o vs_installer.exe "https://download.visualstudio.microsoft.com/download/pr/2367f40f-504a-4264-96c2-1d48a981fdc9/d48ae8df989be8e28bca2324e1567ebd/vs_professional__541296787.1636728125.exe"

echo Installing Visual Studio 2019 Professional 16.11.40 with selected workloads...

vs_installer.exe --quiet --wait --norestart --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional" --channelUri "https://aka.ms/vs/16/release/channel" --productKey "ENTER-YOUR-PRODUCT-KEY-HERE" --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Python --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.Data --add Microsoft.VisualStudio.Workload.LinuxDevelopment --add Microsoft.VisualStudio.Workload.NetCrossPlat --includeRecommended

echo Visual Studio 2019 Professional 16.11.40 installation complete.
pause
