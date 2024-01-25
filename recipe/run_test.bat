@echo on

if not exist %PREFIX%\Library\mingw-w64\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\Library\mingw-w64\bin\libgmpxx-4.dll exit /b 1
if not exist %PREFIX%\Library\mingw-w64\include\gmp.h exit /b 1
if not exist %PREFIX%\Library\mingw-w64\lib\libgmp.a exit /b 1

set "PATH=%PREFIX%\lib;%PATH%"

REM Build the test.c program
%CC% /I %PREFIX%\include /LIBPATH:%PREFIX%\lib test.c -lgmp -o test_gmp.exe

REM Run the compiled program
test_gmp.exe
