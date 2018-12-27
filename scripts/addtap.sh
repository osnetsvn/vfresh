#!/bin/bash

num=$1

if [[ $# -ne 1 ]];
then
	echo "Usage: $0 <tap Number>"
	exit 
fi

sudo tunctl -b -u root -t qtap${num} &> /dev/null &
sudo brctl addif br0 qtap${num}
sudo ifconfig qtap${num} up 0.0.0.0 promisc
