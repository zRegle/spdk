#!/usr/bin/env bash

ROOT_DIR=/home/lzr/spdk-pub
SCRIPTS=$ROOT_DIR/scripts
RPC=$SCRIPTS/rpc.py

$RPC spdk_kill_instance SIGTERM &> /dev/null
$SCRIPTS/setup.sh cleanup &> /dev/null
$SCRIPTS/setup.sh reset &> /dev/null

iscsiadm -m node --logout &> /dev/null
iscsiadm -m node -o delete &> /dev/null

if [ $# -eq 1 ]
then
    dd if=/dev/zero of=/dev/sdi bs=1M count=1 &> /dev/null
    echo 'clear md'
fi