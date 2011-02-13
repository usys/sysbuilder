@echo off
if "%1"==":" if not "%2"=="" goto %2
rem -------------------------------------------------------------------------
rem CDROM.BAT, Copyright (c) 2002 Bart Lagerweij
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------

echo CDROM: Starting (version 2.2)
if not exist %ramdrv%\bin\unpack.bat %0 : _error missing unpack.bat (check modboot.cab)
if not exist %ramdrv%\bin\lmod.com %0 : _error missing lmod.com (check utils.cab)
if not exist %ramdrv%\bin\tfind.com %0 : _error missing tfind.com (check utils.cab)
if not exist %ramdrv%\bin\wbat.com %0 : _error missing wbat.com (check utils.cab)
if not exist %ramdrv%\bin\device.com %0 : _error missing device.com (check utils.cab)

:_start
if not exist %srcdrv%\etc\cdrom.set goto _noset
type %srcdrv%\etc\cdrom.set > %tmp%\_cdrom.bat
call %tmp%\_cdrom.bat
:_noset

rem Some default settings (if empty)
if "%cdrom_drv%" == "" set cdrom_drv=r
if "%cdrom_ti%" == "" set cdrom_ti=10

rem check for "-c" argument
if "%1" == "-c" goto _config
if "%1" == "/c" goto _config
if "%1" == "-h" goto _usage
if "%1" == "/h" goto _usage

if "%cdrom_ncfg%" == "1" goto _nocfg
wbat box @%ramdrv%\bin\cdrom.bat:w_cfg #0,%cdrom_ti%
if errorlevel 3 goto _end
if errorlevel 2 goto _config
rem errorlevel 1 flow into below
:_nocfg

rem check if cdrom drivers are already loaded
if exist CDEXELT1 goto _notagain
if exist CDEXATA1 goto _notagain
if exist CDEXSCS1 goto _notagain

if "%cdrom_ld%" == "3" goto _fixed
if "%cdrom_ld%" == "2" goto _manual
rem any other cdrom_ld value means "auto"
goto _auto

:_manual
echo CDROM: Manual loading mode
rem Generate dialog
echo :w_manual "Manual CD-Rom configuration?" [x]> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo Use [$ cdrom_drv,1,U]: as the first drive letter for CD-Rom>> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo     [!] Eltorito - requires %srcdrv%\lib\eltorito.cab>> %tmp%\_cdrom.tmp
echo     [!] Atapi    - requires %srcdrv%\lib\atapi.cab>> %tmp%\_cdrom.tmp
echo     [!] Scsi     - requires %srcdrv%\lib\aspi.cab (and more)>> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo                  [ Ok ]  [? Cancel ]>> %tmp%\_cdrom.tmp
set wcb1=%cdrom_elt%
set wcb2=%cdrom_ata%
set wcb3=%cdrom_scs%
call w.bat box @%tmp%\_cdrom.tmp:w_manual
set cdrom_elt=%wcb1%
set cdrom_ata=%wcb2%
set cdrom_scs=%wcb3%
if errorlevel 2 goto _end

:_fixed
echo CDROM: Fixed loading mode
if not "%cdrom_elt%" == "1" goto _goatapi
echo CDROM: Loading El-Torito
if not exist %srcdrv%\lib\eltorito.cab %0 : _error missing %srcdrv%\lib\eltorito.cab
if exist %ramdrv%\lib\eltorito.sys goto _torito2
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\eltorito.cab
if not "%unpackerr%" == "" goto _abort
:_torito2
lh device %ramdrv%\lib\eltorito.sys /D:CDEXELT1

:_goatapi
if not "%cdrom_ata%" == "1" goto _goscsi
echo CDROM: Loading Atapi
if not exist %srcdrv%\lib\atapicd.cab %0 : _error missing %srcdrv%\lib\atapicd.cab
if exist %ramdrv%\lib\vide-cdd.sys goto _fata2
rem echo CDROM: Extracting "%srcdrv%\lib\atapicd.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\atapicd.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\atapicd.cab
if not "%unpackerr%" == "" goto _abort
:_fata2
lh device %ramdrv%\lib\vide-cdd.sys /D:CDEXATA1

:_goscsi
if not "%cdrom_scs%" == "1" goto _noscsi2
echo CDROM: Loading ASPI/SCSI
if not exist %srcdrv%\lib\aspi.cab %0 : _error missing %srcdrv%\lib\aspi.cab
if not exist %srcdrv%\lib\aspicd.cab %0 : _error missing %srcdrv%\lib\aspicd.cab
if not exist %srcdrv%\lib\aspi\*.cab %0 : _error missing %srcdrv%\lib\aspi\*.cab
if exist %ramdrv%\bin\aspi.bat goto _aspi2
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\aspi.cab
if not "%unpackerr%" == "" goto _abort
:_aspi2
call aspi.bat
if "%pci0%" == "_BACK_" goto _noscsi2
if not exist SCSIMGR$ goto _cdex
if exist %ramdrv%\lib\aspicd.sys goto _scsi2
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\aspicd.cab
if not "%unpackerr%" == "" goto _abort
:_scsi2
lh device %ramdrv%\lib\aspicd.sys /D:CDEXSCS1
:_noscsi2
goto _cdex

:_auto
echo CDROM: Auto mode
echo CDROM: Trying El-Torito...
rem first check if cdrom is in "noemulation" mode
rem if yes then use eltorito.sys
if not exist %srcdrv%\lib\eltorito.cab goto _tryatapi
if not exist %ramdrv%\bin\ettool.com goto _tryatapi
echo CDROM: Checking boot media type
%ramdrv%\bin\ettool b
if errorlevel 11 goto _tryatapi
if errorlevel 10 goto _eltorito
goto _tryatapi

:_eltorito
if not exist %srcdrv%\lib\eltorito.cab goto _noeltor
echo CDROM: Loading El-Torito
rem if exist %ramdrv%\lib\eltorito.sys goto _torito
rem echo CDROM: Extracting "%srcdrv%\lib\eltorito.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\eltorito.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\eltorito.cab
if not "%unpackerr%" == "" goto _abort
:_torito
lh device %ramdrv%\lib\eltorito.sys /D:CDEXELT1
if errorlevel 1 goto _abort
goto _cdex
:_noeltor
echo CDROM: File %srcdrv%\lib\eltorito.cab not found.

:_tryatapi
echo CDROM: Trying Atapi...
if not exist %srcdrv%\lib\atapicd.cab goto _tryscsi
if exist %ramdrv%\lib\vide-cdd.sys goto _atapi1
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\atapicd.cab
if not "%unpackerr%" == "" goto _abort
:_atapi1
lh device %ramdrv%\lib\vide-cdd.sys /D:CDEXATA1
if errorlevel 1 goto _tryscsi
goto _cdex
:_noatapi
echo CDROM: File %srcdrv%\lib\atapicd.cab not found.

:_tryscsi
echo CDROM: Trying ASPI/SCSI...
if not exist %srcdrv%\lib\aspi.cab goto _cdex
if exist %ramdrv%\bin\aspi.bat goto _aspi1
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\aspi.cab
if not "%unpackerr%" == "" goto _abort
:_aspi1
call aspi.bat
if "%pci0%" == "_BACK_" goto _cdex
if not exist SCSIMGR$ goto _cdex
if not exist %srcdrv%\lib\aspicd.cab goto _noaspicd
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\aspicd.cab
if not "%unpackerr%" == "" goto _abort
lh device %ramdrv%\lib\aspicd.sys /D:CDEXSCS1
rem if errorlevel 1 goto _cdex
rem flow into _cdex

:_cdex
if exist CDEXELT1 goto _cdex1
if exist CDEXATA1 goto _cdex1
if exist CDEXSCS1 goto _cdex1
echo CDROM: No CD-Rom drivers have been loaded!
goto _abort
:_cdex1
set w_dev=
if exist CDEXELT1 set w_dev=%w_dev% /D:CDEXELT1
if exist CDEXATA1 set w_dev=%w_dev% /D:CDEXATA1
if exist CDEXSCS1 set w_dev=%w_dev% /D:CDEXSCS1
if exist %srcdrv%\lib\mscdex.cab goto _msex
if exist %srcdrv%\lib\shsucdx.cab goto _shex
echo CDROM: Could not find %srcdrv%\lib\shsucdx.cab or %srcdrv%\lib\mscdex.cab
goto _abort
:_shex
if exist %ramdrv%\bin\shsucdx.exe goto _shex1
rem echo CDROM: Extracting "%srcdrv%\lib\shsucdx.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\shsucdx.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\shsucdx.cab
if not "%unpackerr%" == "" goto _abort
:_shex1
if not "%cdrom_drv%" == "" set w_dev=%w_dev%,%cdrom_drv%
lh shsucdx%w_dev%
if errorlevel 1 goto _abort
set w_dev=
goto _autorun
:_msex
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\mscdex.cab
if not "%unpackerr%" == "" goto _abort
:_msex1
if not "%cdrom_drv%" == "" set w_dev=%w_dev% /L:%cdrom_drv%
lh mscdex%w_dev%
if errorlevel 1 goto _abort
set w_dev=
rem flow into _autorun
:_autorun
rem cleanup
set | tfind /f1,2 "W_" >> %tmp%\_cdrom.tmp
set | tfind /f1,6 "CDROM_" >> %tmp%\_cdrom.tmp
type %tmp%\_cdrom.tmp | lmod /L* /B= set [$1]=> %tmp%\_cdrom.bat
call %tmp%\_cdrom.bat
rem cleanup some tmp files
if exist %tmp%\_cdrom.* del %tmp%\_cdrom.*
set wcb1=
set wcb2=
set wcb3=
set wcb4=
set wcb5=
set wcb6=
set wcb7=
set wcb8=
set wcb9=
set wrb=
set wbat=
set ?=
if exist %ramdrv%\bin\cdautrun.bat goto _goautrun
if not exist %srcdrv%\lib\cdautrun.cab goto _nocdautrun
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\cdautrun.cab
if not "%unpackerr%" == "" goto _abort
:_goautrun
%ramdrv%\bin\cdautrun.bat
rem should not get here
echo CDROM: Eh, did "%ramdrv%\bin\cdautrun.bat" failed?!?
goto _abort
:_nocdautrun
echo CDROM: File "%srcdrv%\lib\cdautrun.cab" not found... autorun disabled.
goto _end

:_config
rem Generate dialog
echo :w_config "CD-Rom configuration" [x]> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo Dialog timeout [$ cdrom_ti,3] seconds.>> %tmp%\_cdrom.tmp
echo [!] Skip "Run CD or go config?" dialog>> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo Use [$ cdrom_drv,1,U]: as the first drive letter for CD-Rom>> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo Driver loading mode:>> %tmp%\_cdrom.tmp
echo [.] Auto, try to detect best>> %tmp%\_cdrom.tmp
echo [.] Manual, always ask user>> %tmp%\_cdrom.tmp
echo [.] Fixed, always load:>> %tmp%\_cdrom.tmp
echo     [!] Eltorito - requires %srcdrv%\lib\eltorito.cab>> %tmp%\_cdrom.tmp
echo     [!] Atapi    - requires %srcdrv%\lib\atapi.cab>> %tmp%\_cdrom.tmp
echo     [!] Scsi     - requires %srcdrv%\lib\aspi.cab (and more)>> %tmp%\_cdrom.tmp
echo.>> %tmp%\_cdrom.tmp
echo              [ Save ]  [? Cancel ]>> %tmp%\_cdrom.tmp
set wrb=%cdrom_ld%
set wcb1=%cdrom_ncfg%
set wcb2=%cdrom_elt%
set wcb3=%cdrom_ata%
set wcb4=%cdrom_scs%
call w.bat box @%tmp%\_cdrom.tmp:w_config
set cdrom_ld=%wrb%
set cdrom_ncfg=%wcb1%
set cdrom_elt=%wcb2%
set cdrom_ata=%wcb3%
set cdrom_scs=%wcb4%
if errorlevel 2 goto _end
wbat box @%ramdrv%\bin\cdrom.bat:w_wprot
if errorlevel 2 goto _start

echo CDROM: Saving configuration...
set | tfind /f1,6 "CDROM_"> %tmp%\_cdrom.tmp
type %tmp%\_cdrom.tmp | lmod /L* set []> %tmp%\_cdrom.bat
mkdir %srcdrv%\etc
type %tmp%\_cdrom.bat> %srcdrv%\etc\cdrom.set
echo CDROM: Configuration saved to %srcdrv%\etc\cdrom.set
echo.
pause
rem if drivers already loaded, quit
if exist CDEXELT1 goto _end
if exist CDEXATA1 goto _end
if exist CDEXSCS1 goto _end
goto _start
:_notagain
echo CDROM: Drivers are already loaded...
goto _autorun
:_noaspi
echo CDROM: No ASPI driver loaded
goto _abort
:_nodrv
echo CDROM: No drivers found. Add Atapi and/or SCSI CD-Rom drivers...
goto _abort
:_noaspicd
echo CDROM: File not found: %srcdrv%\lib\aspicd.cab
goto _abort
:w_cfg "Run CD or go config?" [x]
                       (%cdrom_ti% sec.)
  Running CD-Rom...

  [ Ok ] [ Config ] [? Abort ]
::
:w_wprot "Disable write protection..." [x]

  If the disk in drive %srcdrv% is write
  protected, please disable the write
  protection now in order to save settings.
  You can re-enable write protection after
  saving.

            [ Ok ]  [? Cancel ]
::
:_usage
echo Parameters:
echo -c    Config mode
echo -h    This help info
echo.
echo _end
:_error
shift
shift
echo.
echo CDROM: Error %1 %2 %3 %4 %5 %6 %7 %8
echo.
pause
goto _end
:_abort
echo CDROM: Aborted...
echo.
pause
rem flow into "_end"
:_end
rem cleanup (there is also a cleanup at "_autorun"...)
set | tfind /f1,2 "W_" >> %tmp%\_cdrom.tmp
set | tfind /f1,6 "CDROM_" >> %tmp%\_cdrom.tmp
type %tmp%\_cdrom.tmp | lmod /L* /B= set [$1]=> %tmp%\_cdrom.bat
call %tmp%\_cdrom.bat
rem cleanup some tmp files
if exist %tmp%\_cdrom.* del %tmp%\_cdrom.*
set ?=
set wcb1=
set wcb2=
set wcb3=
set wcb4=
set wcb5=
set wcb6=
set wcb7=
set wcb8=
set wcb9=
set wrb=
set wbat=
