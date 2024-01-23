
md build
if errorlevel 1 exit 1
pushd build

set GMP_HOST=%HOST%

../configure --prefix="$PREFIX" --enable-cxx --enable-fat --host="$GMP_HOST" --disable-static --enable-shared

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
popd