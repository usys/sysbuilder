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

echo call message "Processing modules..." >> %tmp%\_modboot.bat
if not exist %srcdrv%\level0\*.lha goto _no0
for %%i in (%srcdrv%\level0\*.lha) do call %ramdrv%\bin\modboot.bat : _unpack %%i

:_no0
if not exist %srcdrv%\level1\*.lha goto _no1
for %%i in (%srcdrv%\level1\*.lha) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x


:_no1
if not exist %srcdrv%\level2\*.lha goto _no2
for %%i in (%srcdrv%\level2\*.lha) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x


:_no2
if not exist %srcdrv%\level3\*.lha goto _no3
for %%i in (%srcdrv%\level3\*.lha) do call %ramdrv%\bin\modboot.bat : _unpack %%i -x

:_no3

echo goto _end>> %tmp%\_modboot.bat
echo :_shift>> %tmp%\_modboot.bat
echo call message "Exiting (shift pressed)...">> %tmp%\_modboot.bat
echo goto _end>> %tmp%\_modboot.bat
echo :_abort>> %tmp%\_modboot.bat
echo echo.>> %tmp%\_modboot.bat
echo call message "Aborted...">> %tmp%\_modboot.bat
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
call message "Exiting (shift pressed)..."
goto _end

:_abort
:_end
if exist %tmp%\_modboot.bat del %tmp%\_modboot.bat
if exist %ramdrv%\tips.txt type %ramdrv%\tips.txt
:_eof
