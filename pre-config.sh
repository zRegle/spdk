#!/usr/bin/env bash

./configure --disable-tests \
        --without-crypto \
        --without-vhost \
        --without-pmdk \
        --without-rbd \
        --without-vtune \
        --enable-debug
