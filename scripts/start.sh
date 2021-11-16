#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)

if [ $# -eq 1 ];
then
    HUGEMEM=10240 PCI_BLOCKED="0000:02:00.0" $SCRIPTS/setup.sh
else
    HUGEMEM=10240 $SCRIPTS/setup.sh
fi

ROOT_DIR=$(dirname $SCRIPTS)

nohup $ROOT_DIR/build/bin/spdk_tgt -m 0x1 --wait-for-rpc &> $ROOT_DIR/spdk.log &

pid=$(ps -ef | grep build | grep 'wait-for-rpc' | grep -v grep | awk '{print $2}')

if [ -n $pid ];
then
    echo 0x73 > /proc/$pid/coredump_filter
fi
