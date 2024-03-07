@echo on

REM static libraries:
if not exist %PREFIX%\Library\lib\libgmp.lib exit /b 1
if not exist %PREFIX%\Library\lib\libgmpxx.lib exit /b 1
if not exist %PREFIX%\Library\lib\libgmp_static.lib exit /b 1
if not exist %PREFIX%\Library\lib\libgmpxx_static.lib exit /b 1
REM import libraries:
if not exist %PREFIX%\Library\lib\libgmp.lib exit /b 1
if not exist %PREFIX%\Library\lib\libgmpxx.lib exit /b 1
REM dynamic libraries:
if not exist %PREFIX%\Library\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\Library\bin\libgmpxx-4.dll exit /b 1
REM headers:
if not exist %PREFIX%\Library\include\gmp.h exit /b 1
if not exist %PREFIX%\Library\include\gmpxx.h exit /b 1

REM compile a file with an import library
%CC% /Tc test.c /I %CONDA_PREFIX%\Library\include /link /LIBPATH:"%CONDA_PREFIX%\Library\lib" libgmp.lib /out:test.exe

if errorlevel 1 exit /B 1
REM execute the output
test.exe
if errorlevel 1 exit /B 1
