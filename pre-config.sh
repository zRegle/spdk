#!/usr/bin/env bash

./configure --disable-tests \
        --disable-unit-tests \
        --without-crypto \
        --without-vhost \
        --without-pmdk \
        --without-rbd \
        --without-vtune \
        --enable-debug
