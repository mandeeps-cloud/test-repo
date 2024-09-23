@echo off

:: Check if Chocolatey is installed
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Installing Chocolatey...
    :: Install Chocolatey
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
)

:: Install OpenJDK 8u292 via Chocolatey
echo Installing OpenJDK 8u292...
choco install openjdk8 --version=8.0.292 -y

:: Wait for the installation to finish
timeout /t 10 /nobreak >nul

:: Set JAVA_HOME environment variable
set JDK_PATH="C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot"
echo Setting JAVA_HOME to %JDK_PATH%
setx JAVA_HOME "%JDK_PATH%" /M

:: Add OpenJDK bin directory to system PATH
echo Adding OpenJDK bin to PATH...
for /f "tokens=*" %%i in ('powershell -Command "[System.Environment]::GetEnvironmentVariable('Path', 'Machine')"') do set PATH=%%i
setx Path "%PATH%;%JDK_PATH%\bin" /M

echo OpenJDK 8u292 has been installed and JAVA_HOME is set.

:: Verify the installation
java -version
if %errorlevel% neq 0 (
    echo Java installation failed or JAVA_HOME is not set correctly.
) else (
    echo Java installation successful.
)

pause
