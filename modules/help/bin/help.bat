@echo off
rem -----------------------
rem HELP.BAT
rem (c) 2002 Bart Lagerweij
rem -----------------------
echo.
echo You can use the following commands:
echo -------------------------------------------------------------------------------
for %%i in (%ramdrv%\help\*.hlp) do type %%i
echo.
