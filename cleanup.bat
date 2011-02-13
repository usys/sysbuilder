@echo off
set dp=%~dp0
rem delete config file
if exist %bfd_target%\kernel.sys goto skip1
if exist %bfd_target%\fdkernel.sys	goto skip1
if exist %bfd_target%\fdconfig.sys	del %bfd_target%\fdconfig.sys

:skip1
REM echo Compress(UPX) %bfd_target\bin\*.* if possible ...
REM if exist %bfd_target%\bin\*.* upx.exe --mono --8086 --best -q --brute %bfd_target%\bin\*.* >NUL 2>&1


:skip2
if not exist %bfd_target%\openmod\unlha.bat goto skip3
echo Reconstruct %bfd_target%\level*\*.lha ...

if exist %temp%\_lhaom_ rd /s /q %temp%\_lhaom_
md %temp%\_lhaom_
pushd %temp%\_lhaom_
md autoruns
md autoruns\level1
md autoruns\level2
md autoruns\level3

for %%i in (%bfd_target%\level0\*.lha) do "%dp%\bin\lha.exe" x -q -f %%i
for %%j in (1 2 3) do for %%i in (%bfd_target%\level%%j\*.lha) do (
		"%dp%\bin\lha.exe" x -q -f %%i 
		if exist %temp%\_lhaom_\autorun.bat move %temp%\_lhaom_\autorun.bat %temp%\_lhaom_\autoruns\level%%j\%%~ni.bat >NUL
)
for %%i in (0 1 2 3) do rd /s /q %bfd_target%\level%%i

echo Decompress(UPX) openmod.lha\bin\*.* if possible ...
if exist bin\*.* "%dp%\bin\upx.exe" -q -d bin\*.* >NUL 2>&1

echo Compress to %bfd_target%\openmod.lha ...
"%dp%\bin\lha.exe" c -q -g -o6 %bfd_target%\openmod.lha *.* 
popd
rd /s /q %temp%\_lhaom_

:skip3
