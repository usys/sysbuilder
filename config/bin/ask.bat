@echo off
if X%2 == X goto usage
set _question=%2 %3 %4 %5 %6 %7 %8 %9
goto start

:start
if X%1 == X1 wbat.com box @%0:box #1,5
if NOT X%1 == X1 wbat.com box @%0:box #2,5
if errorlevel 2 goto no
if errorlevel 1 goto yes
if errorlevel 0 goto no
goto end
:yes
set _answer=yes
goto end
:no
set _answer=
goto end

:box "Confirm" [x]

  ~%_question%~ 
            #?        
                  [ &YES ] [? &NO ]
:usage
echo %0 - V1.0
echo    Ask question
echo Usage:
echo    %0 (1/0/2) question
echo Option:
echo    1   default to YES
echo    0/2   default to NO
:end
set _question=
set _default=

