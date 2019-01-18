#include <linux/ioctl.h>

#define IOC_MAGIC 'k'
#define IOCTL_PAGETABLE _IO(IOC_MAGIC,0) //defines ioctl call

#define DEVICE_FILE_NAME "pagetable"
