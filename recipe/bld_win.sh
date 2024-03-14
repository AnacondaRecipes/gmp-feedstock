#!/bin/bash

cd $SRC_DIR || exit 1

# Inspired by PKGBUILD
export HOST=${MINGW_CHOST:-x86_64-w64-mingw32}
export BUILD=${HOST}

export CFLAGS="${CFLAGS} -Wno-attributes -Wno-ignored-attributes"

# Build shared libraries.
# To be aware: 'make' can build only one library at a time: shared or static but not both.
mkdir -p "shared" && cd "shared"

../configure --prefix="${LIBRARY_PREFIX_MIXED}" --host="${HOST}" --enable-cxx --enable-fat --enable-shared --disable-static

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
		make check -j${CPU_COUNT}
fi
make install
