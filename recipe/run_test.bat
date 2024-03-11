@echo on

REM static libraries:
if not exist %PREFIX%\lib\libgmp.lib exit /b 1
if not exist %PREFIX%\lib\libgmpxx.lib exit /b 1
if not exist %PREFIX%\lib\libgmp_static.lib exit /b 1
if not exist %PREFIX%\lib\libgmpxx_static.lib exit /b 1
REM import libraries:
if not exist %PREFIX%\lib\libgmp.lib exit /b 1
if not exist %PREFIX%\lib\libgmpxx.lib exit /b 1
REM dynamic libraries:
if not exist %PREFIX%\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\bin\libgmpxx-4.dll exit /b 1
REM headers:
if not exist %PREFIX%\include\gmp.h exit /b 1
if not exist %PREFIX%\include\gmpxx.h exit /b 1

REM compile a file with an import library
%CC% /MD /Fetest test.c /I%PREFIX%\include /link /LIBPATH:"%PREFIX%\lib" libgmp.lib

REM Uncomment for the debugging purposes only to check the dynamic libraries
ldd test.exe
if errorlevel 1 exit /B 1

if errorlevel 1 exit /B 1
REM execute the output
test.exe
if errorlevel 1 exit /B 1
