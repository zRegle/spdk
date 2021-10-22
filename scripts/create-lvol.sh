#!/usr/bin/env bash

SCRIPTS=$(cd `dirname $0`;pwd)
RPC=$SCRIPTS/rpc.py

if [ $# -lt 1 ];
then
    echo "missing cluster sz"
    exit 1
fi

input=$1
unit=${input#${input%?}}
num=${input%${unit}}

case $unit in
    G|g)
    factor=$(( 1024 * 1024 * 1024 ))
    ;;
    M|m)
    factor=$(( 1024 * 1024 ))
    ;;
    K|k)
    factor=1024
    ;;
    *)
    echo "Invalid unit"
    exit 1
    ;;
esac

size=$(( $num * $factor ))

if [ $# -eq 2 ];
then
    device=$2
else
    device="/dev/mapper/dm0"
fi

$RPC iscsi_set_options -s 65536
$RPC framework_start_init
$RPC framework_wait_init

$RPC bdev_aio_create $device aio0
$RPC bdev_lvol_create_lvstore aio0 lvs0 -c $size
$RPC bdev_lvol_create -l lvs0 l0 102400
$RPC bdev_lvol_snapshot lvs0/l0 sp0
$RPC bdev_lvol_clone lvs0/sp0 clone0

$RPC iscsi_create_portal_group 1 127.0.0.1:3260
$RPC iscsi_create_initiator_group 2 ANY 127.0.0.1/32
$RPC iscsi_create_target_node d0 d0a lvs0/l0:0 1:2 1024 -d

iscsiadm -m discovery -t sendtargets -p 127.0.0.1:3260
iscsiadm -m node --login
iscsiadm -m session -P 3 | grep "Attached scsi disk" | awk '{print $4}'