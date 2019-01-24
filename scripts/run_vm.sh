#!/bin/bash

vcpus=$1
memory=$2
image=$3
vm_num=$4

if [[ $# -ne 4 ]];
then
	echo "Usage: $0 <VCPUS> <MEMORY> <IMAGE> <VM NUMBER>"
	exit 1
fi

./addtap.sh ${vm_num}

sudo qemu-system-x86_64 --enable-kvm \
	-name ${vm_num} \
	-smp ${vcpus} -cpu host \
	-m ${memory} \
	-drive file=${image},if=virtio \
	-netdev tap,ifname=qtap${vm_num},id=mytap${vm_num},vhost=on,script=no,downscript=no \
	-device virtio-net,netdev=mytap${vm_num} \
	-qmp unix:/tmp/qmp-socket${vm_num},server,nowait \
	-monitor telnet:127.0.0.1:1111,server,nowait \
	-serial telnet:127.0.0.1:2222,server,nowait \
	-vnc :0

#	-incoming tcp:0:5555 \
#	-net none \
#	-device vfio-pci,host=04:00.1,id=assigned_nic${vm_num}
