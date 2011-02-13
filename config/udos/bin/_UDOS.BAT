@ECHO off
IF X == X%CONFIG% set CONFIG=NORMAL
IF X == X%2	goto SET_OS
Goto TEST

:SET_OS
set OS=%1
if X == X%1 set OS=win98se
echo @echo off> bin\_import.bat
call %0 C Z D Y E X F W G V H U I T J S K R L Q M P N O
set OS=
goto end


:TEST
bin\dready.com %1:
IF ERRORLEVEL 255 GOTO NEXTD
IF ERRORLEVEL 1 GOTO NEXTD
IF ERRORLEVEL 2 GOTO NEXTD
IF EXIST %1:\ETC\INIT.BAT GOTO ETC
IF EXIST %1:\DOS\ETC\INIT.BAT GOTO DOSETC
:NEXTD
SHIFT
IF NOT "%1"=="" GOTO TEST
GOTO END


:ETC
REM echo %1:>> \bin\_import.bat
echo CALL %1:\ETC\INIT.BAT %1:\ %CONFIG% %OS%>> \bin\_import.bat
REM IF NOT EXIST %1:\AUTOEXEC.BAT goto import
REM echo %1:\AUTOEXEC.BAT %1:\ %CONFIG% %OS%>> \bin\_import.bat
GOTO import

:DOSETC
REM echo %1:>> \bin\_import.bat
echo CALL %1:\DOS\ETC\INIT.BAT %1:\DOS\ %CONFIG% %OS%>> \bin\_import.bat
REM IF NOT EXIST %1:\DOS\AUTOEXEC.BAT goto import
REM echo %1:\DOS\AUTOEXEC.BAT %1:\DOS\ %CONFIG% %OS%>> \bin\_import.bat
goto import

:import
call bin\_import.bat
:END
