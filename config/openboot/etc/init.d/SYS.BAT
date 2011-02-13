@echo off
if not exist %FS_ROOT%SYS\NUL goto end
set PRNHEAD=Sys

if "%2"=="s" goto rcS
if "%2"=="S" goto rcS

:rc0
    call addpath.bat -b %FS_ROOT%sys\bin

if "%2"=="1" goto rc1
if "%2"=="2" goto rc2
if "%2"=="3" goto rc3
if "%2"=="4" goto rc4
if "%2"=="5" goto rc5
if "%2"=="6" goto rc6
goto rc3

:rcS
    goto end
:rc6
    goto end

:rc1
:rc2
:rc3
:rc4
:rc5
    call message.bat -n Loading doskey...
    call try2.bat LoadHigh %FS_ROOT%sys\bin\doskey.com /INSERT
    IF # == #%3 goto skipsys
    if not exist %1\%3.bat 	goto skipsys
    set PRNHEAD=Sys
    call %1\%3.bat %FS_ROOT%sys %2 %3 %4 %6 %7 %8 %9
    set PRNHEAD=Sys
    goto finish

:skipsys
    goto end
:abort
    goto end

:finish
    goto end
:end
    set FS_SYS=
    set PRNHEAD=
