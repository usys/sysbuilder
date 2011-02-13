@echo off
set PRNHEAD=] [ DOSBOX

if "%2"=="s" goto rcS
if "%2"=="S" goto rcS

:rc0
    call export.bat PROMPT $G
    call export.bat DIRCMD /A/OG/ON/OE/L
    call addpath.bat -b %1\dosbox\bin
REM    if not exist %FS_SYS%\dosbox\command.com goto nocomspec
REM    set COMSPEC=%FS_SYS%\dosbox\command.com
REM    call message.bat export COMSPEC : "%COMSPEC%"
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
REM call try.bat LoadHIGH "Loading doskey" %FS_SYS%\dosbox\bin\doskey.com /INSERT
    goto finish
:rc6
    goto end

:abort
    goto end

:finish
    goto end
:end
