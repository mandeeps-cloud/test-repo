@echo off

:: Change Command Prompt Font to Consolas and size to 16
reg add "HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe" /v "FaceName" /t REG_SZ /d "Consolas" /f
reg add "HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe" /v "FontSize" /t REG_DWORD /d 0x00100000 /f

:: Change Command Prompt Color Scheme to Black Background and Light Green Text
reg add "HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe" /v "ColorTable00" /t REG_DWORD /d 0x00000000 /f
reg add "HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe" /v "ColorTable10" /t REG_DWORD /d 0x00A8FF00 /f

:: Refresh the Command Prompt to apply changes
exit
