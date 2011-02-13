@echo off
set XCOPY=xcopy /s /e /i /r /h /k /y /F /D
if X == X%1 goto Usage
if X == X%2 goto Usage
if not exist %1 goto nosrc
if not exist %2 goto nodst
goto update
:Usage
echo %0 -- xcopy dos system
echo Usage : %0 DOS_ROOT Target_ROOT
goto :eof

:nosrc
echo %1 not exist
goto :eof

:nodst
echo %2 not exist
goto :eof

:update
pushd %1
mkdir %2\sys
mkdir %2\app
mkdir %2\etc
mkdir %2\tmp
mkdir %2\boot
mkdir %2\boot\images
%xcopy% etc %2\etc
%xcopy% app\bat %2\app\bat
%xcopy% app\bin %2\app\bin
%xcopy% app\tc201   %2\app\tc201
%xcopy% sys\bin %2\sys\bin
mkdir %2\sys\fdos10
copy    sys\fdos10\command.com %2\sys\fdos10
%xcopy% sys\fdos10\bin %2\sys\fdos10\bin
%xcopy% sys\msd98se %2\sys\msd98se
%xcopy% sys\msdos7  %2\sys\msdos7
%xcopy% sys\dosbox  %2\sys\dosbox
%xcopy% \boot\images\*.*	%2\boot\images
popd

:end

