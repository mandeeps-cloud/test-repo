@echo off
setlocal enabledelayedexpansion

:: Create the base MinGW directory
set MINGW_DIR=C:\MinGW
if not exist %MINGW_DIR% mkdir %MINGW_DIR%

:: Function to download and extract MinGW
:: Arguments: 1 = MinGW version (folder name), 2 = download URL, 3 = architecture (x86 or x64)
:download_and_extract_mingw
    set VERSION=%1
    set URL=%2
    set ARCH=%3
    set TARGET_DIR=%MINGW_DIR%\%VERSION%

    echo Downloading MinGW %VERSION% for %ARCH%...
    curl -L -o %VERSION%.zip %URL%
    if not exist %VERSION%.zip (
        echo Error: Failed to download MinGW version %VERSION%.
        goto :eof
    )

    echo Extracting MinGW %VERSION%...
    mkdir %TARGET_DIR%
    
    :: Use PowerShell to extract the .zip file
    powershell -command "Expand-Archive -Path '%CD%\%VERSION%.zip' -DestinationPath '%TARGET_DIR%'"

    if not exist %TARGET_DIR% (
        echo Error: Failed to extract MinGW version %VERSION%.
        goto :eof
    )

    del /Q %VERSION%.zip

    echo Adding MinGW %VERSION% to PATH...
    setx PATH "%TARGET_DIR%\bin;%PATH%"

    goto :eof

:: Download and install each MinGW version

:: MinGW 13.1.0 64-bit
call :download_and_extract_mingw "mingw1310" "https://winlibs.com/downloads/mingw-13.1.0-64bit.zip" "x64"

:: MinGW 11.2.0 64-bit
call :download_and_extract_mingw "mingw1120" "https://sourceforge.net/projects/mingw-w64/files/mingw-w64-release/11.2.0/x86_64-posix-seh.zip" "x64"

:: MinGW 8.1.0 64-bit
call :download_and_extract_mingw "mingw810_64" "https://sourceforge.net/projects/mingw-w64/files/mingw-w64-release/8.1.0/x86_64-posix-seh.zip" "x64"

:: MinGW 8.1.0 32-bit
call :download_and_extract_mingw "mingw810_32" "https://sourceforge.net/projects/mingw-w64/files/mingw-w64-release/8.1.0/i686-posix-dwarf.zip" "x86"

:: MinGW 7.3.0 32-bit
call :download_and_extract_mingw "mingw730_32" "https://sourceforge.net/projects/mingw-w64/files/mingw-w64-release/7.3.0/i686-posix-dwarf.zip" "x86"

:: MinGW 7.3.0 64-bit
call :download_and_extract_mingw "mingw730_64" "https://sourceforge.net/projects/mingw-w64/files/mingw-w64-release/7.3.0/x86_64-posix-seh.zip" "x64"

:: MinGW 5.3.0 32-bit
call :download_and_extract_mingw "mingw530_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version5/gcc-5.3.0/32-bit/mingw-get-setup.exe/download" "x86"

:: MinGW 4.9.2 32-bit
call :download_and_extract_mingw "mingw492_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/gcc-4.9.2/32-bit/mingw-get-setup.exe/download" "x86"

:: MinGW 4.9.1 32-bit
call :download_and_extract_mingw "mingw491_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/gcc-4.9.1/32-bit/mingw-get-setup.exe/download" "x86"

:: MinGW 4.8.2 32-bit
call :download_and_extract_mingw "mingw482_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/gcc-4.8.2/32-bit/mingw-get-setup.exe/download" "x86"

:: MinGW 4.8 32-bit
call :download_and_extract_mingw "mingw48_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/gcc-4.8/32-bit/mingw-get-setup.exe/download" "x86"

:: MinGW 4.7 32-bit
call :download_and_extract_mingw "mingw47_32" "https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/gcc-4.7/32-bit/mingw-get-setup.exe/download" "x86"

:: LLVM-MinGW 17.06 64-bit
call :download_and_extract_mingw "llvm_mingw1706_64" "https://github.com/mstorsjo/llvm-mingw/releases/download/20230617/llvm-mingw-20230617-ucrt-x86_64.zip" "x64"

echo All MinGW versions installed successfully!

pause
