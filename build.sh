#!/bin/sh

LIBFFI_VERSION=3.4.4

if [ ! -d "lib" ] || [ ! -d "include" ]; then
    curl -OL https://github.com/libffi/libffi/releases/download/v$LIBFFI_VERSION/libffi-$LIBFFI_VERSION.tar.gz
    tar -xzf libffi-$LIBFFI_VERSION.tar.gz
    rm libffi-$LIBFFI_VERSION.tar.gz
    cd ./libffi-$LIBFFI_VERSION
    mkdir build
    cd build
    ../configure --enable-static --with-pic # --disable-shared
    make
    mv -f ./include ../../include
    mv -f ./.libs ../../lib
    rm -rf ../../libffi-$LIBFFI_VERSION
fi
