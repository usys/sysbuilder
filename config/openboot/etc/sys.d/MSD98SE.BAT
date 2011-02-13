
set PRNHEAD=MSDOS 98se

if "%2"=="s" goto rcS
if "%2"=="S" goto rcS

:rc0
    call addpath.bat -b %1\msd98se\bin
    if not exist %1\msd98se\command.com goto nocomspec
    call export.bat COMSPEC %1\msd98se\command.com

	
:nocomspec

if "%2"=="1" goto rc1
if "%2"=="2" goto rc2
if "%2"=="3" goto rc3
if "%2"=="4" goto rc4
if "%2"=="5" goto rc5
if "%2"=="6" goto rc6
goto rc3

:rcS

goto end

:rc1
:rc2
:rc3
:rc4
:rc5
IF "%2"=="DOSBOX" goto dosbox_skip
    call try.bat LoadHigh "Loading smartdrv" %1\msd98se\bin\smartdrv.exe /X
:dosbox_skip
REM    call try.bat LoadHigh doskey %1\msd98se\bin\doskey.com /INSERT /FILE:%FS_SYS%\msd98se\bin\doskey.lst
    goto finish
:rc6
    goto end

:abort
    goto end

:finish
:end
