@echo on

REM static libraries:
@REM if not exist %PREFIX%\Library\lib\libgmp.lib exit /b 1
@REM if not exist %PREFIX%\Library\lib\libgmpxx.lib exit /b 1
@REM if not exist %PREFIX%\Library\lib\libgmp_static.lib exit /b 1
@REM if not exist %PREFIX%\Library\lib\libgmpxx_static.lib exit /b 1
@REM REM import libraries:
@REM if not exist %PREFIX%\Library\lib\libgmp.lib exit /b 1
@REM if not exist %PREFIX%\Library\lib\libgmpxx.lib exit /b 1
@REM REM dynamic libraries:
@REM if not exist %PREFIX%\Library\bin\libgmp-10.dll exit /b 1
@REM if not exist %PREFIX%\Library\bin\libgmpxx-4.dll exit /b 1
@REM REM headers:
@REM if not exist %PREFIX%\Library\include\gmp.h exit /b 1
@REM if not exist %PREFIX%\Library\include\gmpxx.h exit /b 1

REM compile a file with an import library
%CC% /MD /Fetest test.c /I%PREFIX%\include /link /LIBPATH:"%PREFIX%\lib" libgmp.lib

REM Uncomment for the debugging purposes only to check the dynamic libraries
ldd test.exe
if errorlevel 1 exit /B 1

if errorlevel 1 exit /B 1
REM execute the output
test.exe
if errorlevel 1 exit /B 1
