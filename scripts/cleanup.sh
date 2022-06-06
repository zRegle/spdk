#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

iscsiadm -m node --logout
iscsiadm -m node -o delete

$RPC spdk_kill_instance SIGTERM &> /dev/null

sleep 3

$SCRIPTS/setup.sh cleanup &> /dev/null
$SCRIPTS/setup.sh reset &> /dev/null

sleep 3

if [ $# -eq 1 ];
then
    device=$(cat $SCRIPTS/base_dev)
    if [ -b $device ];
    then
        dd if=/dev/zero of=$device bs=1M count=128 &> /dev/null
        echo "clear md"
    fi
fi