@echo off
if not exist %FS_ROOT%work\NUL goto end
set PRNHEAD=Work
call addpath.bat %FS_ROOT%work\bin
:end
set PRNHEAD=
