#!/bin/bash

cd $SRC_DIR

export BUILD=x86_64-w64-mingw32
export HOST=x86_64-w64-mingw32

# Build static and shared libraries separately because `make` can build only one at a time
mkdir -p "static" && cd "static"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-static --disable-shared

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# Copy the static libraries with the '_static' suffix
cp "${PREFIX}"/lib/libgmp.a "${PREFIX}"/lib/libgmp_static.lib
cp "${PREFIX}"/lib/libgmpxx.a "${PREFIX}"/lib/libgmpxx_static.lib

find $PREFIX -name '*.la' -delete

cd ..


mkdir -p "shared" && cd "shared"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-shared --disable-static

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install

# Copy import libraries as on Windows we need '.lib' instead of '.dll.a'
cp "${PREFIX}"/lib/libgmp.dll.a "${PREFIX}"/lib/libgmp.lib
cp "${PREFIX}"/lib/libgmpxx.dll.a "${PREFIX}"/lib/libgmpxx.lib

find $PREFIX -name '*.la' -delete
