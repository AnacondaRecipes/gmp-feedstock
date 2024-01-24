@echo off

if not exist %PREFIX%/Library/mingw-w64/bin/libgmp-10.dll exit /b 1
if not exist %PREFIX%/Library/mingw-w64/bin/libgmpxx-4.dll exit /b 1
if not exist %PREFIX%/Library/mingw-w64/include/gmp.h exit /b 1
if not exist %PREFIX%/Library/mingw-w64/lib/libgmp.a exit /b 1

REM Build the test.c program
%CC% -I %PREFIX%/include -L %PREFIX%/lib test.c -lgmp -Wl,-rpath,%PREFIX%/lib -o test.out

REM Run the compiled program
test.out