
set GMP_HOST=%HOST%

cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1