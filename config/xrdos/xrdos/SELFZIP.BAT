@echo off
if "%1"=="" GOTO USAGE
del /P %1
pkzip -apr %1 %XRDOS%\*.*
IF ERRORLEVEL 0 echo %0: %1 CREATED.
goto end

:USAGE
ECHO USAGE:%0 FILENAME.ZIP
GOTO END

:END

