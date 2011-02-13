
set PRNHEAD=] [ Freedos 1.0

if "%2"=="s" goto rcS
if "%2"=="S" goto rcS

:rc0
    CALL EXPORT PROMPT $G
	CALL EXPORT DIRCMD /L/OGN/4
    if not exist %1\fdos10\command.com goto nocomspec
    CALL EXPORT COMSPEC %1\fdos10\command.com
:nocomspec
	call addpath.bat -b %1\fdos10\bin
	
if "%2"=="1" goto rc1
if "%2"=="2" goto rc2
if "%2"=="3" goto rc3
if "%2"=="4" goto rc4
if "%2"=="5" goto rc5
if "%2"=="6" goto rc6
if "%2"=="7" goto rcS
goto rc3

:rc1
:rc2
:rc3
:rc4
:rc5
:rc6
call try.bat LoadHigh "Loading doslfn" %1\fdos10\bin\doslfn.com
call try.bat LoadHigh "Loading lblcache" %1\fdos10\bin\lbacache.com 6000 TUNS 
goto finish

:rc7
:rcS
    goto end

:abort
    goto end

:finish
REM    call message.bat CHDIR to %FS_ROOT%
REM    cdd %FS_ROOT%    
REM    goto end
:end
