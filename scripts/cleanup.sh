#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

$RPC spdk_kill_instance SIGTERM &> /dev/null
$SCRIPTS/setup.sh cleanup &> /dev/null
$SCRIPTS/setup.sh reset &> /dev/null

iscsiadm -m node --logout &> /dev/null
iscsiadm -m node -o delete &> /dev/null

if [ $# -gt 0 ]
then
    if [ $# -eq 2 ]
    then
        device=$2
    else
        device="/dev/mapper/dm0"
    fi
    dd if=/dev/zero of=$device bs=1M count=64 &> /dev/null
    echo 'clear md'
fi