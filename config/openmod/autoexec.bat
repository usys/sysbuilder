@echo off
if X_GOTO == X%1 goto %2
rem OPENBOOT, AUTOEXEC.BAT
if "%config%" == "CLEAN" goto _abort
if "%config%" == "7" goto _abort
goto _arcfmt

:_err_file
echo %err_file%
set err_file=
goto _abort


:_arcfmt
for %%i in (lha cab zip rar) do if exist openmod\un%%i.bat set arc=%%i
if X == X%arc% set arc=lha
if not exist bin\chkfile.bat goto _start
set err_file=
call bin\chkfile.bat %3 openmod un%arc%.bat 
if NOT X == X%err_file% goto _err_file
call bin\chkfile.bat %3 bin message.bat _ramdrv.bat try.bat 
if NOT X == X%err_file% goto _err_file
set err_file=

:_start
if exist welcome.txt type welcome.txt

:_goram
if X == X%ramdrv% call bin\_ramdrv.bat 32768
if X == X%ramdrv% goto _abort
if exist %ramdrv%\openmod goto _skipcp
call bin\message "Setting up Ramdisk at drive %ramdrv%"

:_ramok
if not exist %ramdrv%\bin\ md %ramdrv%\bin
if not exist %ramdrv%\tmp\ md %ramdrv%\tmp
if not exist %ramdrv%\openmod\ md %ramdrv%\openmod
if X == X%tmp% for %%i in (temp,tmp) do set %%i=%ramdrv%\tmp

call bin\message.bat "Copying some files to ramdisk..."

for %%i in (bin\*.exe bin\*.bat bin\*.com) do copy /B /Y %%i %ramdrv%\bin>NUL
if exist %ramdrv%\bin\command.com set comspec=%ramdrv%\bin\command.com

for %%i in (openmod\*.*) do copy /B /Y %%i %ramdrv%\openmod> NUL

if not "%path%" == "" set path=%ramdrv%\bin;%path%
if "%path%" == "" set path=%ramdrv%\bin

:_skipcp

REM copy /B /Y %ramdrv%\openmod\process.bat %tmp%\_process.bat>NUL
REM call %ramdrv%\openmod\un%arc%.bat %ramdrv% %tmp%\_process.bat

call message "Processing modules..."
echo @if X == X%debug% echo off> %tmp%\_openmod.bat
for %%i in (level0\*.%arc%) do call %ramdrv%\openmod\un%arc%.bat %%i %ramdrv% %tmp%\_openmod.bat
for %%i in (level1\*.%arc%) do call %ramdrv%\openmod\un%arc%.bat -x %%i %ramdrv% %tmp%\_openmod.bat
for %%i in (level2\*.%arc%) do call %ramdrv%\openmod\un%arc%.bat -x %%i %ramdrv% %tmp%\_openmod.bat
for %%i in (level3\*.%arc%) do call %ramdrv%\openmod\un%arc%.bat -x %%i %ramdrv% %tmp%\_openmod.bat
for %%i in (openmod*.%arc%) do call %ramdrv%\openmod\un%arc%.bat %%i %ramdrv% %tmp%\_openmod.bat
call %tmp%\_openmod.bat
for %%i in (%ramdrv%\autoruns\level1\*.bat) do call %%i
for %%i in (%ramdrv%\autoruns\level2\*.bat) do call %%i
for %%i in (%ramdrv%\autoruns\level3\*.bat) do call %%i
call message "Process finished."
set arc=

rem should not get here
:_abort
REM if exist %srcdrv%\openmod\_result.bat	call %srcdrv%\openmod\_result.bat
rem flow into "_end"
:_end
