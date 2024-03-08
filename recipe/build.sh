#!/bin/bash

#set -e

# Get an updated config.sub and config.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.guess config.fsf.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.sub config.fsf.sub

IFS=$' \t\n'

# Adopt a Unix-friendly path if we're on Windows (see bld.bat).
[ -n "${PATH_OVERRIDE}" ] && export PATH="${PATH_OVERRIDE}"

# On Windows we want $LIBRARY_PREFIX in both "mixed" (C:/Conda/...) and Unix
# (/c/Conda) forms, but Unix form is often "/" which can cause problems.
if [ -n "${LIBRARY_PREFIX_M}" ] ; then
    mprefix="${LIBRARY_PREFIX_M}"
    if [ "${LIBRARY_PREFIX_U}" = / ] ; then
        uprefix=""
    else
        uprefix="${LIBRARY_PREFIX_U}"
    fi
else
    mprefix="${PREFIX}"
    uprefix="${PREFIX}"
fi

# On Windows we need to regenerate the configure scripts.
if [ -n "${CYGWIN_PREFIX}" ] ; then
    am_version=1.15 # keep sync'ed with meta.yaml
    export ACLOCAL=aclocal-${am_version}
    export AUTOMAKE=automake-${am_version}
    autoreconf_args=(
        --force
        --install
        -I "${mprefix}/share/aclocal"
        -I "${BUILD_PREFIX_M}/Library/mingw-w64/share/aclocal"
    )
    autoreconf "${autoreconf_args[@]}"
fi

export PKG_CONFIG_LIBDIR=${uprefix}/lib/pkgconfig:${uprefix}/share/pkgconfig

mkdir build
cd build

GMP_HOST="${HOST}"

if [[ "$target_platform" == win* ]] ; then
    ../configure --prefix="${PREFIX}" --enable-cxx --host="${GMP_HOST}"
else
    ../configure --prefix="${PREFIX}" --enable-cxx --enable-fat --host="${GMP_HOST}"
fi

make
make check
make install -j"${CPU_COUNT}"


if [[ "$target_platform" != win* ]] ; then
    # This overlaps with libgcc-ng:
    rm -rf "${PREFIX}"/share/info/dir
else
    # Move the static libraries
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp.a "${PREFIX}"/Library/lib/libgmp_static.lib
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmpxx.a "${PREFIX}"/Library/lib/libgmpxx_static.lib
    # Move import libraries
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp.dll.a "${PREFIX}"/Library/lib/libgmp.lib
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmpxx.dll.a "${PREFIX}"/Library/lib/libgmpxx.lib
    # Move dynamic libraries
    mv "${PREFIX}"/Library/mingw-w64/bin/libgmp-10.dll "${PREFIX}"/Library/bin/libgmp-10.dll
    mv "${PREFIX}"/Library/mingw-w64/bin/libgmpxx-4.dll "${PREFIX}"/Library/bin/libgmpxx-4.dll
    # Move header files
    mv "${PREFIX}"/Library/mingw-w64/include/gmp.h "${PREFIX}"/Library/include/gmp.h
    mv "${PREFIX}"/Library/mingw-w64/include/gmpxx.h "${PREFIX}"/Library/include/gmpxx.h
fi
