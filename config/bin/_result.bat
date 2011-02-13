@echo off
REM if not X == X%FS_ROOT% goto end
if not exist %tmp%\errors.txt goto tips
:error
type %tmp%\errors.txt
del %tmp%\errors.txt
:tips
if not exist %tmp%\tips.txt goto end
type %tmp%\tips.txt
del %tmp%\tips.txt
:end