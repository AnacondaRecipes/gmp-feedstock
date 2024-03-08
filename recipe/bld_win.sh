#!/bin/bash

cd $SRC_DIR

export BUILD=x86_64-w64-mingw32
export HOST=x86_64-w64-mingw32

mkdir -p "static" && cd "static"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-static --disable-shared

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# Move the static libraries
cp "${PREFIX}"/lib/libgmp.a "${PREFIX}"/Library/lib/libgmp_static.lib
cp "${PREFIX}"/lib/libgmpxx.a "${PREFIX}"/Library/lib/libgmpxx_static.lib
# # Move header files
cp "${PREFIX}"/include/gmp.h "${PREFIX}"/Library/include/gmp.h
cp "${PREFIX}"/include/gmpxx.h "${PREFIX}"/Library/include/gmpxx.h
# Move the pkg-config file
cp "${PREFIX}"/lib/pkgconfig/gmp.pc "${PREFIX}"/Library/lib/pkgconfig/gmp.pc

ls -l

find $PREFIX -name '*.la' -delete

cd ..

mkdir -p "shared" && cd "shared"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-shared --disable-static

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

ls -l

# Move import libraries
cp "${PREFIX}"/lib/libgmp.dll.a "${PREFIX}"/Library/lib/libgmp.lib
cp "${PREFIX}"/lib/libgmpxx.dll.a "${PREFIX}"/Library/lib/libgmpxx.lib
# Move dynamic libraries
cp "${PREFIX}"/bin/libgmp-10.dll "${PREFIX}"/Library/bin/libgmp-10.dll
cp "${PREFIX}"/bin/libgmpxx-4.dll "${PREFIX}"/Library/bin/libgmpxx-4.dll

find $PREFIX -name '*.la' -delete