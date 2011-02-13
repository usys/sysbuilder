@ECHO OFF
IF "%1"=="" GOTO RECALL

REM call bin\message -n "Searching for XRDOS extension..."

:TEST
bin\dready.com %1:
IF ERRORLEVEL 255 GOTO NEXTD
IF ERRORLEVEL 1 GOTO NEXTD
IF ERRORLEVEL 2 GOTO NEXTD
SET XRDOS=
IF EXIST %1:\BOOT\XRDOS\IMPORT.BAT SET XRDOS=%1:\BOOT\XRDOS
IF EXIST %1:\DOS\XRDOS\IMPORT.BAT SET XRDOS=%1:\DOS\XRDOS
IF EXIST %1:\XRDOS\IMPORT.BAT SET XRDOS=%1:\XRDOS
IF NOT "%XRDOS%"=="" GOTO HARDDISK
IF EXIST %1:\boot\images\xrdos.lha GOTO RAMDISK
GOTO NEXTD


:HARDDISK
echo.
call bin\message "Found XRDOS extension at %XRDOS%"
goto XRDOS

:RAMDISK
echo.
call bin\message "Found XRDOS extension at %1:\boot\images\xrdos.lha"
if "%ramdrv%"=="" call bin\try.bat call "Setting up ramdisk" bin\_ramdrv.bat 32768
if not "%ramdrv%"=="" goto _ramok
call bin\message "No ramdisk,aborting..."
goto abort

:_ramok
call bin\message "Found ramdisk %ramdrv%"
set XRDOS=%ramdrv%
IF NOT EXIST %XRDOS%\TMP MKDIR %XRDOS%\TMP
SET TEMP=%XRDOS%\tmp
SET TMP=%XRDOS%\tmp
call bin\_unpack.bat %1:\boot\images\xrdos.lha %XRDOS%\
GOTO XRDOS

:XRDOS
call bin\message "Importing extension..."
IF EXIST %XRDOS%\IMPORT.BAT call %XRDOS%\import.bat %XRDOS%\
IF EXIST %XRDOS%\AUTOEXEC.BAT call %XRDOS%\AUTOEXEC.BAT %XRDOS%\
goto end


:NEXTD
SHIFT
IF NOT "%1"=="" GOTO TEST
REM bin\echox.com -e "\t[Not Found]\r\n"
GOTO END

:RECALL
%0 C Z D Y E X F W G V H U I T J S K R L Q M P N O
GOTO END


:END
:finished
:abort
REM if exist bin\_result.bat call bin\_result.bat