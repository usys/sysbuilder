@echo off
if #-b == #%1 goto BEFORE
if #-B == #%1 goto BEFORE

:APPEND
if # == #%1 goto END
call message.bat "PATH +=" %1 %2 %3 %4 %5 %6 %7 %8 %9
:ALOOP
IF X == X%FS_PATH% goto daloop
set FS_PATH=%FS_PATH%;%1
goto naloop
:daloop
set FS_PATH=%1
:naloop
shift
if # == #%1 goto END
goto ALOOP

:BEFORE
shift
if # == #%1 GOTO END
call message.bat "PATH =+" %1 %2 %3 %4 %5 %6 %7 %8 %9
:BLOOP
IF X == X%FS_PATH% goto dbloop
set FS_PATH=%1;%FS_PATH%
goto nbloop
:dbloop
set FS_PATH=%1
:nbloop
shift
if # == #%1 goto END
goto BLOOP

:END
