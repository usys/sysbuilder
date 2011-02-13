@echo off
rem -------------------------------------------------------------------------
rem MODBOOT, AUTOEXEC.BAT
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------
rem
set prompt=$p$g
if "%config%" == "CLEAN" goto _abort
if "%config%" == "7" goto _abort

REM echo MODBOOT v2.7, Bart's Modular Boot Disk, http://www.nu2.nu/bootdisk/modboot/
REM echo Copyright (c) 2002 Bart Lagerweij. All rights reserved.
REM echo This program is free software. Use and/or distribute it under the terms
REM echo of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
REM echo.

rem Detect the source drive
set srcdrv=
if not exist \bin\bootdrv.com goto _nobdrv
\bin\bootdrv.com
rem bennylevel check? No! I think not supported by freedos
if errorlevel 0 set srcdrv=a:
if errorlevel 1 set srcdrv=b:
if errorlevel 2 set srcdrv=c:
if errorlevel 3 set srcdrv=d:
if errorlevel 4 set srcdrv=e:
if errorlevel 5 set srcdrv=f:
if errorlevel 6 set srcdrv=g:
if errorlevel 7 set srcdrv=h:
if errorlevel 8 set srcdrv=i:
if errorlevel 9 set srcdrv=j:
:_nobdrv
rem if empty assume "a:"
if "%srcdrv%" == "" set srcdrv=a:
path %srcdrv%\bin

if exist %srcdrv%\diskid.txt type diskid.txt
echo.
call message "Booted drive is %srcdrv%"

if exist \kernel.sys set os=fd
if not exist \bin\smartdrv.exe goto _nosdrv
call try LoadHigh "Loading smartdrv.exe" \bin\smartdrv.exe 
:_nosdrv
if not exist \bin\fdcache.exe goto _nofdc
call try LoadHigh "Loading fdcache.exe" \bin\fdcache.exe 
:_nofdc


:_goram
if X == X%ramdrv% call bin\_ramdrv.bat 32768
if "%ramdrv%"=="" goto _abort
if exist %ramdrv%\bin\_unpack.bat goto _skipcp
call message "Setting up Ramdisk at drive %ramdrv%"
:_ramok
rem
md %ramdrv%\bin
md %ramdrv%\tmp
set temp=%ramdrv%\tmp
set tmp=%ramdrv%\tmp

call message "Copying some files to ramdisk..."
copy %srcdrv%\command.com %ramdrv%\bin>NUL
if not exist %ramdrv%\bin\command.com goto _abort
set comspec=%ramdrv%\bin\command.com
for %%i in (%srcdrv%\bin\*.exe %srcdrv%\bin\*.bat %srcdrv%\bin\*.com) do copy %%i %ramdrv%\bin>NUL

:_skipcp
set path=%ramdrv%\bin;%ramdrv%\
rem check for smartdrv.lha
if not exist %srcdrv%\bin\smartdrv.lha goto _nosdrv2
call %srcdrv%\bin\_unpack.bat %srcdrv%\bin\smartdrv.lha %ramdrv%\
if exist %ramdrv%\bin\smartdrv.exe call try LOADHIGH "Loading smartdrv" ramdrv%\bin\smartdrv.exe
if exist %ramdrv%\smartdrv.exe call try LOADHIGH "Loading smartdrv" %ramdrv%\smartdrv.exe
:_nosdrv2
rem check if modboot.lha exists
if exist %srcdrv%\bin\modboot.lha goto _modbcabok
echo.
call message ERROR: Missing file "%srcdrv%\bin\modboot.lha"
goto _abort

:_modbcabok
call %srcdrv%\bin\_unpack.bat %srcdrv%\bin\modboot.lha %ramdrv%\
if errorlevel 1 goto _unpackerr
if exist %tmp%\extract.out del %tmp%\extract.out
if exist %ramdrv%\bin\modboot.bat goto _modboot
call message ERROR: Missing file "%ramdrv%\bin\modboot.bat"
goto _abort
:_unpackerr
if exist %tmp%\try.out type %tmp%\try.out
if exist %tmp%\try.out del %tmp%\try.out
if exist %tmp%\extract.out type %tmp%\extract.out
if exist %tmp%\extract.out del %tmp%\extract.out
echo.
call message ERROR: while unpacking "%srcdrv%\bin\modboot.lha"
goto _abort
:_modboot
rem set CWD to ramdisk
%ramdrv%
cd \
call %ramdrv%\bin\modboot.bat
rem should not get here
:_abort
if exist %srcdrv%\custom\autoexec.bat call %srcdrv%\custom\autoexec.bat 
if exist %srcdrv%\bin\_result.bat	call %srcdrv%\bin\_result.bat
rem flow into "_end"
:_end
