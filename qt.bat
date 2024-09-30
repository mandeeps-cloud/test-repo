@echo off
setlocal

:: Set variables
set QT_INSTALLER_URL=https://download.qt.io/official_releases/qt/6.7/6.7.2/qt-opensource-windows-x86-6.7.2.exe
set QT_INSTALLER_NAME=qt-opensource-windows-x86-6.7.2.exe
set INSTALL_DIR=C:\Qt
set SCRIPT_PATH=%TEMP%\qt_install_script.qs

:: Download Qt installer
echo Downloading Qt 6.7.2 Installer...
powershell -Command "Invoke-WebRequest -Uri %QT_INSTALLER_URL% -OutFile %QT_INSTALLER_NAME%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download the Qt installer. Exiting.
    exit /b 1
)

:: Create the silent installation script
echo Creating the silent installation script...
(
echo function Controller() {
echo     installer.autoAcceptLicense = true;
echo     installer.setInstallationDirectory("%INSTALL_DIR%");
echo     installer.addOperation("ComponentSelection", "qt.qt6.%ARCHITECTURE%.6.7.2");
echo     installer.setRunMode(installer.RunModeSilent);
echo }
) > %SCRIPT_PATH%

:: Run the Qt installer silently
echo Running the Qt installer silently...
start /wait %QT_INSTALLER_NAME% --silent --script %SCRIPT_PATH%

:: Check if Qt was installed successfully
if exist "%INSTALL_DIR%\6.7.2" (
    echo Qt 6.7.2 installation completed successfully.
) else (
    echo Qt 6.7.2 installation failed.
    exit /b 1
)

:: Cleanup
echo Cleaning up...
del %QT_INSTALLER_NAME%
del %SCRIPT_PATH%

echo Installation completed.

endlocal
exit /b 0