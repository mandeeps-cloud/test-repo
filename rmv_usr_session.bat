@echo off
REM Set time limit for disconnected session (0 means no timeout)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxIdleTime /t REG_DWORD /d 0 /f

REM Set time limit for active sessions (0 means no timeout)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxDisconnectionTime /t REG_DWORD /d 0 /f

REM Set time limit for logoff after disconnection (0 means no timeout)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxConnectionTime /t REG_DWORD /d 0 /f

echo Session timeout settings updated successfully
