#!/bin/bash

# Development Environment Setup Script
# For Raspberry Pi Motion Driver Project

set -e

echo "=== Raspberry Pi Motion Driver - Development Environment Setup ==="

# Check if running on Raspberry Pi
if grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "✓ Running on Raspberry Pi"
    ON_RPI=true
else
    echo "i Running on development machine (cross-compilation mode)"
    ON_RPI=false
fi

# Install kernel headers and build tools
echo "Installing build dependencies..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    git \
    sparse \
    linux-headers-$(uname -r) \
    device-tree-compiler

if [ "$ON_RPI" = false ]; then
    echo "Installing cross-compilation toolchain..."
    sudo apt-get install -y gcc-arm-linux-gnueabihf
fi

# Create build directories
echo "Setting up project structure..."
mkdir -p driver/build
mkdir -p user/build
mkdir -p logs
mkdir -p tests

# Set up git hooks (optional)
if [ -d .git ]; then
    echo "Setting up git hooks..."
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for code quality checks

echo "Running pre-commit checks..."

# Check kernel coding style
if [ -f driver/motion_driver.c ]; then
    scripts/checkpatch.pl --no-tree --file driver/motion_driver.c || true
fi

# Build test
cd driver && make syntax-check
cd ../user && make

echo "Pre-commit checks completed."
EOF
    chmod +x .git/hooks/pre-commit
fi

# Create udev rule for device permissions
echo "Creating udev rule for /dev/motion..."
sudo tee /etc/udev/rules.d/99-motion-driver.rules > /dev/null << 'EOF'
# Motion driver device permissions
KERNEL=="motion", MODE="0666", GROUP="users"
EOF

# Download checkpatch.pl if not present
if [ ! -f scripts/checkpatch.pl ]; then
    echo "Downloading checkpatch.pl..."
    mkdir -p scripts
    wget -O scripts/checkpatch.pl \
        https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl
    chmod +x scripts/checkpatch.pl
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Connect PIR sensor to GPIO17 (Pin 11)"
echo "2. Run quick start: ./scripts/quick-start.sh"
echo "   Or manually:"
echo "   - Build: cd driver && make"
echo "   - Load: sudo insmod driver/build/motion_driver.ko"
echo "   - Test: cd user && make && ./motion_test"
echo ""
echo "For cross-compilation:"
echo "  ./scripts/quick-start.sh --cross-compile"
echo ""
echo "Documentation available in docs/ directory"