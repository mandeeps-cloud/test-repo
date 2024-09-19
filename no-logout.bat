@echo off
REM Batch script to modify registry keys for no timed logout

REM Remove specific registry entries
reg delete "HKLM\Software\Policies\Microsoft\Windows NT\Reliability" /v ShutdownReasonUI /f
reg delete "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v RemoteAppLogoffTimeLimit /f

REM Add or modify necessary registry entries for no logout
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Reliability" /v ShutdownReasonOn /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v MaxConnectionTime /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v MaxDisconnectionTime /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v MaxIdleTime /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v MaxIdleTime /t REG_DWORD /d 0 /f

echo Registry changes applied successfully.
