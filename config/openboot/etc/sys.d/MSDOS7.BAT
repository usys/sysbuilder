
set PRNHEAD=] [ MSDOS7

if "%1"=="s" goto rcS
if "%1"=="S" goto rcS

:rc0
    set PROMPT=$G
    set DIRCMD=/L/OGN/4
    call message.bat export DIRCMD : "%DIRCMD%"
    call addpath.bat -b %FS_SYS%\msdos7\bin
REM    if not exist %FS_SYS%\msdos7\command.com goto nocomspec
REM    set COMSPEC=%FS_SYS%\msdos7\command.com
REM    call message.bat export COMSPEC : "%COMSPEC%"
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
rem    call try.bat LoadHigh smartdrv %FS_SYS%\msdos7\bin\smartdrv.exe /X
rem    call try.bat LoadHigh doslfn %FS_SYS%\msdos7\bin\doslfn.com
    call try.bat LoadHigh doskey %FS_SYS%\msdos7\bin\doskey.com /INSERT
:rc3
:rc4
:rc5
    goto finish
:rc6
    goto end

:abort
    goto end

:finish
REM    call message.bat Chdir to %FS_ROOT%
REM    %FS_ROOT%\
REM    CD %FS_ROOT% >NUL
    goto end
:end
