#!/bin/bash

lsmod | grep -ie "vhost-net" &> /dev/null

if [[ $? = 1 ]];
then
	modprobe vhost-net
fi

lsmod | grep -ie "vfio-pci" &> /dev/null

if [[ $? = 1 ]];
then
	modprobe vfio-pci
fi

lsmod | grep -ie "igbvf" &> /dev/null

if [[ $? = 1 ]]
then
	modprobe igbvf
fi 
