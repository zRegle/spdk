#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)

HUGEMEM=10240 $SCRIPTS/setup.sh

ROOT_DIR=$(dirname $SCRIPTS)

nohup $ROOT_DIR/build/bin/spdk_tgt -m 0xfff --wait-for-rpc &> $ROOT_DIR/spdk.log &

pid=$(ps -ef | grep spdk_tgt | grep 'wait-for-rpc' | grep -v grep | awk '{print $2}')

if [ -n $pid ];
then
    echo 0x73 > /proc/$pid/coredump_filter
fi