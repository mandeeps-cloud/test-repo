# Step 1: Define Variables
$sourcePath = "C:\Users"
$targetPath = "D:\Users"
$backupPath = "C:\Users_Backup"
$registryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

# Step 2: Stop services that could interfere with the process
Write-Host "Stopping services that could interfere..."
Stop-Service -Name "TermService" -Force
Stop-Service -Name "ProfSvc" -Force

# Step 3: Create Backup of C:\Users
Write-Host "Backing up the original C:\Users folder..."
if (Test-Path $backupPath) {
    Write-Host "Backup folder already exists. Skipping backup."
} else {
    New-Item -Path $backupPath -ItemType Directory
    Move-Item -Path $sourcePath\* -Destination $backupPath
}

# Step 4: Move C:\Users to D:\Users
Write-Host "Moving C:\Users to D:\Users..."
if (-Not (Test-Path $targetPath)) {
    New-Item -Path $targetPath -ItemType Directory
}
Move-Item -Path $sourcePath\* -Destination $targetPath

# Step 5: Create Junction from C:\Users to D:\Users
Write-Host "Creating junction point from C:\Users to D:\Users..."
cmd /c "mklink /J $sourcePath $targetPath"

# Step 6: Update Registry to point to the new location
Write-Host "Updating registry keys for user profiles..."
Get-ChildItem -Path $registryKeyPath | ForEach-Object {
    $profilePath = (Get-ItemProperty -Path $_.PSPath).ProfileImagePath
    if ($profilePath -like "$sourcePath\*") {
        $newProfilePath = $profilePath -replace [regex]::Escape($sourcePath), $targetPath
        Set-ItemProperty -Path $_.PSPath -Name ProfileImagePath -Value $newProfilePath
        Write-Host "Updated registry key for $profilePath"
    }
}

# Step 7: Start the services again
Write-Host "Starting the services..."
Start-Service -Name "TermService"
Start-Service -Name "ProfSvc"

Write-Host "Operation complete. Please reboot the server to finalize changes."
