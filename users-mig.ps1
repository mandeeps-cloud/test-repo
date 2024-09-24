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

# Rename the old C:\Users folder for backup purposes
Write-Host "Renaming C:\Users to C:\Users_old"
Rename-Item -Path "C:\Users" -NewName "C:\Users_old" -Force

# Step 3: Update the registry to point to the new location
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

# Step 4: Restart the VM to apply changes
Write-Host "Migration complete. Rebooting the system to apply changes..."
Restart-Computer
