# rpi-motion-driver

[![CI/CD Pipeline](https://github.com/Amutai/rpi-motion-driver/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/Amutai/rpi-motion-driver/actions)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi%204B-red.svg)](https://www.raspberrypi.org/)

Professional-grade Linux kernel module for PIR motion detection on Raspberry Pi 4B. Exposes motion sensor events via `/dev/motion` character device interface with interrupt-driven architecture for minimal CPU overhead.

## Features

- **Interrupt-driven GPIO handling** - Sub-millisecond response time
- **Character device interface** - Standard Linux `/dev/motion` device file
- **Cross-compilation support** - Develop on x86, deploy on ARM
- **Configurable GPIO pin** - Module parameter for flexible hardware setup
- **Professional documentation** - Complete API reference and guides
- **Automated CI/CD** - GitHub Actions for build verification
- **Hardware abstraction** - Clean separation between driver and application logic

## Quick Start

### Prerequisites
- Raspberry Pi 4B with Linux kernel 5.4+
- PIR motion sensor (HC-SR501 recommended)
- Kernel headers: `sudo apt install linux-headers-$(uname -r)`

### Installation
```bash
# Clone and setup
git clone https://github.com/Amutai/rpi-motion-driver.git
cd rpi-motion-driver
./scripts/setup-dev-env.sh

# Build and install
cd driver && make
sudo insmod build/motion_driver.ko

# Test
cd ../user && make && ./motion_test
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

### Current Sprint Goals
1. Basic character device implementation
2. GPIO interrupt handling
3. User-space test application
4. Hardware setup documentation
5. Automated testing framework

## Testing

```bash
# Build and run tests
cd user && make
sudo ./motion_test

# Cross-compilation test
make CROSS_COMPILE=arm-linux-gnueabihf-
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
