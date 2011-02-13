@echo off
rem ----------------------------
rem CDAUTRUN.BAT
rem (c) 2002 Bart Lagerweij
rem ----------------------------
set cddrv=
findcd -f\autorun.bat -e
if errorlevel 254 goto _find1
if errorlevel 0 set cddrv=A:
if errorlevel 1 set cddrv=B:
if errorlevel 2 set cddrv=C:
if errorlevel 3 set cddrv=D:
if errorlevel 4 set cddrv=E:
if errorlevel 5 set cddrv=F:
if errorlevel 6 set cddrv=G:
if errorlevel 7 set cddrv=H:
if errorlevel 8 set cddrv=I:
if errorlevel 9 set cddrv=J:
if errorlevel 10 set cddrv=K:
if errorlevel 11 set cddrv=L:
if errorlevel 12 set cddrv=M:
if errorlevel 13 set cddrv=N:
if errorlevel 14 set cddrv=O:
if errorlevel 15 set cddrv=P:
if errorlevel 16 set cddrv=Q:
if errorlevel 17 set cddrv=R:
if errorlevel 18 set cddrv=S:
if errorlevel 19 set cddrv=T:
if errorlevel 20 set cddrv=U:
if errorlevel 21 set cddrv=V:
if errorlevel 22 set cddrv=W:
if errorlevel 23 set cddrv=X:
if errorlevel 24 set cddrv=Y:
if errorlevel 25 set cddrv=Z:
echo CDAUTRUN: Autorun.bat found on drive %cddrv%
%cddrv%
cd \
%cddrv%\autorun.bat
rem If we get here, autorun.bat failed somehow...
echo CDAUTRUN: Starting "%cddrv%\autorun.bat" has failed ?!?
pause
goto _end
:_find1
echo CDAUTRUN: Autorun.bat *not* found on any CD...
findcd -e -r
if errorlevel 254 goto _find2
if errorlevel 0 set cddrv=A:
if errorlevel 1 set cddrv=B:
if errorlevel 2 set cddrv=C:
if errorlevel 3 set cddrv=D:
if errorlevel 4 set cddrv=E:
if errorlevel 5 set cddrv=F:
if errorlevel 6 set cddrv=G:
if errorlevel 7 set cddrv=H:
if errorlevel 8 set cddrv=I:
if errorlevel 9 set cddrv=J:
if errorlevel 10 set cddrv=K:
if errorlevel 11 set cddrv=L:
if errorlevel 12 set cddrv=M:
if errorlevel 13 set cddrv=N:
if errorlevel 14 set cddrv=O:
if errorlevel 15 set cddrv=P:
if errorlevel 16 set cddrv=Q:
if errorlevel 17 set cddrv=R:
if errorlevel 18 set cddrv=S:
if errorlevel 19 set cddrv=T:
if errorlevel 20 set cddrv=U:
if errorlevel 21 set cddrv=V:
if errorlevel 22 set cddrv=W:
if errorlevel 23 set cddrv=X:
if errorlevel 24 set cddrv=Y:
if errorlevel 25 set cddrv=Z:
echo CDAUTRUN: The first CD-Rom with media is drive %cddrv%
%cddrv%
cd \
goto _end
:_find2
findcd -e -a
if errorlevel 254 goto _end
if errorlevel 0 set cddrv=A:
if errorlevel 1 set cddrv=B:
if errorlevel 2 set cddrv=C:
if errorlevel 3 set cddrv=D:
if errorlevel 4 set cddrv=E:
if errorlevel 5 set cddrv=F:
if errorlevel 6 set cddrv=G:
if errorlevel 7 set cddrv=H:
if errorlevel 8 set cddrv=I:
if errorlevel 9 set cddrv=J:
if errorlevel 10 set cddrv=K:
if errorlevel 11 set cddrv=L:
if errorlevel 12 set cddrv=M:
if errorlevel 13 set cddrv=N:
if errorlevel 14 set cddrv=O:
if errorlevel 15 set cddrv=P:
if errorlevel 16 set cddrv=Q:
if errorlevel 17 set cddrv=R:
if errorlevel 18 set cddrv=S:
if errorlevel 19 set cddrv=T:
if errorlevel 20 set cddrv=U:
if errorlevel 21 set cddrv=V:
if errorlevel 22 set cddrv=W:
if errorlevel 23 set cddrv=X:
if errorlevel 24 set cddrv=Y:
if errorlevel 25 set cddrv=Z:
echo CDAUTRUN: The first CD-Rom is drive %cddrv%
:_end
