@ECHO OFF
REM =============================
REM Loader for floppy bootting
REM =============================

IF "%1"=="" GOTO RECALL

SET SYSNAME=msdos7

:TEST
dready %1
IF ERRORLEVEL 2 GOTO NEXTD
IF ERRORLEVEL 255 GOTO NEXTD
IF EXIST %1\ETC\IMPORT.BAT GOTO IMPORT_ROOT
IF EXIST %1\DOS\ETC\IMPORT.BAT GOTO IMPORT_DOS
GOTO NEXTD
IF NOT EXIST %1\etc\import.bat GOTO NEXTD
call %1\etc\import.bat %1 %CONFIG% msdos7
GOTO NEXTD

:IMPORT_ROOT
call %1\etc\import.bat %1 %CONFIG% %SYSNAME%
GOTO END

:IMPORT_DOS
call %1\dos\etc\import.bat %1\dos %CONFIG% %SYSNAME%
GOTO END

:NEXTD
SHIFT
IF NOT "%1"=="" GOTO TEST
GOTO END

:RECALL
%0 C: Z: D: Y: E: X: F: W:
GOTO END

:END
SET SYSNAME=