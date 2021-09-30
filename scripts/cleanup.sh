#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

$RPC spdk_kill_instance SIGTERM &> /dev/null
$SCRIPTS/setup.sh cleanup &> /dev/null
$SCRIPTS/setup.sh reset &> /dev/null

iscsiadm -m node --logout &> /dev/null
iscsiadm -m node -o delete &> /dev/null

if [ $# -eq 1 ]
then
    dd if=/dev/zero of=/dev/sdi bs=1M count=16 &> /dev/null
    echo 'clear md'
fi