@echo off
REM %1  == Type (Call,Load,LoadHigh,CMD)
REM %2  == Name
REM %3  == Pathname
REM %4  == Arguments (Optional)

if "%3"=="" goto END
if not "%2" == "NULL" call message.bat -n "%2..."
rem call message.bat -n "%2..."
echo %1 %2 %3 %4 %5 %6 %7 %8 %9>> %tmp%\try.lst
goto %1> %tmp%\try.out
goto CALL
goto END

:CMD
%3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
goto Tried

:Call
call %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
goto Tried

:Load
load %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
goto Tried

:LoadHigh
LoadHIGH %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
goto Tried

:Tried
IF not errorlevel 0 goto Failed
echox -e "\tOK\r\n"
goto END

:Failed
echox -e "\tFailed\r\n"
type %tmp%\try.out
goto END

:NoFile
call echot.bat "Error (%1 not exist!)"
goto END

:END

