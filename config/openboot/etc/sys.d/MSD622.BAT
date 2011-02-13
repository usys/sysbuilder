
set PRNHEAD=] [ MSDOS 98se

if "%2"=="s" goto rcS
if "%2"=="S" goto rcS

:rc0
    call addpath.bat -b %1\msd622\bin
    if not exist %1\msd622\command.com goto nocomspec
    call export.bat COMSPEC %1\msd622\command.com

	
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
	call message.bat -n Loading smartdrv...
    call try2.bat LoadHigh %1\msd622\bin\smartdrv.exe /X
:dosbox_skip
    goto finish
:rc6
    goto end

:abort
    goto end

:finish
:end
