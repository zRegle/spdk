#!/usr/bin/env bash

./configure --disable-unit-tests \
        --without-crypto \
        --without-vhost \
        --without-pmdk \
        --without-rbd \
        --without-vtune \
        --with-fio=/home/lzr/fio \
        --enable-debug
