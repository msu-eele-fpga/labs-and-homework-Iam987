#include <linux/module.h>
#include <linux/kernel.h>

#define MyName "Ian Crittenden"

static int __init init_hello(void){
	printk(KERN_INFO "Hello, World\n");
	return 0;
}

static void __exit cleanup_hello(void){
	printk(KERN_INFO "Goodbye, cruel world");
}

module_init(init_hello);
module_exit(cleanup_hello);

MODULE_AUTHOR(MyName);
MODULE_LICENSE("GPL");