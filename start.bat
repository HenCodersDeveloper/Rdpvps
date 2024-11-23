@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server Latest Version by @HenCoders" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat >nul

REM Menambahkan pengguna HenCoders
net user HenCoders HenCoders2024 /add >nul
net localgroup administrators HenCoders /add >nul

REM Mengaktifkan akun administrator bawaan
net user administrator /active:yes >nul

REM Menonaktifkan diskperf untuk meningkatkan kinerja
diskperf -Y >nul

REM Mengaktifkan layanan Audio
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

REM Memberikan izin penuh untuk direktori Temp dan installer
ICACLS C:\Windows\Temp /grant administrators:F >nul
ICACLS C:\Windows\installer /grant administrators:F >nul

REM Mengaktifkan Remote Desktop
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes >nul

REM Memastikan Versi Windows terbaru
for /f "tokens=4-5 delims=[]. " %%i in ('ver') do set version=%%i.%%j
echo Detected Windows Version: %version%
if %version% GEQ 10.0 (
    echo Running on Windows 11 or Windows Server Latest Version.
) else (
    echo Warning: This script is optimized for Windows Server 2022 or newer.
)

REM Informasi Login
echo RDP setup completed successfully! Use the following credentials to log in:
echo Username: HenCoders
echo Password: HenCoders2024
echo Please wait for the RDP session to initialize...

REM Menghubungkan ke Cloudflare Tunnel
echo Starting Cloudflare Tunnel...
cd /d C:\cloudflared
start cloudflared.exe tunnel --config C:\cloudflared\config.yml run

REM Tunggu beberapa detik untuk memastikan sistem siap
ping -n 10 127.0.0.1 >nul