@echo off
if not exist %FS_ROOT%bin\udos.bat goto no_udos
call %FS_ROOT%bin\udos.bat
goto end
:n_udos
call %FS_ROOT%bin\_udos.bat win98se
:end