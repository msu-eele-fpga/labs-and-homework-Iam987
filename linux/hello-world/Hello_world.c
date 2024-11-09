#include <linux/module.h>
#include <linux/kernel.h>

static int __init init_hello(void){
	printk(KERN_INFO "Hello, World\n");
	return 0;
}

static void __exit cleanup_hello(void){
	printk(KERN_INFO "Goodbye, cruel world");
}


#define MODULE_AUTHOR("Ian Crittenden")