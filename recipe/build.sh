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

# Do not use parallel builds as they will fail with the error "make: *** empty string invalid as file name.  Stop."
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check
fi
make install

# This overlaps with libgcc-ng:
rm -rf "${PREFIX}"/share/info/dir
