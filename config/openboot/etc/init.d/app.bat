if not exist %FS_ROOT%APP\NUL goto end
set PRNHEAD=App
call export.bat FS_APP %FS_ROOT%app
call addpath.bat %FS_APP%\bin %FS_APP%\bat
for %%D in (%1\K*.BAT) do call %%D %1 %2 %3 %4 %5 %6 %7 %8 %9
set PRNHEAD=
:end