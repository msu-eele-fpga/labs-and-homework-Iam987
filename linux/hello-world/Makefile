ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m := Hello_world.o

else
# normal makefile
# path to kernel dir
KDIR ?= ../../linux-socfpga

default:
	$(MAKE) -C $(KDIR) ARCH=arm CROSS_COMPILE=arm-linux-gnueabinhf- M=$$PWD
	
clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif