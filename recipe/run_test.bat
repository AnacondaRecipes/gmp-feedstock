@echo on

REM static libraries:
if not exist %PREFIX%\lib\libgmp.a exit /b 1
if not exist %PREFIX%\lib\libgmpxx.a exit /b 1
REM dynamic libraries:
if not exist %PREFIX%\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\bin\libgmpxx-4.dll exit /b 1
REM headers:
if not exist %PREFIX%\include\gmp.h exit /b 1
if not exist %PREFIX%\include\gmpxx.h exit /b 1
