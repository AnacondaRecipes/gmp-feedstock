@echo on

dir /s %PREFIX%\Library\

if not exist %PREFIX%\Library\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\Library\bin\libgmpxx-4.dll exit /b 1
if not exist %PREFIX%\Library\include\gmp.h exit /b 1
if not exist %PREFIX%\Library\lib\libgmp.lib exit /b 1


%CC% /Tc test.c /I %CONDA_PREFIX%\Library\include /link /LIBPATH:"%CONDA_PREFIX%\Library\lib" libgmp.lib /out:test.exe

if errorlevel 1 exit /B 1
test.exe
if errorlevel 1 exit /B 1
