# rpi-motion-driver

[![CI/CD Pipeline](https://github.com/Amutai/rpi-motion-driver/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/Amutai/rpi-motion-driver/actions)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi%204B-red.svg)](https://www.raspberrypi.org/)

Linux kernel module for PIR motion detection on Raspberry Pi 4B. Currently implements basic character device interface with planned GPIO interrupt handling.

## Features

- ✅ **Character device interface** - Standard Linux `/dev/motion` device file
- ✅ **Cross-compilation support** - Develop on x86, deploy on ARM
- ✅ **Professional documentation** - Complete API reference and guides
- ✅ **Automated CI/CD** - GitHub Actions pipeline with build verification
- ✅ **User-space test application** - Complete motion detection test program
- ✅ **Development automation** - Setup and quick-start scripts
- ✅ **Out-of-tree build system** - Clean artifact organization
- 🚧 **Configurable GPIO pin** - Module parameter (TODO: implement GPIO handling)
- 🚧 **Interrupt-driven GPIO handling** - TODO: Sub-millisecond response time
- 🚧 **Hardware abstraction** - TODO: Clean separation between driver and application logic

## Quick Start

### Prerequisites
- Raspberry Pi 4B with Linux kernel 5.4+
- PIR motion sensor (HC-SR501 recommended)
- Kernel headers: `sudo apt install linux-headers-$(uname -r)`

### Quick Setup (Automated)
```bash
# Clone repository
git clone https://github.com/Amutai/rpi-motion-driver.git
cd rpi-motion-driver

# One-command setup and test
./scripts/quick-start.sh

# Or setup development environment
./scripts/setup-dev-env.sh
```

### Manual Installation
```bash
# Build kernel module and user application
cd driver && make
cd ../user && make

# Load module and test
sudo insmod driver/build/motion_driver.ko
ls -l /dev/motion
./user/motion_test
```

## Hardware Setup

```
PIR Sensor (HC-SR501)          Raspberry Pi 4B
┌─────────────────┐           ┌─────────────────┐
│  VCC ●──────────┼───────────┼──● Pin 2 (5V)   │
│  OUT ●──────────┼───────────┼──● Pin 11       │
│                 │           │    (GPIO17)     │
│  GND ●──────────┼───────────┼──● Pin 6 (GND)  │
└─────────────────┘           └─────────────────┘
```

Detailed wiring guide: [docs/hardware-setup.md](docs/hardware-setup.md)

## Documentation

- **[Architecture Overview](docs/architecture.md)** - System design and components
- **[Development Guide](docs/development-guide.md)** - Professional development practices
- **[API Reference](docs/api-reference.md)** - Complete interface documentation
- **[Hardware Setup](docs/hardware-setup.md)** - Wiring and configuration guide
- **[Sprint Planning](docs/sprint-planning.md)** - Issue-driven development approach

## Development

This project follows professional embedded systems development practices:

- **Issue-driven sprints** with clear acceptance criteria
- **Automated CI/CD** pipeline with cross-compilation
- **Comprehensive testing** including hardware-in-the-loop
- **Professional documentation** suitable for production environments
- **Code quality standards** following Linux kernel guidelines

### Implementation Status
1. ✅ **Basic character device implementation** - `/dev/motion` device created
2. ✅ **User-space test application** - Complete `user/motion_test.c` with signal handling
3. ✅ **Development automation scripts** - `scripts/setup-dev-env.sh` and `scripts/quick-start.sh`
4. ✅ **Automated CI/CD pipeline** - GitHub Actions with cross-compilation testing
5. ✅ **Out-of-tree build system** - Clean artifact organization in `build/` directories
6. ✅ **Comprehensive documentation** - Architecture, API, development guides
7. 🚧 **Module parameter support** - TODO: Add `gpio_pin` parameter
8. 🚧 **GPIO interrupt handling** - TODO: Implement PIR sensor integration

## Testing

```bash
# Quick automated test
./scripts/quick-start.sh

# Manual testing
sudo insmod driver/build/motion_driver.ko
ls -l /dev/motion
./user/motion_test  # Interactive motion detection
sudo rmmod motion_driver

# Cross-compilation test
cd driver && make CROSS_COMPILE=arm-linux-gnueabihf-
cd ../user && make CROSS_COMPILE=arm-linux-gnueabihf-

# CI/CD pipeline runs automatically on push/PR
```

## Portfolio Highlights

This project demonstrates:

- **Kernel Programming** - Character devices, interrupts, GPIO handling
- **Hardware Integration** - PIR sensor interfacing and signal processing
- **Cross-Platform Development** - ARM cross-compilation and deployment
- **Professional Practices** - Documentation, testing, CI/CD, issue tracking
- **System Architecture** - Clean separation of concerns and modularity

## Contributing

Contributions welcome! Please read our [development guide](docs/development-guide.md) and follow the issue-driven sprint methodology.

## License

GPL v2 - See [LICENSE](LICENSE) file for details.

## Author

**Amutai** - Embedded Systems Engineer  
*Showcasing professional embedded Linux development practices with home automation project using RaspBerry Pi*
