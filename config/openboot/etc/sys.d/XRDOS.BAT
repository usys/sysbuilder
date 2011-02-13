
set PRNHEAD=] [ XRDOS

if "%1"=="s" goto rcS
if "%1"=="S" goto rcS

:rc0
    call addpath.bat -b %FS_SYS%\msd98se\bin
rem    if not exist %FS_SYS%\msd98se\command.com goto nocomspec
rem    set COMSPEC=%FS_SYS%\msd98se\command.com
rem    call message.bat export COMSPEC : "%COMSPEC%"
:nocomspec

if "%1"=="1" goto rc1
if "%1"=="2" goto rc2
if "%1"=="3" goto rc3
if "%1"=="4" goto rc4
if "%1"=="5" goto rc5
if "%1"=="6" goto rc6
goto rc3

:rcS

goto end

:rc1
:rc2
:rc3
:rc4
:rc5
    call try.bat LoadHigh "Loading smartdrv" %FS_SYS%\msd98se\bin\smartdrv.exe /X
    rem call try.bat LoadHigh doskey %FS_SYS%\msd98se\bin\doskey.com /INSERT /FILE:%FS_SYS%\msd98se\bin\doskey.lst
    goto finish
:rc6
    goto end

:abort
    goto end

:finish
:end
