@if "%debug%" == "" echo off
@if not "%debug%" == "" echo on
if "%1"==":" if not "%2"=="" goto %2
rem -------------------------------------------------------------------------
rem MSNET.BAT, Copyright (C) by Bart Lagerweij
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------

echo MSNET: Starting (version 2.7)
rem if not exist %ramdrv%\bin\unpack.bat %0 : _error missing unpack.bat (check modboot.cab)
if not exist %ramdrv%\bin\lmod.com %0 : _error missing lmod.com (check utils.cab)
if not exist %ramdrv%\bin\tfind.com %0 : _error missing tfind.com (check utils.cab)
if not exist %ramdrv%\bin\wbat.com %0 : _error missing wbat.com (check utils.cab)

:_start
if exist %tmp%\_msnetx.bat del %tmp%\_msnetx.bat
rem check for global settings
if not exist %srcdrv%\etc\global.set goto _noglob
type %srcdrv%\etc\global.set > %tmp%\_msnet.bat
call %tmp%\_msnet.bat
:_noglob

rem global defaults
if "%g_timeout%" == "" set g_timeout=10

rem network drivers already loaded?
if exist protman$ goto _config2

if "%1" == "-c" goto _config1
if "%1" == "/c" goto _config1
if "%1" == "-h" goto _usage
if "%1" == "/h" goto _usage

if "%g_nocfg%" == "1" goto _nocfg
wbat box @%0:w_cfg #0,%g_timeout%
if errorlevel 3 goto _end
if errorlevel 2 goto _config1
rem errorlevel 1 flow into below
:_nocfg

rem check for profiles
if not exist %srcdrv%\etc\profile\*.pro goto _nopro

rem check for fixed profile
if not "%g_fixpro%" == "1" goto _selprof
echo MSNET: Using fixed profile "%g_profile%"
if "%g_profile%" == "" goto _selprof
if not exist %srcdrv%\etc\profile\%g_profile%.pro goto _fnpro

rem check bypass
if not "%g_bypro%" == "1" goto _bypro1
echo MSNET: You are forced to use fixed profile "%g_profile%"
goto _nchkpro1
:_bypro1
wbat box @%0:w_bypro #0,%g_timeout%
if errorlevel 100 goto _nopro
if errorlevel 3 goto _end
if errorlevel 2 goto _nopro
rem if errorlevel 1 flow into below
:_nchkpro1
goto _prorun2

:_fnpro
echo MSNET: Profile not found "%g_profile%" (%srcdrv%\etc\profile\%g_profile%.pro does not exist)
:_selprof
echo :_profile " Select profile " > %tmp%\_msnet.tmp
if exist %tmp%\_msnet2.tmp del %tmp%\_msnet2.tmp
for %%i in (%srcdrv%\etc\profile\*.pro) do echo %%i >> %tmp%\_msnet2.tmp
type %tmp%\_msnet2.tmp | lmod /L* /B\. [$4] >> %tmp%\_msnet.tmp
del %tmp%\_msnet2.tmp
rem dir /b %srcdrv%\etc\profile\*.pro >> %tmp%\_msnet.tmp

rem Check if there is only one profile
type %tmp%\_msnet.tmp | lmod /L3 set wbat=[$1]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
if not "%wbat%" == "" goto _proflist
type %tmp%\_msnet.tmp | lmod /L2 set wbat=[$1]> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
set g_profile=%wbat%
echo MSNET: Only one profile found (%g_profile%), no need for user to select...

:_bypass
rem check for profile bypass
if not "%g_bypro%" == "1" goto _bypro
echo MSNET: You cannot bypass profile "%g_profile%"
goto _nchkpro
:_bypro
wbat box @%0:w_bypro #0,%g_timeout%
if errorlevel 100 goto _nopro
if errorlevel 3 goto _end
if errorlevel 2 goto _nopro
rem if errorlevel 1 flow into below
:_nchkpro
goto _prorun2

:_proflist
call w.bat list @%tmp%\_msnet.tmp:_profile
if errorlevel 100 goto _nopro
set g_profile=%wbat%
:_prorun2
type %srcdrv%\etc\profile\%g_profile%.pro > %tmp%\_msnet.bat
call %tmp%\_msnet.bat
:_nopro

rem fill some default values if empty
rem if "%p_user%" == "" set p_user=user
if "%p_ip%" == "" set p_ip=0.0.0.0
if "%p_subnet%" == "" set p_subnet=0.0.0.0
if "%p_gway%" == "" set p_gway=0.0.0.0
if "%p_dns%" == "" set p_dns=0.0.0.0
if "%p_wins%" == "" set p_wins=0.0.0.0
if "%p_timeout%" == "" set p_timeout=5
if "%p_dhcp%" == "" set p_dhcp=1
if "%p_pkt%" == "" set p_pkt=1
rem
if exist %ramdrv%\net\ndishlp.sys goto _mscl1
rem echo MSNET: Extracting "%srcdrv%\lib\msclient.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\msclient.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\msclient.cab
if not "%unpackerr%" == "" goto _abort
:_mscl1

rem check fixed mode
if not "%p_nicmode%" == "4" goto _norm
set pci0=%p_nic%
goto _pciok
:_norm
set pci0=
if not exist %srcdrv%\lib\ndis\*.cab goto _nondis
if not exist %srcdrv%\etc\_msnet.nic goto _bldnic
if not exist %srcdrv%\etc\_msnet.crc goto _pre2
rem check if driver index is up to date
if not exist %ramdrv%\bin\crc32.com goto _bldnic
dir %srcdrv%\lib\ndis\*.cab > %tmp%\_msnet.tmp
tfind "cab" %tmp%\_msnet.tmp > %tmp%\_msnet.tm2
set w_crc=
type %srcdrv%\etc\_msnet.crc | lmod /L1 set w_crc=[$2] > %tmp%\_msnet.bat
call %tmp%\_msnet.bat
echo MSNET: Driver index CRC32 is %w_crc%, checking...
crc32 %tmp%\_msnet.tm2 %w_crc%
if errorlevel 1 goto _bldnic
:_pre2
echo MSNET: Using pre-built driver index from drive %srcdrv%
if exist %srcdrv%\etc\_msnet.nic copy %srcdrv%\etc\_msnet.nic %tmp%
if exist %srcdrv%\etc\_msnet.pci copy %srcdrv%\etc\_msnet.pci %tmp%
if not exist %tmp%\_msnet.* goto _abort
goto _nic2
:_norm2
if not exist %tmp%\_msnet.nic goto _bldnic
if not exist %tmp%\_msnet.pci goto _bldnic
goto _nic2
:_bldnic
echo MSNET: Building driver list from plug-ins
echo ; This file is used to manual> %tmp%\_msnet.nic
echo ; select a network driver>> %tmp%\_msnet.nic
echo :_ndis "Select Network driver..." [x]>> %tmp%\_msnet.nic
echo ; PCI map file (build from ndis.pci files)> %tmp%\_msnet.pci
for %%i in (%srcdrv%\lib\ndis\*.cab) do call %0 : _addnic %%i
echo MSNET: Generating 32 bits CRC
dir %srcdrv%\lib\ndis\*.cab > %tmp%\_msnet.tmp
tfind "cab" %tmp%\_msnet.tmp > %tmp%\_msnet.tm2
crc32 %tmp%\_msnet.tm2 > %tmp%\_msnet.crc
rem
if not exist %ramdrv%\bin\ettool.com goto _savdrv
%ramdrv%\bin\ettool.com -e -s
if errorlevel 255 goto _abort
if errorlevel 1 goto _oncd2
goto _savdrv
:_oncd2
echo MSNET: Booted from CD-Rom, where to put pre-built index?
wbat box @%0:w_ramdrv
if errorlevel 4 goto _nic2
if errorlevel 1 set wbat=%ramdrv%
if errorlevel 2 set wbat=a:
if errorlevel 3 set wbat=b:
:_oncd3
echo MSNET: Copying to %wbat%
mkdir %wbat%\etc
copy %tmp%\_msnet.nic %wbat%\etc
copy %tmp%\_msnet.pci %wbat%\etc
copy %tmp%\_msnet.crc %wbat%\etc
goto _nic2
:_savdrv
rem Save _msnet.nic .pci .crc to %srcdrv%
rem 
echo MSNET: About to copying driver index to %srcdrv% for faster boot next time
echo MSNET: Skip this by hitting [Cancel] in the write protection dialog
wbat box @%0:w_wprot
if errorlevel 2 goto _nic2
mkdir %srcdrv%\etc
copy %tmp%\_msnet.nic %srcdrv%\etc
copy %tmp%\_msnet.pci %srcdrv%\etc
copy %tmp%\_msnet.crc %srcdrv%\etc

:_nic2
set pci0=
rem Check if any adapters are in the driver list
type %tmp%\_msnet.nic | lmod /L4 set wbat=[$1]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
if not "%wbat%" == "" goto _1nicok
echo MSNET: No network driver(s) found...
goto _abort
:_1nicok
rem Check if more than one adapters are in the list
type %tmp%\_msnet.nic | lmod /L5 set wbat=[$1]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
if not "%wbat%" == "" goto _2nicok
rem found just one, select it
type %tmp%\_msnet.nic | lmod /L4 set wbat=[$1]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
echo MSNET: Auto selecting the only driver found (%wbat%)
set pci0=%wbat%
set wbat=
goto _pciok
:_2nicok
if "%p_nicmode%" == "2" goto _auto
if "%p_nicmode%" == "3" goto _manual
:_nicprompt
rem build dynamic w_auto dialog
echo :w_auto "Auto detect PCI adapter?" [x]> %tmp%\_msnet.tmp
echo .                                                    (%p_timeout% sec)>> %tmp%\_msnet.tmp
if not exist %tmp%\_msnet.pci goto _nopci
echo [ Auto ]    Autodetect your PCI network adapter.>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
:_nopci
if not exist %tmp%\_msnet.nic goto _noman
echo [ Manual  ] Manual select your network adapter from a list.>> %tmp%\_msnet.tmp
echo .           Use this for PCMCIA and ISA based adapters.>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
:_noman
if not exist %ramdrv%\bin\ettool.com goto _rebuild
%ramdrv%\bin\ettool.com -e -s
if errorlevel 255 goto _abort
if errorlevel 1 goto _oncd1
goto _rebuild
:_oncd1
rem *SIH* Begin
rem goto _norebld
rem *SIH* End
:_rebuild
echo [ Rebuild ] Update the pre-built driver list on drive %srcdrv%.>> %tmp%\_msnet.tmp
echo .           Use this if you have added/deleted some driver>> %tmp%\_msnet.tmp
echo .           plug-in files.>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
:_norebld
echo [? Back ]    Go back>> %tmp%\_msnet.tmp
call w.bat box @%tmp%\_msnet.tmp:w_auto #0,%p_timeout%
if errorlevel 100 goto _nmback
if "%wbat%" == "Auto" goto _auto
if "%wbat%" == "Manual" goto _manual
if "%wbat%" == "Rebuild" goto _bldnic
echo MSNET: w_auto value "%wbat%" not found
goto _abort
:_nmback
if not exist %srcdrv%\etc\profile\*.pro goto _end
goto _start
:_auto
echo MSNET: PCI Network adapter detection...
rem cleanup
for %%i in (0 1 2 3 4) do set pci%%i=
%ramdrv%\bin\pciscan.exe -s -u -d -x %tmp%\_msnet.pci
if errorlevel 1 goto _pcifailed
if not "%pci0%" == "" goto _pciok
echo MSNET: PCI detection has not found a listed PCI adapter. Switching to manual!
pause
goto _manual
:_pcifailed
echo MSNET: PCI detection has failed, Switching to manual!
rem flow into "_manual"
:_manual
type %tmp%\_msnet.nic | lmod /L* [1,76] >>%tmp%\_msnet.tmp
call w.bat list @%tmp%\_msnet.tmp:_ndis
if "%wbat%" == "" goto _nicprompt
echo %wbat% | lmod set pci0=[$1]> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
set wbat=

:_pciok
if "%pci1%" == "" goto _single
rem Multiple adapters detected
echo MSNET: Multiple network adapter detected, must select one to use.
echo :_pcix " Please select which adapter to use " [x]>> %tmp%\_msnet.tmp
if "%pci0%" == "" goto _pcix0
echo %pci0%|lmod /L1 Adapter [$1] Slot [$2] Bus [$3] Device [$4] >> %tmp%\_msnet.tmp
:_pcix0
if "%pci1%" == "" goto _pcix1
echo %pci1%|lmod /L1 Adapter [$1] Slot [$2] Bus [$3] Device [$4] >> %tmp%\_msnet.tmp
:_pcix1
if "%pci2%" == "" goto _pcix2
echo %pci2%|lmod /L1 Adapter [$1] Slot [$2] Bus [$3] Device [$4] >> %tmp%\_msnet.tmp
:_pcix2
if "%pci3%" == "" goto _pcix3
echo %pci3%|lmod /L1 Adapter [$1] Slot [$2] Bus [$3] Device [$4] >> %tmp%\_msnet.tmp
:_pcix3
if "%pci4%" == "" goto _pcix4
echo %pci4%|lmod /L1 Adapter [$1] Slot [$2] Bus [$3] Device [$4] >> %tmp%\_msnet.tmp
:_pcix4
call w.bat list @%tmp%\_msnet.tmp:_pcix #0,%p_timeout%
if errorlevel 100 goto _nicprompt
echo %wbat%|lmod /L1 set p_nic=[$2]> %tmp%\_msnet.bat
echo %wbat%|lmod /L1 set p_mnic=[$4] [$6] [$8]>> %tmp%\_msnet.bat
rem cleanup
for %%i in (0 1 2 3 4) do set pci%%i=
call %tmp%\_msnet.bat
if not "%p_nic%" == "" goto _single2
echo MSNET: p_nic should not be empty at this point!
goto _abort
:_single
rem set p_nic=%pci0%
rem the first word of pci0 is the driver to use
echo %pci0%| lmod /L1 set p_nic=[$1]> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
set pci0=
:_single2
echo MSNET: Extracting driver file "%p_nic%"
if not exist %ramdrv%\lib\ndis\%p_nic%.cab goto _fromsrc
extract /y /l %ramdrv%\net\ /e %ramdrv%\lib\ndis\%p_nic%.cab
if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\msclient.cab
if not "%unpackerr%" == "" goto _abort
goto _unpok
:_fromsrc
extract /y /l %ramdrv%\net\ /e %srcdrv%\lib\ndis\%p_nic%.cab
if errorlevel 1 goto _abort
:_unpok

rem Check if network driver has an autorun.bat file
if not exist %ramdrv%\net\autorun.bat goto _noautorun
call %ramdrv%\net\autorun.bat
rem if errorlevel 1 goto _abort
del %ramdrv%\net\autorun.bat
:_noautorun
goto _nicok

:_addnic
if exist %tmp%\ndis.pci del %tmp%\ndis.pci
if exist %tmp%\ndis.txt del %tmp%\ndis.txt
extract /y /l %tmp%\ /e %3 ndis.pci ndis.txt
if errorlevel 1 goto _abort
if not exist %tmp%\ndis.txt goto _ndistxt
type %tmp%\ndis.txt >> %tmp%\_msnet.nic
:_ndistxt
if not exist %tmp%\ndis.pci goto _ndispci
type %tmp%\ndis.pci >> %tmp%\_msnet.pci
:_ndispci
if exist %tmp%\ndis.pci del %tmp%\ndis.pci
if exist %tmp%\ndis.txt del %tmp%\ndis.txt
goto _eof
:_nondis
echo MSNET: No driver files found on %srcdrv% (%srcdrv%\lib\ndis\*.cab)
goto _abort

:_nicok
rem if exist %tmp%\_msnet.pci del %tmp%\_msnet.pci

set w_netcard=
if exist %ramdrv%\net\%p_nic%.dos set w_netcard=%p_nic%.dos
if exist %ramdrv%\net\%p_nic%.exe set w_netcard=%p_nic%.exe
if not "%w_netcard%" == "" goto _drvok
echo MSNET: No driver found, %p_nic%.dos or %p_nic%.exe
goto _abort
:_drvok
if exist %ramdrv%\net\%p_nic%.ini goto _iniok
echo MSNET: Missing %p_nic%.ini
goto _abort
:_iniok
echo ; Protocol.ini generated by msnet.bat> %ramdrv%\net\protocol.ini
echo [network.setup]>> %ramdrv%\net\protocol.ini
echo version=0x3110>> %ramdrv%\net\protocol.ini
echo netcard=nu2$nic,1,NU2$NIC,1>> %ramdrv%\net\protocol.ini

rem Protocol tcp, netbeui, nwlink
if "%p_prot%" == "" goto _sprot
if "%p_prot%" == "msnetb" goto _protdone
if exist %srcdrv%\lib\%p_prot%.cab goto _protdone
echo MSNET: Could not find needed file %srcdrv%\lib\%p_prot%.cab...
echo.
pause
rem flow into _sprot
:_sprot
echo :_prot "Select protocol"> %tmp%\_msnet.tmp
if not exist %srcdrv%\lib\mstcp.cab goto _nomstcp
echo TCP/IP>> %tmp%\_msnet.tmp
:_nomstcp
if not exist %srcdrv%\lib\msnwlink.cab goto _nonwlink
echo NwLink (IPX/SPX)>> %tmp%\_msnet.tmp
:_nonwlink
echo Netbeui>> %tmp%\_msnet.tmp
rem Check if any protocol
type %tmp%\_msnet.tmp | lmod /L2 set wbat=[$1]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
if not "%wbat%" == "" goto _protok
echo MSNET: No protocol found...
goto _abort
:_protok
rem Check if only one protocol
type %tmp%\_msnet.tmp | lmod /L3 set wbat=[]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
if not "%wbat%" == "" goto _protlist
rem Only one protocol line found
type %tmp%\_msnet.tmp | lmod /L2 set wbat=[]> %tmp%\_msnet.bat
set wbat=
call %tmp%\_msnet.bat
echo MSNET: Only one protocol found, no need for user to select...
goto _protcmp
:_protlist
call w.bat list @%tmp%\_msnet.tmp:_prot #0,%p_timeout%
if "%wbat%" == "" goto _nicprompt
:_protcmp
set p_prot=
if "%wbat%" == "" goto _protsele
echo %wbat% | lmod set wbat=[$1][$2][$3][$4][$5][$6][$7][$8][$9][$10]> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
if "%wbat%" == "TCP/IP" set p_prot=mstcp
if "%wbat%" == "NwLink(IPX/SPX)" set p_prot=msnwlink
if "%wbat%" == "Netbeui" set p_prot=msnetb
if not "%p_prot%" == "" goto _protdone
:_protsele
echo MSNET: Protocol selection error...
goto _abort
:_protdone

echo MSNET: Using "%p_prot%" protocol
if not "%p_prot%" == "mstcp" goto _notcp
rem skip tcpip dialog?
if not "%p_tcpwin%" == "1" goto _tcpwin
rem before skip dialog check if ip+subnet or dhcp
if "%p_dhcp%" == "1" goto _notcp
if "%p_ip%" == "" goto _tcpwin
if "%p_subnet%" == "" goto _tcpwin
goto _notcp
:_tcpwin
set wcb1=%p_dhcp%
set wcb2=%p_pkt%
call w.bat box @%0:w_tcp #0,%p_timeout%
set p_dhcp=%wcb1%
set p_pkt=%wcb2%
if errorlevel 3 goto _sprot
if errorlevel 2 goto _end
:_notcp

rem
rem # Random Machine Name Generation
rem # Makes a new name if name is Blank or starts with PC
if "%p_mname%" == "" goto _newname
echo %p_mname%|lmod set tmachn=[1,3]> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
if "%tmachn%" == "PC-" goto _newname
goto _nameok
:_newname
rem take last 3 numbers from time command
echo.|time|lmod /L1 /S;:,.apm set p_mname=PC-[$!-2][$!-1][$!]>%tmp%\_msnet.bat
call %tmp%\_msnet.bat
del %tmp%\_msnet.bat
:_nameok
set tmachn=

rem # Set workgroup if empty
if "%p_wrkgrp%" == "" set p_wrkgrp=workgroup
rem
rem Prompt for parameters
REM # Allow Bypass box
if "%p_idwin%" == "1" goto _nobox
:_save
rem password *must* be empty before wbat dialog
rem set pass=
rem
set wcb1=%w_pini%
set wcb2=%w_sini%
set wcb3=%w_elmhost%
if not "%p_user%" == "" call w.bat box @%0:w_param #0,%p_timeout%
if "%p_user%" == "" call w.bat box @%0:w_param
set w_pini=%wcb1%
set w_sini=%wcb2%
set w_elmhost=%wcb3%
if errorlevel 5 goto _sprot
if errorlevel 4 goto _end
if errorlevel 3 goto _help
if errorlevel 2 goto _savpro
rem if 1 flow into below
:_nobox
rem
rem set workgroup if empty
if "%p_wrkgrp%" == "" set p_wrkgrp=workgroup
rem set user if empty
if "%p_user%" == "" set p_user=none
rem
rem if user has typed a password put it in "w_passwd"
rem if "%pass%" == "" goto _nopasswd
rem set w_passwd=%pass%
rem set pass=
:_nopasswd
rem
if not "%p_prot%" == "mstcp" goto _skipip1

rem tcp/ip mode
if exist %ramdrv%\net\tcpdrv.dos goto _tcpdrv1
rem echo MSNET: Extracting "%srcdrv%\lib\mstcp.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\mstcp.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\mstcp.cab
if not "%unpackerr%" == "" goto _abort
:_tcpdrv1
if exist %srcdrv%\etc\lmhosts type %srcdrv%\etc\lmhosts > %ramdrv%\net\lmhosts
if exist %srcdrv%\etc\hosts type %srcdrv%\etc\hosts > %ramdrv%\net\hosts
  
echo transport=tcpip,TCPIP>> %ramdrv%\net\protocol.ini
echo lana0=nu2$nic,1,tcpip>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [tcpip]>> %ramdrv%\net\protocol.ini
rem
if not "%p_dhcp%" == "1" goto _nodhcp
echo @echo off> %ramdrv%\net\ipconfig.bat
echo ipconfg.exe %ramdrv%\net>> %ramdrv%\net\ipconfig.bat
:_nodhcp

rem if no dhcp selected jump to _dhcp1
if "%p_dhcp%" == "1" goto _dhcp1

if not "%p_ip%" == "" goto _ipaddr
echo MSNET: IP address cannot be empty, when DHCP is enabled
goto _abort

:_ipaddr
echo %p_ip% | lmod /S. set wbat=[$1] [$2] [$3] [$4]> %tmp%\_msnet.bat
if errorlevel 1 goto _abort
call %tmp%\_msnet.bat
echo ipaddress0=%wbat%>> %ramdrv%\net\protocol.ini

if not "%p_subnet%" == "" goto _subnt
echo MSNET: Subnetmask cannot be empty, when DHCP is enabled
goto _abort

:_subnt
echo %p_subnet% | lmod /S. set wbat=[$1] [$2] [$3] [$4]> %tmp%\_msnet.bat
if errorlevel 1 goto _abort
call %tmp%\_msnet.bat
echo subnetmask0=%wbat%>> %ramdrv%\net\protocol.ini

if "%p_gway%" == "" goto _nogatew
echo %p_gway% | lmod /S. set wbat=[$1] [$2] [$3] [$4]> %tmp%\_msnet.bat
if errorlevel 1 goto _abort
call %tmp%\_msnet.bat
echo defaultgateway0=%wbat%>> %ramdrv%\net\protocol.ini
:_nogatew

if "%p_wins%" == "" goto _nowins
echo %p_wins% | lmod /S. set wbat=[$1] [$2] [$3] [$4]> %tmp%\_msnet.bat
if errorlevel 1 goto _abort
call %tmp%\_msnet.bat
echo wins_server0=%wbat%>> %ramdrv%\net\protocol.ini
:_nowins

:_dhcp1
echo NBSessions=6>> %ramdrv%\net\protocol.ini
echo DriverName=TCPIP$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini
echo LANABASE=0>> %ramdrv%\net\protocol.ini

if "%p_pkt%" == "1" goto _pkt
rem no pktdrv
ini %ramdrv%\net\system.ini write "network drivers" transport "tcpdrv.dos,nemm.dos"
if errorlevel 1 goto _abort
goto _pktdone
:_pkt
ini %ramdrv%\net\system.ini write "network drivers" transport "tcpdrv.dos,nemm.dos,dis_pkt.dos"
if errorlevel 1 goto _abort
:_pktdone

if "%p_dhcp%" == "1" ini %ramdrv%\net\protocol.ini write "tcpip" DisableDHCP "0"
if not "%p_dhcp%" == "1" ini %ramdrv%\net\protocol.ini write "tcpip" DisableDHCP "1"
if errorlevel 1 goto _abort
:_skipip1

if not "%p_prot%" == "msnwlink" goto _skipnw1
rem nwlink mode
if exist %ramdrv%\net\nwlink.exe goto _nwlink1
rem echo MSNET: Extracting "%srcdrv%\lib\msnwlink.cab"
rem extract /y /l %ramdrv%\ /e %srcdrv%\lib\msnwlink.cab
rem if errorlevel 1 goto _abort
call %ramdrv%\bin\unpack.bat %srcdrv%\lib\msnwlink.cab
if not "%unpackerr%" == "" goto _abort
:_nwlink1
echo transport=nu2$nwlink,NU2$NWLINK>> %ramdrv%\net\protocol.ini
echo transport=nu2$ndishlp,NU2$NDISHLP>> %ramdrv%\net\protocol.ini
echo lana0=nu2$nic,1,nu2$nwlink>> %ramdrv%\net\protocol.ini
echo lana1=nu2$nic,1,nu2$ndishlp>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [NU2$NWLINK]>> %ramdrv%\net\protocol.ini
echo FRAME=ETHERNET_802.2>> %ramdrv%\net\protocol.ini
echo DriverName=nwlink$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini
echo LANABASE=0>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [protman]>> %ramdrv%\net\protocol.ini
echo DriverName=PROTMAN$>> %ramdrv%\net\protocol.ini
echo PRIORITY=NU2$NDISHLP>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [NU2$NDISHLP]>> %ramdrv%\net\protocol.ini
echo DriverName=ndishlp$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini

ini %ramdrv%\net\system.ini write "network drivers" transport "ndishlp.sys"
if errorlevel 1 goto _abort
:_skipnw1

if not "%p_prot%" == "msnetb" goto _skipnb1
rem netbeui mode

echo transport=nu2$ndishlp,NU2$NDISHLP>> %ramdrv%\net\protocol.ini
echo transport=nu2$netbeui,NU2$NETBEUI>> %ramdrv%\net\protocol.ini
echo lana0=nu2$nic,1,nu2$netbeui>> %ramdrv%\net\protocol.ini
echo lana1=nu2$nic,1,nu2$ndishlp>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [NU2$NETBEUI]>> %ramdrv%\net\protocol.ini
echo NCBS=8>> %ramdrv%\net\protocol.ini
echo SESSIONS=3>> %ramdrv%\net\protocol.ini
echo DriverName=netbeui$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini
echo LANABASE=0>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [protman]>> %ramdrv%\net\protocol.ini
echo DriverName=PROTMAN$>> %ramdrv%\net\protocol.ini
echo PRIORITY=NU2$NDISHLP>> %ramdrv%\net\protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [NU2$NDISHLP]>> %ramdrv%\net\protocol.ini
echo DriverName=ndishlp$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini

ini %ramdrv%\net\system.ini write "network drivers" transport "ndishlp.sys,*netbeui"
if errorlevel 1 goto _abort
:_skipnb1

if not "%p_prot%" == "mstcp" goto _nopkt2
if not "%p_pkt%" == "1" goto _nopkt2
rem xxx Add Multicast Packet driver to protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [pktdrv]>> %ramdrv%\net\protocol.ini
echo DriverName=PKTDRV$>> %ramdrv%\net\protocol.ini
echo BINDINGS=NU2$NIC>> %ramdrv%\net\protocol.ini
echo intvec=0x60>> %ramdrv%\net\protocol.ini
echo chainvec=0x66>> %ramdrv%\net\protocol.ini
:_nopkt2

rem Add adapter part to protocol.ini
echo.>> %ramdrv%\net\protocol.ini
echo [NU2$NIC]>> %ramdrv%\net\protocol.ini
type %ramdrv%\net\%p_nic%.ini>> %ramdrv%\net\protocol.ini

rem When multi-adapter, add bus, dev or slot number
if "%p_mnic%" == "" goto _nomnic
rem echo SLOT=%slot0%>> %ramdrv%\net\protocol.ini
%ramdrv%\bin\bfind devnum %ramdrv%\net\%w_netcard%
if errorlevel 1 goto _busdev
rem using slot style
echo MSNET: Adding slot number to protocol.ini
echo %p_mnic%|lmod /L1 slot=[$1]>> %ramdrv%\net\protocol.ini
goto _nomnic
:_busdev
rem using bus/dev style
echo MSNET: Adding busnum and devnum to protocol.ini
echo %p_mnic%|lmod /L1 busnum=[$2]>> %ramdrv%\net\protocol.ini
echo %p_mnic%|lmod /L1 devnum=[$3]>> %ramdrv%\net\protocol.ini
:_nomnic
rem * change system.ini
ini %ramdrv%\net\system.ini write "network" username "%p_user%"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "network" workgroup "%p_wrkgrp%"
if errorlevel 1 goto _abort
rem
rem check logon domain
if "%p_ntdom%" == "" goto _lm0
ini %ramdrv%\net\system.ini write "network" lmlogon "1"
ini %ramdrv%\net\system.ini write "network" logondomain "%p_ntdom%"
ini %ramdrv%\net\system.ini write "network" preferredredir "full"
if errorlevel 1 goto _abort
goto _lmdone
:_lm0
ini %ramdrv%\net\system.ini write "network" lmlogon "0"
ini %ramdrv%\net\system.ini write "network" preferredredir "basic"
if errorlevel 1 goto _abort
:_lmdone

ini %ramdrv%\net\system.ini write "network" computername "%p_mname%"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "network" lanroot "%ramdrv%\net"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "network drivers" netcard "%w_netcard%"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "network drivers" devdir "%ramdrv%\net"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "Password Lists" %p_user% "%ramdrv%\net\%p_user%.pwl"
if errorlevel 1 goto _abort
ini %ramdrv%\net\system.ini write "Password Lists" *Shares "%ramdrv%\net\shares.pwl"
if errorlevel 1 goto _abort

rem check edit some files
if "%w_pini%" == "1" goto _editsome
if "%w_sini%" == "1" goto _editsome
if "%w_elmhost%" == "1" goto _editsome
goto _editnon
:_editsome
if exist %ramdrv%\bin\edit.com goto _editok
echo MSNET: Cannot edit the file you marked, %ramdrv%\bin\edit.com does not exist...
pause
goto _editnon
:_editok
if "%w_pini%" == "1" edit %ramdrv%\net\protocol.ini
if "%w_sini%" == "1" edit %ramdrv%\net\system.ini
if "%w_elmhost%" == "1" edit %ramdrv%\net\lmhosts
:_editnon

rem check for slowdown
if "%p_slow%" == "" goto _noslow
%ramdrv%\net\slowdown /d /v /p:%p_slow%
:_noslow

rem delete any copied ndis driver cab files
if exist %ramdrv%\lib\ndis\*.cab del %ramdrv%\lib\ndis\*.cab
set path=%ramdrv%\net;%path%
%ramdrv%
cd \net

if not "%p_prot%" == "mstcp" goto _skipip2
if "%os%" == "fd" goto _netfd
rem non freedos
echo MSNET: Network initializing
net init
if errorlevel 1 goto _abort
echo MSNET: loading NETBIND
rem netbind cannot be loaded high!
netbind
if errorlevel 1 goto _abort
echo MSNET: loading high UMB
lh umb
if errorlevel 1 goto _abort
echo MSNET: loading high TCPTSR
lh tcptsr
if errorlevel 1 goto _abort
goto _netfd2

:_netfd
echo MSNET: Network initializing (freedos - loading low)
loadlow net init
if errorlevel 1 goto _abort
echo MSNET: loading NETBIND
netbind
if errorlevel 1 goto _abort
echo MSNET: loading high UMB
lh umb
if errorlevel 1 goto _abort
echo MSNET: loading TCPTSR
tcptsr
if errorlevel 1 goto _abort
:_netfd2

if not "%p_dhcp%" == "1" goto _dhcp2
%ramdrv%\net\ipconfg.exe %ramdrv%\net | tfind "Domainname" > %tmp%\_msnet.tmp
type %tmp%\_msnet.tmp | lmod /S: set p_domain=[$2] > %tmp%\_msnet.bat
%ramdrv%\net\ipconfg.exe %ramdrv%\net | tfind "Primary DNS Server" > %tmp%\_msnet.tmp
type %tmp%\_msnet.tmp | lmod /S: set p_dns=[$4] >> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
:_dhcp2

rem
rem check if DNS ipaddress is empty
if "%p_dns%" == "" goto _nodns
echo %p_dns% | lmod /S. set wbat=[$1] [$2] [$3] [$4]> %tmp%\_msnet.bat
if errorlevel 1 goto _abort
call %tmp%\_msnet.bat
rem fill the ipaddresses into tcputils.ini
ini %ramdrv%\net\tcputils.ini write "dnr" nameserver0 "%wbat%"
if errorlevel 1 goto _abort
:_nodns

if "%p_domain%" == "" goto _nodomsuf
if not "%p_dhcp%" == "1" echo echo .  DNS suffix     : %p_domain% >> %ramdrv%\net\ipconfig.bat
ini %ramdrv%\net\tcputils.ini write "dnr" domain "%p_domain%"
if errorlevel 1 goto _abort
:_nodomsuf

rem generate wattcp.cfg
echo MSNET: Creating WATTCP.CFG file
echo # Barts Network boot disk> %ramdrv%\net\wattcp.cfg
echo # Waterloo TCP/IP configuration file>> %ramdrv%\net\wattcp.cfg
echo print = "Barts Network boot disk - Waterloo TCP/IP setup">> %ramdrv%\net\wattcp.cfg
if "%p_dhcp%" == "1" goto _watdhcp
echo my_ip = %p_ip%>> %ramdrv%\net\wattcp.cfg
goto _watdhc2
:_watdhcp
echo my_ip = dhcp>> %ramdrv%\net\wattcp.cfg
:_watdhc2
echo hostname = %p_mname%>> %ramdrv%\net\wattcp.cfg
echo netmask = %p_subnet%>> %ramdrv%\net\wattcp.cfg
echo nameserver = %p_dns%>> %ramdrv%\net\wattcp.cfg
echo gateway = %p_gway%>> %ramdrv%\net\wattcp.cfg
echo domain_list = %p_domain%>> %ramdrv%\net\wattcp.cfg
set wattcp.cfg=%ramdrv%\net

if "%p_dhcp%" == "1" goto _noipcfg
rem Build the ipconfig.bat file
echo @echo off > %ramdrv%\net\ipconfig.bat
echo echo.>> %ramdrv%\net\ipconfig.bat
echo echo IP configuration:>> %ramdrv%\net\ipconfig.bat
echo echo .  Host Name............... : %p_mname%>> %ramdrv%\net\ipconfig.bat
echo echo .  DNS Server.............. : %p_dns%>> %ramdrv%\net\ipconfig.bat
echo echo .  Domain Suffix........... : %p_domain%>> %ramdrv%\net\ipconfig.bat
if "%p_pkt%" == "1" goto _ippkt
echo .  Packet Driver Interface. : No>> %ramdrv%\net\ipconfig.bat
goto _ippkt2
:_ippkt
echo .  Packet Driver Interface. : Yes>> %ramdrv%\net\ipconfig.bat
:_ippkt2
echo echo.>> %ramdrv%\net\ipconfig.bat
echo echo Adapter %p_nic%:>> %ramdrv%\net\ipconfig.bat
echo echo .  IP Address.............. : %p_ip% >> %ramdrv%\net\ipconfig.bat
echo echo .  Subnet Mask............. : %p_subnet% >> %ramdrv%\net\ipconfig.bat
echo echo .  Default Gateway......... : %p_gway% >> %ramdrv%\net\ipconfig.bat
:_noipcfg

echo MSNET: loading TINYRFC
rem Tinyrfc loading high OK? Problems with E100b/isolinux/memdisk?
rem Better not loadhigh!
tinyrfc
if errorlevel 1 goto _abort
echo MSNET: loading NMTSR
rem Don't loadhigh nmtsr, conflicts within isolinux/memdisk
nmtsr
if errorlevel 1 goto _abort
rem do we need emsbfr?
echo MSNET: loading high EMSBFR
lh emsbfr
if errorlevel 1 goto _abort
rem dhcp disabled=0 ? - load dnr
if "%p_dhcp%" == "1" goto _dns2
rem no name server ip? - do not load dnr
if "%p_dns%" == "" goto _nodns2
:_dns2
echo MSNET: loading high DNR
lh dnr.exe
rem maybe no abort on this (not that critical)
rem if errorlevel 1 goto _abort
:_nodns2
:_skipip2

if not "%p_prot%" == "msnwlink" goto _skipnw2
net init
if errorlevel 1 goto _abort
echo MSNET: loading high NWLINK
lh nwlink.exe
if errorlevel 1 goto _abort
rem flow into _skipnw2
:_skipnw2
echo MSNET: Starting network services
net start workstation
if errorlevel 1 goto _abort
rem
rem logon to network
:_logon
echo MSNET: Network logon as "%p_user%"
net logon %p_user% %w_passwd% /yes /savepw:no
if errorlevel 1 pause
set prompt=%p_user%@%p_mname% $p$g
rem
if exist %tmp%\_msnetx.bat del %tmp%\_msnetx.bat
if not exist %srcdrv%\etc\autoexec.net goto _noautonet
echo MSNET: %srcdrv%\etc\autoexec.net found
type %srcdrv%\etc\autoexec.net >> %tmp%\_msnetx.bat
:_noautonet
if "%g_profile%" == "" goto _noprf1
if not exist %srcdrv%\etc\profile\%g_profile%.net goto _noprf1
type %srcdrv%\etc\profile\%g_profile%.net >> %tmp%\_msnetx.bat
echo MSNET: %srcdrv%\etc\profile\%g_profile%.net found
:_noprf1
if not "%p_prot%" == "mstcp" goto _end
rem
rem dhcp disabled=0 ? echo message
echo.
echo MSNET: Type "ipconfig" to view TCP/IP settings...
if not exist %srcdrv%\etc\autoexec.net echo MSNET: Type "msnet" to connect a drive to a network share...
goto _end
rem
rem save configuration
:_savpro
call w.bat box @%0:w_proname
if errorlevel 2 goto _save
if not exist %srcdrv%\etc\profile\%g_profile%.pro goto _savecfg
call w.bat box @%0:w_pwrite
if errorlevel 2 goto _save
:_savecfg
set wrb=%p_nicmode%
set wcb1=%p_tcpwin%
set wcb2=%p_idwin%
set wcb3=%w_savepw%
call w.bat box @%0:w_savecfg
set p_nicmode=%wrb%
set p_tcpwin=%wcb1%
set p_idwin=%wcb2%
set w_savepw=%wcb3%
if errorlevel 2 goto _savpro
rem if 1 flow into below
wbat box @%0:w_wprot
if errorlevel 2 goto _save
echo MSNET: Saving profile "%g_profile%"
rem if "%p_nicmode%" == "4" echo set p_nic=%p_nic%>> %tmp%\_msnet.bat
set | tfind /f1,2 "P_"> %tmp%\_msnet.tmp
if "%w_savepw%" == "1" echo W_PASSWD=%w_passwd%>> %tmp%\_msnet.tmp
type %tmp%\_msnet.tmp | lmod /L* set []> %tmp%\_msnet.bat

mkdir %srcdrv%\etc
mkdir %srcdrv%\etc\profile
type %tmp%\_msnet.bat> %srcdrv%\etc\profile\%g_profile%.pro
echo MSNET: Configuration saved to %srcdrv%\etc\profile\%g_profile%.pro
echo.
pause
goto _save
rem
rem help information
:_help
wbat box @%0:w_help
goto _save

:_config2
echo MSNET: Network services already loaded, going "config"
:_config1
echo :w_config "MSNET config" [x]> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
echo [ Global ]   Global settings, autoexec.net, lmhosts>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
echo [ Profile ]  Edit, delete profiles>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
if not exist protman$ goto _noprotm
echo [ Map ]      Connect drive to network share>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
echo [ Relogon ]  Logon as a different user>> %tmp%\_msnet.tmp
echo.>> %tmp%\_msnet.tmp
:_noprotm
echo [? Exit ]     Exit>> %tmp%\_msnet.tmp
call w.bat box @%tmp%\_msnet.tmp:w_config
if errorlevel 100 goto _end
if "%wbat%" == "Global" goto _chgglo
if "%wbat%" == "Profile" goto _chgpro
if "%wbat%" == "Map" goto _mapdrv
if "%wbat%" == "Relogon" goto _relogon
echo MSNET: w_config value "%wbat%" not found
goto _abort
:_mapdrv
if "%w_path%" == "" set w_path=\\server\share
call w.bat box @%0:w_map
if errorlevel 100 goto _config1
rem convert to lowercase
echo %w_drv% |lmod set w_drv=[$1 L]> %tmp%\_msnet.bat
echo %ramdrv% |lmod set ramdrv=[$1 L]>> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
if "%w_drv%:" == "%ramdrv%" goto _baddrv
echo MSNET: Connecting drive %w_drv%: to %w_path%...
%ramdrv%\net\net use %w_drv%: %w_path% /savepw:no /yes
if errorlevel 1 goto _abort
if not "%wcb1%" == "1" goto _norec
wbat box @%0:w_wprot
if errorlevel 2 goto _config1
echo MSNET: Adding mapping to %srcdrv%\etc\autoexec.net
mkdir %srcdrv%\etc
echo @echo Connecting drive %w_drv%: to %w_path%...>> %srcdrv%\etc\autoexec.net
echo @%ramdrv%\net\net use %w_drv%: %w_path% /savepw:no /yes>> %srcdrv%\etc\autoexec.net
echo @if errorlevel 1 pause>> %srcdrv%\etc\autoexec.net
:_norec
goto _config1
:_baddrv
echo MSNET: You cannot use drive %w_drv%:, it's in use by the ramdrive...
echo.
pause
goto _mapdrv
:_relogon
call w.bat box @%0:w_relogon
if errorlevel 100 goto _config1
echo MSNET: logging off
net logoff /yes
if errorlevel 1 goto _abort
goto _logon
:_chgpro
if exist %srcdrv%\etc\profile\*.pro goto _prosel
echo MSNET: No profiles found...
echo You can save to a profile using the save button in the identification dialog
echo.
pause
goto _config1
:_prosel
rem select a profile
echo :_profile " Select profile to change " > %tmp%\_msnet.tmp
if exist %tmp%\_msnet2.tmp del %tmp%\_msnet2.tmp
for %%i in (%srcdrv%\etc\profile\*.pro) do echo %%i >> %tmp%\_msnet2.tmp
type %tmp%\_msnet2.tmp | lmod /L* /B\. [$4] >> %tmp%\_msnet.tmp
del %tmp%\_msnet2.tmp
call w.bat list @%tmp%\_msnet.tmp:_profile
if errorlevel 100 goto _config1
set w_profile=%wbat%
:_edtpro
rem
call w.bat box @%0:w_chgpro
if errorlevel 4 goto _config1
if errorlevel 3 goto _delpro
if errorlevel 2 goto _netpro
if errorlevel 1 goto _editpro
goto _save
:_editpro
edit %srcdrv%\etc\profile\%w_profile%.pro
goto _edtpro
:_netpro
edit %srcdrv%\etc\profile\%w_profile%.net
goto _edtpro
:_delpro
call w.bat box @%0:w_delpro
if errorlevel 2 goto _edtpro
del %srcdrv%\etc\profile\%w_profile%.*
echo MSNET: Profile "%w_profile%" deleted.
echo.
pause
goto _config1
:_chgglo
call w.bat box @%0:w_chgglo
if errorlevel 4 goto _config1
if errorlevel 3 goto _netlmh
if errorlevel 2 goto _netglo
if errorlevel 1 goto _setglo
goto _save
:_netglo
if exist %srcdrv%\etc\autoexec.net goto _netglo1

wbat box @%0:w_wprot
if errorlevel 2 goto _chgglo
echo MSNET: autoexec.net does not exist, creating a sample file...
mkdir %srcdrv%\etc
echo rem Bart's Network boot disk - autoexec.net file> %srcdrv%\etc\autoexec.net
echo rem>> %srcdrv%\etc\autoexec.net
echo rem Use this batch file for your global drive mappings or to start any>> %srcdrv%\etc\autoexec.net
echo rem application you want.>> %srcdrv%\etc\autoexec.net
echo rem Example:>> %srcdrv%\etc\autoexec.net
echo rem net use f: \\server\share>> %srcdrv%\etc\autoexec.net
:_netglo1
edit %srcdrv%\etc\autoexec.net
goto _chgglo
:_netlmh
if exist %srcdrv%\etc\lmhosts goto _netlmh1
wbat box @%0:w_wprot
if errorlevel 2 goto _chgglo
echo MSNET: lmhosts does not exist, creating a sample file...
mkdir %srcdrv%\etc
echo # Bart's Network boot disk - LMHOSTS file> %srcdrv%\etc\lmhosts
echo #>> %srcdrv%\etc\lmhosts
echo # Sample line:>> %srcdrv%\etc\lmhosts
echo # 192.168.0.10    server1>> %srcdrv%\etc\lmhosts
echo.>> %srcdrv%\etc\lmhosts
:_netlmh1
edit %srcdrv%\etc\lmhosts
goto _chgglo
:_setglo
set wcb1=%g_fixpro%
set wcb2=%g_bypro%
set wcb3=%g_nocfg%
call w.bat box @%0:w_global
set g_fixpro=%wcb1%
set g_bypro=%wcb2%
set g_nocfg=%wcb3%
if errorlevel 2 goto _chgglo
echo MSNET: Saving global settings
if exist %srcdrv%\etc\global.set del %srcdrv%\etc\global.set
if exist %srcdrv%\etc\global.set goto _gloerr1
mkdir %srcdrv%\etc
echo set g_fixpro=%g_fixpro%> %srcdrv%\etc\global.set
echo set g_bypro=%g_bypro%>> %srcdrv%\etc\global.set
echo set g_profile=%g_profile%>> %srcdrv%\etc\global.set
echo set g_timeout=%g_timeout%>> %srcdrv%\etc\global.set
echo set g_nocfg=%g_nocfg%>> %srcdrv%\etc\global.set
if not exist %srcdrv%\etc\global.set goto _gloerr1
echo MSNET: Global settings saved to "%srcdrv%\etc\global.set"
echo.
pause
goto _chgglo
:_gloerr1
echo MSNET: Error saving global settings
echo.
pause
goto _setglo
rem
:w_delpro "Delete profile?" [x]

 About to delete profile "%w_profile%"
 Are you sure?

         [ Yes ]  [? No ]
::
:w_chgpro "Profile settings" [x]

 Selected profile: %w_profile%

 [ Edit ]    Edit profile using a text editor (advanced)

 [ Batch ]   Edit the profile batch file using a text editor

 [ Delete ]  Delete this profile

 [? Back ]    Go back

::
:w_chgglo "Global settings" [x]

 [ Settings ]      Change global settings

 [ Autoexec.net ]  Edit the global autoexec.net batch file

 [ Lmhosts ]       Edit lmhosts file

 [? Back ]          Go back
::
:w_global "Global settings" [x]

 Timeout [$ g_timeout,3] seconds.

 [!] Use a fixed profile: [$ g_profile,8]
     [!] No bypass
 
 [!] Skip "Goto config?" dialog

      [ Save ]  [? Cancel ]
::
:w_param "Identification Settings" [x]
                                                  (%p_timeout% sec.)
Logon as       : [$ p_user,20,U                  ]   Edit..
Password       : [$ w_passwd,14,P  ]         protocol.ini : [!]
Machine name(1): [$ p_mname,15,U]        system.ini   : [!]
Workgroup      : [$ p_wrkgrp,15,U  ]        lmhosts      : [!]
Domain      (2): [$ p_ntdom,15,U]        CPU speed    : [$ p_slow,3]%
 
 (1) When starting with "PC-" a random name will be used
 (2) Requires full redirector and uses much more base memory
  
       [ OK ]  [ Save ]  [ Help ]  [ Abort ]  [? Back ]
::
:w_tcp "TCP/IP Parameters" [x]
                                     (%p_timeout% sec.)
[!] Enable DHCP

 IP address   :*[$ p_ip,15!    ]
 Subnet Mask  :*[$ p_subnet,15!]
 Gateway      :*[$ p_gway,15   ]
 Wins Server  :*[$ p_wins,15   ]
 Name Server  :*[$ p_dns,15    ]
 DNS Suffix   :*[$ p_domain,30               ]

[!] Load Packet Driver Interface

        * Not used when DHCP enabled

         [ OK ] [ Abort ] [? Back ]
::
:w_pwrite "Overwrite profile?" [x]

 A profile with the name "%g_profile%"
 already exists, overwrite?

        [ Yes ]  [? No ]
::
:w_proname "Enter profile name" [x]

 Enter profile name: [$ g_profile,8]

      [ OK ] [? Cancel ]
::
:w_savecfg "Save profile" [x]

Network adapter detection mode:
  [.] Prompt  [.] Auto  [.] Manual  [.] %p_nic%

[!] Skip TCP/IP parameter dialog
[!] Skip identification dialog
[!] Save password (in clear text, not secure!)

Dialog timeout [$ p_timeout,3] seconds.
               (0 means disabled)

Configuration will be saved to:
%srcdrv%\etc\profile\%g_profile%

               [ Ok ]  [? Cancel ]
::
:w_bypro "Profile OK?" [x]
                       (%g_timeout% sec.)
  About to process
  profile "%g_profile%"...

   [ Ok ] [? Cancel ] [ Abort ]
::
:w_cfg "Continue or goto config?" [x]
                       (%g_timeout% sec.)
  Running Network Client...

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
:w_ramdrv "Where to store driver index files?" [x]

  [ Ramdisk ]   Copy to ramdisk (%ramdrv%)
  
  [ Drive &A: ]  If booted from Floppy choose to A:
  
  [ Drive &B: ]  If booted from CD-Rom choose to B:
                Then create isoimage again with new 
                _msnet.pci, _msnet.txt and _msnet.crc
               
  [? Cancel ]    Don't copy
::
:w_relogon "Logon as a different user" [x]

Logon as : [$ p_user,20,U                  ]
Password : [$ w_passwd,14,P  ]

     [ Ok ]  [? Cancel ]
::
:w_map "Map drive" [x]

Drive : [$ w_drv,1,U! ]
Path  : [$ w_path,30,!               ]
[!] Reconnect at logon

         [ Ok ]  [? Cancel ]
::
:w_help "Help"

The help info has been removed
from the batchfile.

Please visit
http://www.nu2.nu/bootdisk/network/
for more information.

             [ Ok ]
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
echo MSNET: Error %1 %2 %3 %4 %5 %6 %7 %8
echo.
pause
goto _end
:_abort
echo.
echo MSNET: aborted...
echo.
pause
rem flow into "_end"
:_end
rem cleanup variables starting with "p_", "w_" and "g_"
set | tfind /f1,2 "P_" > %tmp%\_msnet.tmp
set | tfind /f1,2 "W_" >> %tmp%\_msnet.tmp
set | tfind /f1,2 "G_" >> %tmp%\_msnet.tmp
type %tmp%\_msnet.tmp | lmod /L* /B= set [$1]=> %tmp%\_msnet.bat
call %tmp%\_msnet.bat
rem cleanup some tmp files
if exist %tmp%\_msnet.* del %tmp%\_msnet.*
rem cleanup environment
for %%i in (0 1 2 3 4) do set pci%%i=
for %%i in (1 2 3 4 5 6 7 8 9) do set wcb%%i=
for %%i in (wrb wbat ?) do set %%i=
if exist %tmp%\_msnetx.bat %tmp%\_msnetx.bat
:_eof
