#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>

#include "ioctl_pagetable.h"

int main(){

	int fd;
	
	char *filename = "/dev/pagetable";

	unsigned long arg = 1;

	fd = open(filename, O_RDWR);
	if(fd < 0){
		fprintf(stderr,"Can't open device file: %s\n", DEVICE_FILE_NAME);
		close(fd);
		exit(-1);
	}
	if(ioctl(fd, IOCTL_PAGETABLE, arg))
		fprintf(stderr,"%s error\n", __func__);

	return 0;
}
