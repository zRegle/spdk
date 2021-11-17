#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

iscsiadm -m node --logout &> /dev/null
iscsiadm -m node -o delete &> /dev/null

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
        if [ $device == '/dev/mapper/dm0' ];
        then
            # reset dm-table
            md_bytes=`cat $SCRIPTS/md_bytes`
            sed -i "s/$md_bytes/md/g" $SCRIPTS/dm-table
        fi
        dd if=/dev/zero of=$device bs=1M count=128 &> /dev/null
        echo "clear md"

        if [ $device == '/dev/mapper/dm0' ];
        then
            sleep 3
            # remove linear device
            dmsetup remove dm0
            if [ $? -ne 0 ];
            then
                echo "dmsetup remove failed"
                exit 1
            fi
        fi
    fi
fi