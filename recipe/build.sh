#!/bin/bash
# Get an updated config.sub and config.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.guess config.fsf.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.sub config.fsf.sub

shopt -s extglob
chmod +x configure

mkdir build
cd build || exit 1

GMP_HOST=$HOST

../configure --prefix="$PREFIX" --enable-cxx --enable-fat --host="$GMP_HOST"

make -j"${CPU_COUNT}" "${VERBOSE_AT}"
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check -j"${CPU_COUNT}"
fi
make install

# This overlaps with libgcc-ng:
rm -rf "${PREFIX}"/share/info/dir
