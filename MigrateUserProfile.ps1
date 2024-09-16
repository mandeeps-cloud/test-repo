# Define variables for source and destination servers, user profile, and program settings
$SourceServer = "SourceServerName"
$DestinationServer = "DestinationServerName"
$UserProfile = "username"  # User profile to migrate (the folder name in C:\Users)
$UserSID = (New-Object System.Security.Principal.NTAccount($UserProfile)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Define paths for user profile, program settings, and policies
$SourceProfilePath = "\\$SourceServer\C$\Users\$UserProfile"
$DestinationProfilePath = "\\$DestinationServer\C$\Users\$UserProfile"
$SourceProgramDataPath = "\\$SourceServer\C$\ProgramData"
$DestinationProgramDataPath = "\\$DestinationServer\C$\ProgramData"
$SourcePolicyPath = "\\$SourceServer\C$\Windows\System32\GroupPolicy"
$DestinationPolicyPath = "\\$DestinationServer\C$\Windows\System32\GroupPolicy"

# Step 1: Copy the user profile using robocopy (including AppData)
Write-Host "Starting to copy user profile from $SourceServer to $DestinationServer..."
$robocopyCmd = robocopy $SourceProfilePath $DestinationProfilePath /MIR /COPYALL /R:5 /W:5 /ZB /SEC
Invoke-Expression $robocopyCmd

# Check for robocopy success
if ($LASTEXITCODE -le 1) {
    Write-Host "Profile copy completed successfully."
} else {
    Write-Host "Profile copy failed with exit code: $LASTEXITCODE"
    exit 1
}

# Step 2: Copy shared application settings from ProgramData using robocopy
Write-Host "Starting to copy ProgramData (shared application settings)..."
$robocopyCmd = robocopy $SourceProgramDataPath $DestinationProgramDataPath /MIR /COPYALL /R:5 /W:5 /ZB /SEC
Invoke-Expression $robocopyCmd

# Check for robocopy success
if ($LASTEXITCODE -le 1) {
    Write-Host "ProgramData copy completed successfully."
} else {
    Write-Host "ProgramData copy failed with exit code: $LASTEXITCODE"
    exit 1
}

# Step 3: Copy Group Policy files for system-wide policies
Write-Host "Starting to copy Group Policy files..."
$robocopyCmd = robocopy $SourcePolicyPath $DestinationPolicyPath /MIR /COPYALL /R:5 /W:5 /ZB /SEC
Invoke-Expression $robocopyCmd

# Check for robocopy success
if ($LASTEXITCODE -le 1) {
    Write-Host "Group Policy copy completed successfully."
} else {
    Write-Host "Group Policy copy failed with exit code: $LASTEXITCODE"
    exit 1
}

# Step 4: Export user-specific registry settings (HKEY_CURRENT_USER) from the source server
Write-Host "Exporting user-specific registry settings..."
$RegExportFile = "C:\Temp\$UserProfile-registry-export.reg"
$regExportCmd = "reg.exe save HKEY_USERS\$UserSID $RegExportFile"
Invoke-Command -ComputerName $SourceServer -ScriptBlock { Invoke-Expression $using:regExportCmd }

# Step 5: Import user-specific registry settings to the destination server
Write-Host "Importing user-specific registry settings..."
$regImportCmd = "reg.exe load HKEY_USERS\$UserSID $RegExportFile"
Invoke-Command -ComputerName $DestinationServer -ScriptBlock { Invoke-Expression $using:regImportCmd }

# Step 6: Export system-wide registry settings (HKEY_LOCAL_MACHINE and other relevant keys) from the source server
Write-Host "Exporting system-wide registry settings..."
$SystemRegExportFile = "C:\Temp\system-registry-export.reg"
$regExportCmd = "reg.exe export HKEY_LOCAL_MACHINE\SOFTWARE $SystemRegExportFile /y"
Invoke-Command -ComputerName $SourceServer -ScriptBlock { Invoke-Expression $using:regExportCmd }

# Step 7: Import system-wide registry settings to the destination server
Write-Host "Importing system-wide registry settings..."
$regImportCmd = "reg.exe import $SystemRegExportFile"
Invoke-Command -ComputerName $DestinationServer -ScriptBlock { Invoke-Expression $using:regImportCmd }

# Step 8: Set the correct permissions on the user profile folder
Write-Host "Setting permissions for the user profile on the destination server..."
icacls $DestinationProfilePath /grant "$UserSID:(OI)(CI)F" /T

# Check for icacls success
if ($LASTEXITCODE -eq 0) {
    Write-Host "Permissions successfully assigned to $UserProfile."
} else {
    Write-Host "Failed to assign permissions with exit code: $LASTEXITCODE"
    exit 1
}

# Optional: Update the registry profile location if necessary
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$UserSIDPath = Get-ChildItem -Path $RegPath | Where-Object { $_.Name -like "*$UserSID*" }

if ($UserSIDPath) {
    Set-ItemProperty -Path $UserSIDPath.PSPath -Name "ProfileImagePath" -Value "C:\Users\$UserProfile"
    Write-Host "Registry updated for $UserProfile."
} else {
    Write-Host "No registry key found for $UserProfile."
}

Write-Host "User profile migration with application settings and system-wide policies completed successfully!"
