#!/bin/bash
# Usage: ./setup-full.sh HOSTNAME NUMBER
# Ie: ./setup-full.sh node-1 101

HOSTNAME=$1
NUM=$2

EMPTY=false

if [ ! "$HOSTNAME" ]; then
echo "hostname not defined"
EMPTY=true
fi

if [ ! "$NUM" ]; then
echo "number not defined"
EMPTY=true
fi

if [ "$EMPTY" != false ]; then
echo "One or more require variables are not defined."
exit
fi

if [ "$NUM" -lt 2 ]; then
echo "Pi number must be greater than 1. 1 is reserved for gateway IP."
exit
fi

echo "Setting up with hostname \"$HOSTNAME\" and node number $NUM. Access IP will be 172.16.20.$NUM"
./01-vlan.sh $NUM
./02-hostname.sh $HOSTNAME
./03-docker-and-k8s.sh
