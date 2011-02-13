@echo on
rem set choice=choice /d y /t 3
set choice=choice
if not  exist minidos.raw goto create 
%choice% /c yn /m "Delete minidos.raw"
if errorlevel 2 goto create
del minidos.raw

:create
%choice% /c yn /m "Create minidos.raw"
if errorlevel 2 goto format
call img-new minidos.raw 100M

:format
%choice% /c yn /m "Format minidos.raw"
if errorlevel 2 goto mount
call qemu.bat -no-acpi -boot a -fda format.img -hda minidos.raw

:mount
imdisk.exe -a -m a: -v 1 -f minidos.raw
if not exist a:\ goto error_nd

%choice% /c yn /m "Update files"
if errorlevel 2 goto umount
call bin\update.cmd .. a:

%choice% /c yn /m "List minidos.raw"
if errorlevel 2 goto umount
tree /f a: | more

:umount
call img-umount a: 
goto end

:error_nd
echo Error minidos.raw neither mounted nor formated
goto end

:end

