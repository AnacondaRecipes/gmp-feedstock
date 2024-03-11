#!/bin/bash

cd $SRC_DIR

# Inspired by PKGBUILD
export HOST=${MINGW_CHOST:-x86_64-w64-mingw32}
export BUILD=${HOST}

#export CFLAGS="${CFLAGS} -Wno-attributes -Wno-ignored-attributes"

# Build static and shared libraries separately because `make` can build only one at a time
mkdir -p "static" && cd "static"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-fat --enable-static --disable-shared

make -j${CPU_COUNT}
#make check -j${CPU_COUNT}
make install

# Copy the static libraries with the '_static' suffix
#mv "${PREFIX}"/lib/libgmp.a "${PREFIX}"/lib/libgmp_static.lib
#mv "${PREFIX}"/lib/libgmpxx.a "${PREFIX}"/lib/libgmpxx_static.lib

find $PREFIX -name '*.la' -print
find $PREFIX -name '*.la' -delete

cd ..


mkdir -p "shared" && cd "shared"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-fat --enable-shared --disable-static

make -j${CPU_COUNT}
#make check -j${CPU_COUNT}
make install

# Copy import libraries as on Windows we need '.lib' instead of '.dll.a'
#cp "${PREFIX}"/lib/libgmp.dll.a "${PREFIX}"/lib/libgmp.lib
#cp "${PREFIX}"/lib/libgmpxx.dll.a "${PREFIX}"/lib/libgmpxx.lib

find $PREFIX -name '*.la' -print
find $PREFIX -name '*.la' -delete
