# Check if WSL is enabled, if not, enable WSL
$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wslFeature.State -ne "Enabled") {
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
}

# Set WSL default version to 1
wsl --set-default-version 1

# Check if Ubuntu 22.04 is installed, if not, download and install it
$ubuntuInstalled = wsl -l | Select-String -Pattern "Ubuntu-22.04"
if (-not $ubuntuInstalled) {
    # Download Ubuntu 22.04 for WSL
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile "$env:TEMP\Ubuntu2204.appx" -UseBasicParsing

    # Install the Ubuntu 22.04 WSL distribution
    Add-AppxPackage "$env:TEMP\Ubuntu2204.appx"
}

# Confirm Installation
$ubuntuInstalled = wsl -l | Select-String -Pattern "Ubuntu-22.04"
if ($ubuntuInstalled) {
    Write-Host "Ubuntu 22.04 has been successfully installed for WSL1."
} else {
    Write-Host "Ubuntu 22.04 installation failed or is already installed."
}
