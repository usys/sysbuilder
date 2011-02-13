@echo off
rem -------------------------------------------------------------------------
rem UNPACK.BAT, Copyright (C) by Bart Lagerweij
rem This program is free software, but WITHOUT ANY WARRANTY!
rem An official license is being made for this software...
rem See http://www.nu2.nu/license/ for more details.
rem -------------------------------------------------------------------------
rem
if not exist %1 goto _trycab
set unpack_f=%1
goto _unpack
:_trycab
if not exist %1.lha goto _nofile
set unpack_f=%1.lha
:_unpack
if exist %ramdrv%\autorun.bat del %ramdrv%\autorun.bat 
:_noexec1
call %srcdrv%\bin\_unpack.bat %unpack_f% %ramdrv%\
if errorlevel 1 goto _unpackerr
rem extracted ok, clear unpackerr
set unpackerr=
if not exist %ramdrv%\autorun.bat goto _end
if not "%2" == "-x" goto _noexec
shift
for %%i in (9 8 7 6 5 4 3 2 1 0) do if not exist %ramdrv%\_autoru%%i.bat set unpack_a=_autoru%%i.bat
ren %ramdrv%\autorun.bat %unpack_a%
call %ramdrv%\%unpack_a% %2 %3 %4 %5 %6 %7 %8 %9
if not "%unpackerr%" == "" goto _end
for %%i in (0 1 2 3 4 5 6 7 8 9) do if exist %ramdrv%\_autoru%%i.bat set unpack_a=_autoru%%i.bat
del %ramdrv%\%unpack_a%>NUL
set unpack_a=
:_noexec
if exist %ramdrv%\autorun.bat del %ramdrv%\autorun.bat
goto _end
:_nofile
call message Error: Cannot find file "%1" or "%1.lha"
pause
goto _end
:_unpackerr
if exist %tmp%\extract.out type %tmp%\extract.out
if exist %tmp%\try.out type %tmp%\try.out
echo.
call message Error: while unpacking "%1"
set unpackerr=1
goto _end
:_end
if exist %tmp%\extract.out del %tmp%\extract.out
if exist %tmp%\try.out del %tmp%\try.out
set unpack_f=
