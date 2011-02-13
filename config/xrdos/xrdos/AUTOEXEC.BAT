@echo off
if not "%FS_PATH%"=="" goto FS_PATH
if "%PATH%"=="" GOTO NO_PATH

path %PATH%;%XRDOS%\bin
goto menu

:NO_PATH
path %XRDOS%\bin
goto menu

:FS_PATH
call addpath.bat %XRDOS%\bin

:MENU
type %XRDOS%\program.lst>> %tmp%\tips.txt


:end
