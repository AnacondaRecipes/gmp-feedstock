#!/bin/bash

set -e

# Get an updated config.sub and config.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.guess config.fsf.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.sub config.fsf.sub

shopt -s extglob
chmod +x configure

export PKG_CONFIG_LIBDIR=${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig

mkdir build
cd build

GMP_HOST="${HOST}"

../configure --prefix="${PREFIX}" --enable-cxx --enable-fat --host="${GMP_HOST}"

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install


# This overlaps with libgcc-ng:
rm -rf "${PREFIX}"/share/info/dir
