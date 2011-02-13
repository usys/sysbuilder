@echo off
rem -------------------------------------------------------------------------
rem RUN.BAT v1.1
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------
if "%1" == "" goto _usage
set run_file=
if "%run_file%" == "" if exist %1 set run_file=%1
if "%run_file%" == "" if exist %1.lha set run_file=%1.lha
if "%run_file%" == "" if exist %srcdrv%\lib\%1 set run_file=%srcdrv%\lib\%1
if "%run_file%" == "" if exist %srcdrv%\lib\%1.lha set run_file=%srcdrv%\lib\%1.lha
if "%run_file%" == "" if exist %srcdrv%\level1\%1 set run_file=%srcdrv%\level1\%1
if "%run_file%" == "" if exist %srcdrv%\level1\%1.lha set run_file=%srcdrv%\level1\%1.lha
if "%run_file%" == "" if exist %srcdrv%\level2\%1 set run_file=%srcdrv%\level2\%1
if "%run_file%" == "" if exist %srcdrv%\level2\%1.lha set run_file=%srcdrv%\level2\%1.lha
if "%run_file%" == "" if exist %srcdrv%\level3\%1 set run_file=%srcdrv%\level3\%1
if "%run_file%" == "" if exist %srcdrv%\level3\%1.lha set run_file=%srcdrv%\level3\%1.lha
if not "%run_file%" == "" goto _unpack
echo RUN: "%1" not found in curdir, %srcdrv%\level[123] or %srcdrv%\lib
goto _end
:_usage
echo RUN: Missing first parameter (module name)
echo RUN: Listing available modules...
for %%i in (*.lha %srcdrv%\lib\*.lha %srcdrv%\level1\*.lha %srcdrv%\level2\*.lha %srcdrv%\level3\*.lha) do echo %%i
goto _end
:_unpack
call unpack %run_file% -x %2 %3 %4 %5 %6 %7 %8 %9
:_end
set run_file=
