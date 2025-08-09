# driver/Makefile

obj-m += motion_driver.o

# Default to local kernel, override for cross-compilation
KDIR ?= /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

# Cross-compilation for Raspberry Pi
# Usage: make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KDIR=/path/to/rpi/kernel

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

# Test build (syntax check only)
syntax-check:
	gcc -fsyntax-only -I/usr/src/linux-headers-$(shell uname -r)/include motion_driver.c
