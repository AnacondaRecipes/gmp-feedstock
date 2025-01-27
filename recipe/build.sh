#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.guess config.fsf.guess || (echo "Failed to copy $BUILD_PREFIX/share/gnuconfig/config.guess" && exit 1)
cp $BUILD_PREFIX/share/gnuconfig/config.sub config.fsf.sub  || (echo "Failed to copy $BUILD_PREFIX/share/gnuconfig/config.sub" && exit 2)

shopt -s extglob
chmod +x configure

mkdir build
cd build

if [[ "$target_platform" == "linux-ppc64le" ]]; then
  # HOST="powerpc64le-conda-linux-gnu" masks the fact that we are only
  # building for power8 and uses an older POWER architecture.
  CONFIGURE_ARGS="--host=power8-pc-linux-gnu"
else
  CONFIGURE_ARGS="--host=$HOST"
fi

CONFIGURE_ARGS="$CONFIGURE_ARGS --enable-cxx"

../configure \
  --prefix=${PREFIX} \
  --enable-fat \
  --enable-shared \
  $CONFIGURE_ARGS

if [[ $? != 0 ]]; then
  cat config.log
  exit 1
fi

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check -j${CPU_COUNT}
fi
make install

if [[ "$target_platform" == "linux-ppc64le" ]]; then
    # Build a Power9 library as well
    cd .. && mkdir build2 && cd build2
    CFLAGS=$(echo "${CFLAGS}" | sed "s/=power8/=power9/g")
    ../configure --prefix=${PREFIX} $CONFIGURE_ARGS --host="power9-pc-linux-gnu"
    make -j${CPU_COUNT}
    make install DESTDIR=$PWD/install
    # Install just the library to $PREFIX/lib/power9
    # Since $PREFIX/lib is in the rpath, newer glibc will look in
    # $PREFIX/lib/power9 before $PREFIX/lib
    # See Rpath token expansion in http://man7.org/linux/man-pages/man8/ld.so.8.html
    # This is only done for powerpc because GMP has a fat binary for x86 and I
    # couldn't find how to do it for arm64 and not sure whether that's beneficial.
    mkdir -p $PREFIX/lib/power9
    mkdir -p $PREFIX/lib/power10
    cp $PWD/install$PREFIX/lib/libgmp.so.+([0-9]) $PREFIX/lib/power9
    cp $PWD/install$PREFIX/lib/libgmp.so.+([0-9]) $PREFIX/lib/power10
fi
