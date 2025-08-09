#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>
#include <linux/version.h>

#define DEVICE_NAME "motion"
#define CLASS_NAME "motion"

static int major_number;
static struct class* motion_class = NULL;
static struct device* motion_device = NULL;
static struct cdev motion_cdev;

static int motion_open(struct inode *inodep, struct file *filep) {
    return 0;
}

static int motion_release(struct inode *inodep, struct file *filep) {
    return 0;
}

static ssize_t motion_read(struct file *filep, char *buffer, size_t len, loff_t *offset) {
    char motion_data = '0'; // No motion detected by default
    
    if (*offset > 0)
        return 0;
    
    if (copy_to_user(buffer, &motion_data, 1))
        return -EFAULT;
    
    *offset = 1;
    return 1;
}

static struct file_operations fops = {
    .open = motion_open,
    .read = motion_read,
    .release = motion_release,
};

static int __init motion_init(void) {
    dev_t dev;
    
    if (alloc_chrdev_region(&dev, 0, 1, DEVICE_NAME) < 0)
        return -1;
    
    major_number = MAJOR(dev);
    
    cdev_init(&motion_cdev, &fops);
    if (cdev_add(&motion_cdev, dev, 1) < 0)
        goto cleanup_chrdev;
    
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,4,0)
    motion_class = class_create(CLASS_NAME);
#else
    motion_class = class_create(THIS_MODULE, CLASS_NAME);
#endif
    if (IS_ERR(motion_class))
        goto cleanup_cdev;
    
    motion_device = device_create(motion_class, NULL, dev, NULL, DEVICE_NAME);
    if (IS_ERR(motion_device))
        goto cleanup_class;
    
    printk(KERN_INFO "Motion driver loaded\n");
    return 0;

cleanup_class:
    class_destroy(motion_class);
cleanup_cdev:
    cdev_del(&motion_cdev);
cleanup_chrdev:
    unregister_chrdev_region(dev, 1);
    return -1;
}

static void __exit motion_exit(void) {
    device_destroy(motion_class, MKDEV(major_number, 0));
    class_destroy(motion_class);
    cdev_del(&motion_cdev);
    unregister_chrdev_region(MKDEV(major_number, 0), 1);
    printk(KERN_INFO "Motion driver unloaded\n");
}

module_init(motion_init);
module_exit(motion_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Amutai");
MODULE_DESCRIPTION("Motion detection driver for Raspberry Pi 4B");
MODULE_VERSION("1.0");