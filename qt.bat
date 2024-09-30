@echo off
setlocal

:: Set variables
set QT_INSTALLER_URL=https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-online.exe
set QT_INSTALLER_NAME=qt-unified-windows-x64-online.exe
set INSTALL_DIR=C:\Qt
set SCRIPT_PATH=%TEMP%\qt_install_script.qs
set QT_VERSION=6.7.2
set QT_COMPONENT=qt.qt6.672.win64_msvc2019_64

:: Download the Qt Online Installer
echo Downloading Qt Online Installer...
powershell -Command "Invoke-WebRequest -Uri %QT_INSTALLER_URL% -OutFile %QT_INSTALLER_NAME%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download the Qt Online Installer. Exiting.
    exit /b 1
)

:: Create the silent installation script
echo Creating the silent installation script...
(
echo function Controller() {
echo     installer.autoAcceptLicense = true;
echo     installer.setInstallationDirectory("%INSTALL_DIR%");
echo     installer.addOperation("ComponentSelection", "%QT_COMPONENT%");
echo     installer.setRunMode(installer.RunModeSilent);
echo }
) > %SCRIPT_PATH%

:: Run the Qt installer silently
echo Running the Qt Online Installer silently...
start /wait %QT_INSTALLER_NAME% --silent --platform minimal --script %SCRIPT_PATH%

:: Check if Qt was installed successfully
if exist "%INSTALL_DIR%\%QT_VERSION%" (
    echo Qt %QT_VERSION% installation completed successfully.
) else (
    echo Qt %QT_VERSION% installation failed.
    exit /b 1
)

:: Cleanup
echo Cleaning up...
del %QT_INSTALLER_NAME%
del %SCRIPT_PATH%

echo Installation completed.

endlocal
exit /b 0