#!/bin/bash

cd $SRC_DIR || exit 1

# Inspired by PKGBUILD
export HOST=${MINGW_CHOST:-x86_64-w64-mingw32}
export BUILD=${HOST}

export CFLAGS="${CFLAGS} -Wno-attributes -Wno-ignored-attributes"

# Build static and shared libraries separately because `make` can build only one at a time
mkdir -p "static" && cd "static"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-fat --enable-static --disable-shared

make -j${CPU_COUNT}
#make check -j${CPU_COUNT}
make install


find $PREFIX -name '*.la' -delete

cd ..


mkdir -p "shared" && cd "shared"

../configure --prefix="${PREFIX}" --host="${HOST}" --enable-cxx --enable-fat --enable-shared --disable-static

make -j${CPU_COUNT}
#make check -j${CPU_COUNT}
make install


find $PREFIX -name '*.la' -delete
