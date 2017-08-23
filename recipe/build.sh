#!/bin/bash

chmod +x configure

./configure --prefix=${PREFIX}  \
             --host=${HOST}     \
             --enable-cxx       \
             --enable-fat

make -j${CPU_COUNT}
make check
make install
