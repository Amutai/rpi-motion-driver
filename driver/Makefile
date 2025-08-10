# driver/Makefile

obj-m += motion_driver.o

# Default to local kernel, override for cross-compilation
KDIR ?= /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

# Cross-compilation for Raspberry Pi
# Usage: make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KDIR=/path/to/rpi/kernel

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	@if [ -f motion_driver.ko ]; then \
		echo "Build successful - organizing artifacts..."; \
		mkdir -p build || { echo "Error: Cannot create build directory"; exit 1; }; \
		mv *.ko *.o .*.o *.mod build/ 2>/dev/null || true; \
		mv *.mod.c .*.cmd build/ 2>/dev/null || true; \
		mv Module.symvers modules.order build/ 2>/dev/null || true; \
		echo "All build artifacts moved to build/ directory"; \
	else \
		echo "Error: Build failed - motion_driver.ko not found"; \
		exit 1; \
	fi

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	@echo "Cleaning build artifacts..."
	rm -rf build

# Test build (syntax check only) - uses kernel build system
syntax-check:
	$(MAKE) -C $(KDIR) M=$(PWD) motion_driver.o
	@echo "Syntax check completed - removing object file"
	rm -f motion_driver.o .motion_driver.o.cmd

# Build artifacts are automatically organized in build/ directory
# Final module: build/motion_driver.ko
# All intermediate files: build/*.o, build/*.mod, build/.*.cmd, etc.
