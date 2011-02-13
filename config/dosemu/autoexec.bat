@echo off
for %%i in (C D E F) do if exist %%i:\dosemu\lredir.com goto in_%%i
goto skip

:in_C
set dosemu=C:
goto setup

:in_D
set dosemu=D:
goto setup
:in_E
set dosemu=E:
goto setup
:in_F
set dosemu=E:
goto setup


:setup
set path=%DOSEMU%\BIN;%DOSEMU%\GNU;%DOSEMU%\DOSEMU
%dosemu%\dosemu\lredir.com r: linux\fs\myplace\wdata
%dosemu%\dosemu\lredir.com x: linux\fs\myplace\wsys
goto end

:skip
:end
