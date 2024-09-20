# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Attempting to run as administrator..."
    # Start a new process with elevated privileges
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Your script logic starts here
Write-Output "Running with administrator privileges"
@echo off
powershell.exe -ExecutionPolicy Bypass -File "C:\temp\set-no-logoff-group-policy.ps1"
