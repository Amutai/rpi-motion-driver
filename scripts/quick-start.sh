#!/bin/bash

# Quick Start Script - Build, Load, and Test Motion Driver
# Usage: ./scripts/quick-start.sh [--cross-compile]

set -e

CROSS_COMPILE=""
if [[ "$1" == "--cross-compile" ]]; then
    CROSS_COMPILE="ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-"
    echo "=== Cross-compilation mode enabled ==="
fi

echo "=== Raspberry Pi Motion Driver - Quick Start ==="

# Step 1: Build kernel module
echo "Building kernel module..."
cd driver
make $CROSS_COMPILE
cd ..

# Step 2: Build user application  
echo "Building user application..."
cd user
make ${CROSS_COMPILE:+CROSS_COMPILE=arm-linux-gnueabihf-}
cd ..

if [[ -n "$CROSS_COMPILE" ]]; then
    echo "Cross-compilation complete. Transfer files to Raspberry Pi:"
    echo "  scp driver/build/motion_driver.ko pi@raspberrypi:~/"
    echo "  scp user/motion_test pi@raspberrypi:~/"
    echo "Then run on Pi: sudo insmod motion_driver.ko && ./motion_test"
    exit 0
fi

# Steps 3-4: Load module and test (only on Raspberry Pi)
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "Not running on Raspberry Pi. Build complete."
    echo "Transfer files and run: sudo insmod motion_driver.ko && ./motion_test"
    exit 0
fi

echo "Loading kernel module..."
sudo insmod driver/build/motion_driver.ko

echo "Checking device creation..."
if [[ -c /dev/motion ]]; then
    echo "✓ /dev/motion created successfully"
else
    echo "✗ /dev/motion not found"
    exit 1
fi

echo "Starting motion test (Ctrl+C to stop)..."
echo "Wave your hand in front of the PIR sensor..."
sudo ./user/motion_test