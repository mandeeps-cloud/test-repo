@echo off
setlocal enabledelayedexpansion

:: Variables
set oldUserProfilePath=C:\Users
set newUserProfilePath=D:\Users
set backupUserProfilePath=D:\Backup_Users

:: Step 1: Create the backup directory if it doesn't exist
if not exist "%backupUserProfilePath%" (
    mkdir "%backupUserProfilePath%"
    echo Created backup user profile directory at %backupUserProfilePath%
) else (
    echo Backup directory %backupUserProfilePath% already exists
)

:: Step 2: Backup existing user profiles from C:\Users to D:\Backup_Users
for /d %%G in (%oldUserProfilePath%\*) do (
    set "source=%%G"
    set "destination=!source:%oldUserProfilePath%=%backupUserProfilePath%!"
    if not exist "!destination!" (
        echo Backing up !source! to !destination!
        xcopy /E /I /H /K /O /X /Y "!source!" "!destination!" >nul
        echo Backed up profile from !source! to !destination!
    ) else (
        echo Backup for !destination! already exists
    )
)

:: Step 3: Create the new User Profiles directory in D: if not already present
if not exist "%newUserProfilePath%" (
    mkdir "%newUserProfilePath%"
    echo Created new user profile directory at %newUserProfilePath%
) else (
    echo Directory %newUserProfilePath% already exists
)

:: Step 4: Move existing user profiles from C: to D:
for /d %%G in (%oldUserProfilePath%\*) do (
    set "source=%%G"
    set "destination=!source:%oldUserProfilePath%=%newUserProfilePath%!"
    if not exist "!destination!" (
        echo Moving !source! to !destination!
        xcopy /E /I /H /K /O /X /Y "!source!" "!destination!" >nul
        echo Moved profile from !source! to !destination!
    ) else (
        echo Profile directory !destination! already exists
    )
)

:: Step 5: Update the registry to point to the new user profile location for new users
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /v ProfilesDirectory /t REG_EXPAND_SZ /d "%newUserProfilePath%" /f
echo Updated the registry for default profile location to %newUserProfilePath%

:: Step 6: Create a symbolic link for backward compatibility with C:\Users
if not exist "%oldUserProfilePath%" (
    mklink /J "%oldUserProfilePath%" "%newUserProfilePath%"
    echo Created symbolic link from %oldUserProfilePath% to %newUserProfilePath%
) else (
    echo Symbolic link or directory %oldUserProfilePath% already exists
)

:: Step 7: Set default profile paths in the registry for new user creation
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\Default" /v ProfileImagePath /t REG_EXPAND_SZ /d "%newUserProfilePath%\Default" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-18" /v ProfileImagePath /t REG_EXPAND_SZ /d "%newUserProfilePath%\Default" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-19" /v ProfileImagePath /t REG_EXPAND_SZ /d "%newUserProfilePath%\Default" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-20" /v ProfileImagePath /t REG_EXPAND_SZ /d "%newUserProfilePath%\Default" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\Public" /v ProfileImagePath /t REG_EXPAND_SZ /d "%newUserProfilePath%\Public" /f
echo Updated the default profile and public profile paths

:: Step 8: Reboot the system to apply changes
echo System will now reboot to apply changes.
shutdown /r /t 0
