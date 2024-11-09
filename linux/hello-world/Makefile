ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m := Hello_world.o

else
# normal makefile
# path to kernel dir
KDIR ?= /lib/modules/`uname -r`/build

default:
	$(MAKE) -C $(KDIR) M=$$PWD
	
clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif