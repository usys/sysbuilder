@echo off
if "%1"=="" GOTO END
set TESTDIR=%1
set FS_ERR=

:TEST
shift
if "%1"=="" GOTO END
if not exist %TESTDIR%\%1 set FS_ERR=%TESTDIR%\%1
if not "%FS_ERR%"=="" GOTO END
goto TEST

:END
set TESTDIR=
