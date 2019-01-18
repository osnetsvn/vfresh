#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/version.h>
#include <linux/miscdevice.h>
#include <linux/err.h>
#include <asm/uaccess.h>
#include <linux/init.h>
#include <linux/slab.h>

#include "ioctl_pagetable.h"

MODULE_LICENSE("GPL");

static int device_ioctl(struct file *filp, unsigned int ioctl_num, 
		unsigned long ioctl_param){
	switch(ioctl_num){
		case IOCTL_PAGETABLE:
			printk(KERN_INFO"In the ioctl command\n");
			break;
		default:
			printk(KERN_INFO"Wrong command\n");
			return 1;
	}  
	return 0;
};

static int device_open(struct inode *inode, struct file *file){
	printk(KERN_INFO"Device open\n");
	return 0;
};

static int device_release(struct inode *inode, struct file *file){
	return 0;
};

static struct file_operations kern_fops = {
	.owner = THIS_MODULE,
	.open = device_open,
	.unlocked_ioctl = device_ioctl,
	.release = device_release,
};

static struct miscdevice kern_device = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "pagetable",
	.fops = &kern_fops
};

static int __init device_init(void){
	int retVal;
	retVal = misc_register(&kern_device);
	if(retVal){
		printk(KERN_ERR"Failed to register the device\n");
		return retVal;
	}
	printk(KERN_INFO"Registered the device successfully!\n");
	return 0;
};

static void __exit device_exit(void){
	misc_deregister(&kern_device);
	printk(KERN_INFO"Device unregistered successfully\n");
};

module_init(device_init);
module_exit(device_exit);
