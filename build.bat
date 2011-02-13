@echo off
set dp=%~dp0
if "%1"=="" goto usage
if "%2"=="" goto no_target
if "%3"=="" goto no_os
set m_name=%1
set m_target=%2
set m_os=%3
set m_type=%4
goto _start
:no_target
set m_name=%1
set m_target=%1
set m_os=win98se
goto _start
:no_os
set m_name=%1
set m_target=%2
set m_os=win98se
goto _start

:_start
if "%m_type%"=="" goto no_type
"%dp%\bfd.cmd" -o %m_os% -t %m_type% -i %dp%\build\%m_target%.img %m_name% %3 %4 %5 %6 %7 %8 %9
goto end
:no_type
"%dp%\bfd.cmd" -o %m_os% -i %dp%\build\%m_target%.img %m_name% %3 %4 %5 %6 %7 %8 %9
goto end


:usage
echo Usage:%0 name [target] [os] [type]

:end
