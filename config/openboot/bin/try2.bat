@echo off
REM %1  == Type (Call,Load,LoadHigh,CMD)
REM %2  == Pathname
REM %3  == Arguments (Optional)

if "%2"=="" goto END
echo %1 %2 %3 %4 %5 %6 %7 %8 %9>> %tmp%\try.lst
goto %1> %tmp%\try.out
goto CALL
goto END

:CMD
shift
%1 %2 %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
IF not errorlevel 0 goto Failed
goto Tried

:Call
shift
call %1 %2 %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
IF not errorlevel 0 goto Failed
goto Tried

:Load
shift
load %1 %2 %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
IF not errorlevel 0 goto Failed
goto Tried

:LoadHigh
shift
LoadHIGH %1 %2 %3 %4 %5 %6 %7 %8 %9> %tmp%\try.out
IF not errorlevel 0 goto Failed
goto Tried

:Tried
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

