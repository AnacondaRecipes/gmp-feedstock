@echo on

REM libraries:
if not exist %PREFIX%\Library\lib\libgmp.dll.a exit /b 1
if not exist %PREFIX%\Library\lib\libgmpxx.dll.a exit /b 1
REM dynamic libraries:
if not exist %PREFIX%\Library\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\Library\bin\libgmpxx-4.dll exit /b 1
REM headers:
if not exist %PREFIX%\Library\include\gmp.h exit /b 1
if not exist %PREFIX%\Library\include\gmpxx.h exit /b 1
