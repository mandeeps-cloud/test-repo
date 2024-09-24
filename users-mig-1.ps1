# Ensure the script is running with administrator privileges
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "This script requires Administrator privileges. Please re-run as Administrator."
        Exit
    }
}

# Call the function to test for admin privileges
Test-Admin

# Step 1: Create a temporary admin account
$TempAdminUsername = "TempAdmin"
$TempAdminPassword = "Password123" | ConvertTo-SecureString -AsPlainText -Force

# Check if TempAdmin already exists
if (-not (Get-LocalUser -Name $TempAdminUsername -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name $TempAdminUsername -Password $TempAdminPassword -PasswordNeverExpires -AccountNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $TempAdminUsername
    Write-Host "Temporary admin account created."
} else {
    Write-Host "Temporary admin account already exists."
}

# Step 2: Move the C:\Users folder to D:\Users
$source = "C:\Users"
$destination = "D:\Users"

# Ensure D:\Users folder exists
if (-not (Test-Path $destination)) {
    New-Item -Path $destination -ItemType Directory
}

# Using Robocopy to copy data from C:\Users to D:\Users excluding junction points (/XJ)
Write-Host "Copying user profiles from C:\Users to D:\Users..."
Start-Process -FilePath "robocopy" -ArgumentList "$source $destination /E /COPYALL /R:3 /W:5 /XJ /LOG:C:\robocopy_log.txt" -Wait -NoNewWindow

if ($LASTEXITCODE -le 3) {
    Write-Host "User profiles copied successfully."
} else {
    Write-Host "Error during copy. Please check C:\robocopy_log.txt for more details."
    Exit
}

# Step 3: Rename the old C:\Users folder for backup purposes
$backupFolder = "C:\Users_old"

# Ensure there is no existing folder with the same name
if (Test-Path $backupFolder) {
    Write-Host "$backupFolder already exists. Deleting it before renaming."
    Remove-Item -Recurse -Force $backupFolder
}

Write-Host "Renaming C:\Users to C:\Users_old"
try {
    Rename-Item -Path "C:\Users" -NewName "C:\Users_old" -Force
    Write-Host "Renaming successful."
} catch {
    Write-Host "Renaming failed. Retrying in Safe Mode might help if files are in use."
    Exit
}

# Step 4: Update the registry to point to the new location
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

# Change the ProfilesDirectory value
Write-Host "Updating registry for profile paths..."
Set-ItemProperty -Path $regPath -Name "ProfilesDirectory" -Value "D:\Users"

# Update individual user profiles
Get-ChildItem -Path $regPath | ForEach-Object {
    $profilePath = (Get-ItemProperty -Path $_.PSPath).ProfileImagePath
    if ($profilePath -like "C:\Users\*") {
        $newProfilePath = $profilePath -replace "C:\\Users", "D:\\Users"
        Set-ItemProperty -Path $_.PSPath -Name "ProfileImagePath" -Value $newProfilePath
        Write-Host "Updated user profile path from $profilePath to $newProfilePath"
    }
}

# Step 5: Restart the VM to apply changes
Write-Host "Migration complete. Rebooting the system to apply changes..."
Restart-Computer
