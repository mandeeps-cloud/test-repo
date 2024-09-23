# Set PYTHON_HOME environment variable
$env:PYTHON_HOME = "C:\python310"
[System.Environment]::SetEnvironmentVariable("PYTHON_HOME", $env:PYTHON_HOME, "Machine")

# Verify PYTHON_HOME is set
Write-Host "PYTHON_HOME is set to $env:PYTHON_HOME"

# Install python 3.10 via Chocolatey
$pythonInstallDir = "C:\python310"
Write-Host "Installing Python 3.10..."
choco install python --version=3.10.0 --installargs "'/quiet InstallAllUsers=1 TargetDir=$pythonInstallDir'" -y

# Verify Python Installation Path
$pythonExePath = "$pythonInstallDir\python.exe"
if (-Not (Test-Path $pythonExePath)) {
    Write-Host "Python installation failed"
    exit 1
} else {
    Write-Host "Python Installed Successfully at $pythonInstallDir"
}

# Upgrade pip to the Specified Version
Write-Host "Upgrading pip to version 21.3.1..."
& $pythonExePath -m pip install --upgrade pip==21.3.1

# Install specific packages with pip
$packages = @(
    "aenum==3.1.0",
    "coreutils==0.1.6",
    "dbf==0.99.1",
    "MarkdownPP==1.5.1",
    "PTable==0.9.2",
    "setuptools==49.2.1",
    "simplejson==3.17.2",
    "watchdog==2.1.2",
    "wheel==0.36.2",
    "geopandas==1.0.1"
)

foreach ($package in $packages) {
    Write-Host "Installing package $package..."
    & $pythonExePath -m pip install $package
}

Write-Host "All packages installed successfully."
