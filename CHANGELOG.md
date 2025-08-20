# CHANGELOG

## [Unreleased]

### Added
- Motion driver kernel module with `/dev/motion` character device interface (#3)
- Cross-compilation support in Makefile for Raspberry Pi development
- Kernel version compatibility for Linux 6.4+ with backward compatibility
- Architecture documentation with system design overview (#5)
- Out-of-tree build system with clean artifact organization
- Build artifacts automatically organized in `driver/build/` directory

### Changed
- Enhanced Makefile with configurable KDIR for flexible cross-compilation
- Fixed syntax-check target to use kernel build system instead of userspace gcc
- Updated .gitignore to exclude all kernel module build artifacts
- Improved build system with robust error handling and validation

### Fixed
- Resolved `asm/rwonce.h` compilation errors in syntax-check target
- Build artifact management now maintains clean source directory

## [0.1.0] - 2025-08-08
### Added
- Project scaffolding and directory setup
- Kernel module Makefile for motion driver (#2)
- CODEOWNERS file with project ownership
