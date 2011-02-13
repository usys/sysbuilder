@echo off
if X%1 == X goto no_cmd
set _cmd=%1
if X%2 == X goto no_title
set _title=%2
if X%3 == X goto no_label
set _label=%3 %4 %5 %6 %7 %8 %9
goto start
:no_cmd
goto usage
:no_title
set _title=Box
:no_label
set _label=%_cmd%
goto start

:start
call wbat.com box @%0:box #0,5
if errorlevel 100 goto no
if errorlevel 2 goto no
if errorlevel 1 goto yes
goto end
:no
goto end
:yes
%_cmd%
goto end



:box "%_title%" [x]

  [ Start ] ~%_label%?~ 

  Press 'ENTER' to Start, program will cancel #? seconds.
:usage
echo %0 - V1.0
echo    Confirm before executing command
echo Usage:
echo    %0 (command) [title] [texts...]

:end
set _cmd=
set _title=
set _label=


