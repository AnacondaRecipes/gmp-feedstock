#!/bin/bash

set -e

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.guess config.fsf.guess
cp $BUILD_PREFIX/share/gnuconfig/config.sub config.fsf.sub

IFS=$' \t\n'

# Adopt a Unix-friendly path if we're on Windows (see bld.bat).
[ -n "$PATH_OVERRIDE" ] && export PATH="$PATH_OVERRIDE"

# On Windows we want $LIBRARY_PREFIX in both "mixed" (C:/Conda/...) and Unix
# (/c/Conda) forms, but Unix form is often "/" which can cause problems.
if [ -n "$LIBRARY_PREFIX_MIXED" ] ; then
    mixed_prefix="$LIBRARY_PREFIX_MIXED"
    if [ "$LIBRARY_PREFIX_UNIX" = / ] ; then
        unix_prefix=""
    else
        unix_prefix="$LIBRARY_PREFIX_UNIX"
    fi
else
    mixed_prefix="$PREFIX"
    unix_prefix="$PREFIX"
fi

# On Windows we need to regenerate the configure scripts.
if [ -n "$CYGWIN_PREFIX" ] ; then
    am_version=1.15 # keep sync'ed with meta.yaml
    export ACLOCAL=aclocal-$am_version
    export AUTOMAKE=automake-$am_version
    autoreconf_args=(
        --force
        --install
        -I "$mixed_prefix/share/aclocal"
        -I "$BUILD_PREFIX_MIXED/Library/mingw-w64/share/aclocal"
    )
    autoreconf "${autoreconf_args[@]}"
fi

export PKG_CONFIG_LIBDIR=$unix_prefix/lib/pkgconfig:$unix_prefix/share/pkgconfig

mkdir build
cd build

GMP_HOST=$HOST

if [[ "$target_platform" == win* ]] ; then
    ../configure --prefix="${PREFIX}" --enable-cxx --enable-fat --disable-static --enable-shared --host="${GMP_HOST}"
else
    ../configure --prefix="$PREFIX" --enable-cxx --enable-fat --host="$GMP_HOST"
fi

make
make check
make install


if [[ "$target_platform" != win* ]] ; then
    # This overlaps with libgcc-ng:
    rm -rf "${PREFIX}"/share/info/dir
    
    # Move files to LIBRARY_LIB
    mv "${PREFIX}"/Library/mingw-w64/bin/libgmp-10.dll "${PREFIX}"/Library/bin/libgmp-10.dll
    mv "${PREFIX}"/Library/mingw-w64/bin/libgmpxx-4.dll "${PREFIX}"/Library/bin/libgmpxx-4.dll
    mv "${PREFIX}"/Library/mingw-w64/include/gmp.h "${PREFIX}"/Library/include/gmp.h
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp.lib "${PREFIX}"/Library/lib/libgmp.lib
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp_static.lib "${PREFIX}"/Library/lib/libgmp_static.lib
    
else
    # Move the static library
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp.a "${PREFIX}"/lib/libgmp_static.lib
    # Move the import library to LIBRARY_LIB
    mv "${PREFIX}"/Library/mingw-w64/lib/libgmp.dll.a "${PREFIX}"/lib/libgmp.lib
fi