#!/bin/bash

sudo rmmod kvm_intel
sudo rmmod kvm

lsmod | grep -ie "kvm" &> /dev/null
if [[ $? = 1 ]];
then
	modprobe kvm
fi

lsmod | grep -ie "kvm_intel" &> /dev/null
if [[ $? = 1 ]];
then
	modprobe kvm_intel nested=0
fi

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
