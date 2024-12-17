@echo off
setlocal
title AutoMount Disabler/Enabler
echo Program Name: AutoMount Disabler/Enabler
echo Version: 1.2.16
echo Developer: @YonatanReuvenIsraeli
echo Website: https://www.yonatanreuvenisraeli.dev
echo License: GNU General Public License v3.0
net session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
goto "Start"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"Start"
echo.
echo [1] Disable auto-mounting of new drives.
echo [2] Enable auto-mounting of new drives. (Windows Default)
echo [3] Exit
echo.
set AutoMount=
set /p AutoMount="What do you want to do? "
if /i "%AutoMount%"=="1" goto "DiskPartSet"
if /i "%AutoMount%"=="2" goto "DiskPartSet"
if /i "%AutoMount%"=="3" goto "Close"
echo Invalid syntax!
goto "Start"

:"DiskPartSet"
set DiskPart=
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"

:"1"
if exist "%cd%\DiskPart.txt" goto "DiskPartExist"
echo.
echo Disabling auto-mounting of new drives.
(echo automount disable) > "%cd%\DiskPart.txt"
(echo automount scrub) >> "%cd%\DiskPart.txt"
(echo exit) >> "%cd%\DiskPart.txt"
DiskPart /s "%cd%\DiskPart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "DiskPartError"
del "%cd%\DiskPart.txt" /f /q > nul 2>&1
echo Auto-mounting of new drives has been disabled.
if /i "%DiskPart%"=="True" goto "DiskPartDone"
goto "Start"

:"2"
if exist "%cd%\DiskPart.txt" goto "DiskPartExist"
echo.
echo Enabling auto-mounting of new drives.
(echo automount enable) > "%cd%\DiskPart.txt"
(echo exit) >> "%cd%\DiskPart.txt"
DiskPart /s "%cd%\DiskPart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "DiskPartError"
del "%cd%\DiskPart.txt" /f /q > nul 2>&1
echo Auto-mounting of new drives has been enabled.
if /i "%DiskPart%"=="True" goto "DiskPartDone"
goto "Start"

:"DiskPartExist"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "%cd%\DiskPart.txt" in order for this batch file to proceed. "%cd%\DiskPart.txt" is not a system file. Press any key to continue when "%cd%\DiskPart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"

:"DiskPartError"
del "%cd%\DiskPart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"

:"DiskPartDone"
echo.
echo You can now rename or move back the file back to "%cd%\DiskPart.txt".
goto "Start"

:"Close"
endlocal
exit
