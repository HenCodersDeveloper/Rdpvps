@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Memeriksa akses administrator...
    goto UACPrompt
) else ( goto AdminAccessGranted )

:UACPrompt
echo Mengaktifkan akses Administrator...
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:AdminAccessGranted
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

:: Mengatur nama komputer menjadi 'HenRDP'
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName /v ComputerName /t REG_SZ /d HenRDP /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName /v ComputerName /t REG_SZ /d HenRDP /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v Hostname /t REG_SZ /d HenRDP /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "AD Host" /t REG_SZ /d HenRDP /f

:: Menambahkan informasi OEM
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Manufacturer /t REG_SZ /d "HenCoders" /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Model /t REG_SZ /d "HenCoders Virtual Machine" /f
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportURL /t REG_SZ /d "https://github.com/HenCodersOfficial/HenRDP/issues" /f

:: Menyesuaikan ikon taskbar menjadi kecil
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f

:: Mengubah wallpaper
echo Mengganti wallpaper...
copy "%~dp0HenCoders.png" C:\Users\Public\Desktop\HenCoders.png >nul
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper -Value 'C:\Users\Public\Desktop\HenCoders.png'"
powershell -Command "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters"

:: Memulai ulang explorer
echo Mengatur konfigurasi selesai! Memulai ulang explorer...
start explorer.exe