@echo off
setlocal

REM Define URLs for MinGW versions from SourceForge
set "mingw_13_64=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/13.1.0/mingw-w64-v13.1.0-x86_64-posix-seh.zip"
set "mingw_11_64=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/11.2.0/mingw-w64-v11.2.0-x86_64-posix-seh.zip"
set "mingw_8_64=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/8.1.0/mingw-w64-v8.1.0-x86_64-posix-seh.zip"
set "mingw_8_32=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/8.1.0/mingw-w64-v8.1.0-i686-posix-sjlj.zip"
set "mingw_7_3_32=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/7.3.0/mingw-w64-v7.3.0-i686-posix-sjlj.zip"
set "mingw_7_3_64=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/7.3.0/mingw-w64-v7.3.0-x86_64-posix-seh.zip"
set "mingw_5_3_32=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/5.3.0/mingw-w64-v5.3.0-i686-posix-sjlj.zip"
set "mingw_4_9_2_32=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/4.9.2/mingw-w64-v4.9.2-i686-posix-sjlj.zip"
set "mingw_4_9_1_32=https://sourceforge.net/projects/mingw/files/OldFiles/mingw-get-0.6.2-mingw32-beta-20131004-1-bin.zip"
set "mingw_4_8_2_32=https://sourceforge.net/projects/mingw/files/OldFiles/mingw32-gcc-g++-4.8.2-release-win32_rubenvb.7z"
set "mingw_4_8_32=https://sourceforge.net/projects/mingw/files/OldFiles/mingw32-gcc-g++-4.8.0-release-win32_rubenvb.7z"
set "mingw_4_7_32=https://sourceforge.net/projects/mingw/files/OldFiles/mingw32-gcc-g++-4.7.0-release-win32_rubenvb.7z"
set "llvm_mingw_17_64=https://github.com/mstorsjo/llvm-mingw/releases/download/20230614/llvm-mingw-20230614-ucrt-x86_64.zip"

REM Define the directory where you want to install MinGW
set "install_dir=C:\MinGW"

REM Create the installation directory if it does not exist
if not exist "%install_dir%" mkdir "%install_dir%"

REM Function to download and extract MinGW
:install_mingw
set "url=%1"
set "version=%2"
set "arch=%3"
echo Installing MinGW %version% %arch%...

REM Download the MinGW zip file
powershell -command "& {Invoke-WebRequest '%url%' -OutFile '%install_dir%\mingw-%version%-%arch%.zip'}"

REM Extract the downloaded zip file (Assuming 7-Zip is installed)
"%ProgramFiles%\7-Zip\7z.exe" x "%install_dir%\mingw-%version%-%arch%.zip" -o"%install_dir%\mingw-%version%-%arch%" -y

REM Add MinGW to PATH (permanent)
setx PATH "%PATH%;%install_dir%\mingw-%version%-%arch%\bin"

echo MinGW %version% %arch% installed successfully.

exit /b

REM Install each MinGW version
call :install_mingw "%mingw_13_64%" "13.1.0" "64-bit"
call :install_mingw "%mingw_11_64%" "11.2.0" "64-bit"
call :install_mingw "%mingw_8_64%" "8.1.0" "64-bit"
call :install_mingw "%mingw_8_32%" "8.1.0" "32-bit"
call :install_mingw "%mingw_7_3_32%" "7.3.0" "32-bit"
call :install_mingw "%mingw_7_3_64%" "7.3.0" "64-bit"
call :install_mingw "%mingw_5_3_32%" "5.3.0" "32-bit"
call :install_mingw "%mingw_4_9_2_32%" "4.9.2" "32-bit"
call :install_mingw "%mingw_4_9_1_32%" "4.9.1" "32-bit"
call :install_mingw "%mingw_4_8_2_32%" "4.8.2" "32-bit"
call :install_mingw "%mingw_4_8_32%" "4.8.0" "32-bit"
call :install_mingw "%mingw_4_7_32%" "4.7.0" "32-bit"
call :install_mingw "%llvm_mingw_17_64%" "LLVM 17.0.6" "64-bit"

echo All installations completed.
pause
