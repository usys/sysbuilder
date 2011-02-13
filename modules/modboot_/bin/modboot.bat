@echo off
if "%1"==":" if not "%2"=="" goto %2
rem -------------------------------------------------------------------------
rem MODBOOT.BAT, Copyright (C) by Bart Lagerweij
rem This program is free software, but WITHOUT ANY WARRANTY!
rem An official license is being made for this software...
rem See http://www.nu2.nu/license/ for more details.
rem -------------------------------------------------------------------------

rem Process levels
echo @echo off> %tmp%\_modboot.bat

echo call message -n "Processing modules..." >> %tmp%\_modboot.bat
if not exist %srcdrv%\level0\*.cab goto _no0
rem echo call message -n "Init module level 0..." >> %tmp%\_modboot.bat
for %%i in (%srcdrv%\level0\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i


:_no0
if not exist %srcdrv%\level1\*.cab goto _no0
REM echo call message -n "Init module level 1..." >> %tmp%\_modboot.bat
for %%i in (%srcdrv%\level1\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x


:_no1
if not exist %srcdrv%\level2\*.cab goto _no0
REM echo call message -n "Init module level 2..." >> %tmp%\_modboot.bat
for %%i in (%srcdrv%\level2\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x


:_no2
if not exist %srcdrv%\level3\*.cab goto _no0
REM echo call message -n "Init module level 3..." >> %tmp%\_modboot.bat
for %%i in (%srcdrv%\level3\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x

:_no3
echo call message -n "Done." >> %tmp%\_modboot.bat
rem if not exist %srcdrv%\level1\*.cab goto _no1
rem for %%i in (%srcdrv%\level1\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x
rem :_no1
rem if not exist %srcdrv%\level2\*.cab goto _no2
rem for %%i in (%srcdrv%\level2\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x
rem :_no2
rem if not exist %srcdrv%\level3\*.cab goto _no3
rem for %%i in (%srcdrv%\level3\*.cab) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x
rem :_no3
echo goto _end>> %tmp%\_modboot.bat
echo :_shift>> %tmp%\_modboot.bat
echo call message -n "Exiting (shift pressed)...">> %tmp%\_modboot.bat
echo goto _end>> %tmp%\_modboot.bat
echo :_abort>> %tmp%\_modboot.bat
echo echo.>> %tmp%\_modboot.bat
echo call message -n "Aborted...">> %tmp%\_modboot.bat
echo echo.>> %tmp%\_modboot.bat
echo pause>> %tmp%\_modboot.bat
echo :_end>> %tmp%\_modboot.bat
call %tmp%\_modboot.bat
goto _end

:_unpack
echo kbfl>> %tmp%\_modboot.bat
echo if errorlevel 1 goto _shift>> %tmp%\_modboot.bat
echo call %ramdrv%\bin\unpack.bat %3 %4>> %tmp%\_modboot.bat
echo if not "%%unpackerr%%" == "" goto _abort>> %tmp%\_modboot.bat
goto _eof

:_shift
call message -n "Exiting (shift pressed)..."
goto _end
:_abort
echo.
call message -n "Aborted..."
echo.
pause
rem flow into "_end"
:_end
if exist %tmp%\_modboot.bat del %tmp%\_modboot.bat
if exist %ramdrv%\tips.txt type %ramdrv%\tips.txt
:_eof
