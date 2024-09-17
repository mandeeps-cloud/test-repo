# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an Administrator!" -ForegroundColor Red
    exit
}

# Install Chocolatey if not installed
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Install Visual Studio 2019 Professional using Chocolatey
Write-Host "Installing Visual Studio 2019 Professional..."
choco install visualstudio2019professional --version=16.11.33 -y

# Wait for Visual Studio installation to complete
Write-Host "Waiting for Visual Studio installation to complete..."
Start-Sleep -Seconds 60  # Adjust this based on expected installation time

# Define Visual Studio Installer CLI path
$vsInstallerPath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
if (-Not (Test-Path $vsInstallerPath)) {
    Write-Host "Visual Studio Installer not found. Please verify the installation."
    exit
}

# Install required workloads and components via Visual Studio Installer CLI
Write-Host "Installing required Visual Studio workloads and components..."

& $vsInstallerPath modify --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional" `
--add Microsoft.VisualStudio.Workload.ManagedDesktop `
--add Microsoft.VisualStudio.Workload.NetWeb `
--add Microsoft.VisualStudio.Workload.Azure `
--add Microsoft.VisualStudio.Workload.VisualStudioExtension `
--add Microsoft.VisualStudio.Workload.NativeDesktop `
--add Microsoft.VisualStudio.Workload.Python `
--add Microsoft.VisualStudio.Workload.Data `
--add Microsoft.Net.Component.4.8.SDK `
--add Microsoft.Net.Component.4.8.TargetingPack `
--add Microsoft.VisualStudio.Component.VC.ATL `
--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
--add Microsoft.Component.MSBuild `
--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites `
--add Microsoft.VisualStudio.Component.TestTools.BuildTools `
--add Microsoft.VisualStudio.Component.TypeScript.3.6 `
--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator `
--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator

# Output final message
Write-Host "Visual Studio 2019 Professional and required workloads, components installed successfully!" -ForegroundColor Green

# Final reminder for user to verify installation
Write-Host "Please launch Visual Studio to verify that all required components have been installed."
