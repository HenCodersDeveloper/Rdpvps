@echo off
:begin
echo ====================================================
echo           RDP BERHASIL DIBUAT!
echo ====================================================
tasklist | find /i "cloudflared.exe" >nul && goto check || (
    echo Gagal mendapatkan tunnel Cloudflare.
    echo Pastikan Cloudflare Tunnel sudah berjalan.
    echo Mungkin VM sebelumnya masih berjalan:
    echo Periksa status tunnel di dashboard Cloudflare.
    ping 127.0.0.1 >nul
    exit
)
:check
ping 127.0.0.1 >nul
cls
echo ====================================================
echo           RDP BERHASIL DIBUAT!
echo  Silakan periksa Cloudflare Tunnel untuk informasi tunnel.
echo ====================================================
goto check