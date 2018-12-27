#!/bin/bash

mount | grep ~/workspace/images &> /dev/null

if [[ $? = 1 ]];
then
	mount -t nfs 10.128.0.2:/home/spoorti/vfresh-new-images/ ~/workspace/images/
fi
