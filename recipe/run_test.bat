@echo on

dir /s %PREFIX%\Library\

if not exist %PREFIX%\Library\mingw-w64\bin\libgmp-10.dll exit /b 1
if not exist %PREFIX%\Library\mingw-w64\bin\libgmpxx-4.dll exit /b 1
if not exist %PREFIX%\Library\mingw-w64\include\gmp.h exit /b 1
::if not exist %PREFIX%\Library\mingw-w64\lib\libgmp.a exit /b 1
if not exist %PREFIX%\Library\mingw-w64\lib\libgmp.lib exit /b 1
if not exist %PREFIX%\Library\mingw-w64\lib\libgmp_static.lib exit /b 1

::set PATH=%LIBRARY_PATH%\mingw-w64\bin;%LIBRARY_PREFIX%\usr\bin;%LIBRARY_BIN%;%PATH%

%CC% /Tc test.c /I %CONDA_PREFIX%\Library\mingw-w64\include /link /LIBPATH:"%CONDA_PREFIX%\Library\mingw-w64\lib" libgmp.lib /out:test.exe

if errorlevel 1 exit /B 1
test.exe
if errorlevel 1 exit /B 1
