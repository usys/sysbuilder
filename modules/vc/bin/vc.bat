@echo off
rem -----------------------
rem VC.BAT
rem (c) 2002 Bart Lagerweij
rem -----------------------
if exist %ramdrv%\bin\vc.com goto _run
echo VC: Unpacking...
extract /y /l %ramdrv%\ /e %srcdrv%\lib\vc4.cab
if errorlevel 1 goto _abort
:_run
%ramdrv%\bin\vc.com %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _end
:_abort
echo.
echo VC: aborted...
echo.
pause
:_end
