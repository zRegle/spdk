#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

iscsiadm -m node --logout &> /dev/null
iscsiadm -m node -o delete &> /dev/null

$RPC spdk_kill_instance SIGTERM &> /dev/null

sleep 3

$SCRIPTS/setup.sh cleanup &> /dev/null
$SCRIPTS/setup.sh reset &> /dev/null

if [ $# -eq 1 ];
then
    device="/dev/nvme0n1"
    if [ -b $device ];
    then
        dd if=/dev/zero of=$device bs=1M count=64 &> /dev/null
        echo "clear md"
    fi
fi