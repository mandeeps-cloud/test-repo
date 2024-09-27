@echo off
:: Create a directory in ProgramData for Scoop (common for all users)
set "SCOOP_GLOBAL=C:\ProgramData\Scoop"
if not exist "%SCOOP_GLOBAL%" (
    mkdir "%SCOOP_GLOBAL%"
)

:: Set system-wide execution policy for PowerShell
powershell -Command "Set-ExecutionPolicy RemoteSigned -scope LocalMachine -Force"

:: Install Scoop to the global directory
powershell -Command "iwr -useb get.scoop.sh | iex"
powershell -Command "[environment]::SetEnvironmentVariable('SCOOP','%SCOOP_GLOBAL%','Machine')"
powershell -Command "[environment]::SetEnvironmentVariable('PATH', [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';%SCOOP_GLOBAL%\shims', 'Machine')"

:: Copy default Scoop installation path from user profile to ProgramData
powershell -Command "$globalDir='%SCOOP_GLOBAL%'; $sourceDir='$env:USERPROFILE\scoop'; if(Test-Path $sourceDir) {Copy-Item -Recurse -Force -Path $sourceDir\* -Destination $globalDir}"

:: Install global apps in the ProgramData directory
setx SCOOP_GLOBAL "%SCOOP_GLOBAL%" /M

echo Scoop installed for all users at %SCOOP_GLOBAL%
pause