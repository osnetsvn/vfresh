#!/bin/bash

mount | grep /home/sdoddam1/workspace/images &> /dev/null

if [[ $? = 1 ]];
then
	mount -t nfs 10.128.0.2:/home/spoorti/vfresh-new-images/ /home/sdoddam1/workspace/images/
fi
