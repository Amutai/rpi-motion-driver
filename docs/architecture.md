# rpi-motion-driver Architecture

This document outlines the architecture of the motion detection kernel module for Raspberry Pi 4B. The module is designed to expose motion sensor events via a `/dev/motion` device node.

---

## Overview

The module connects to a GPIO pin where a PIR (Passive Infrared) motion sensor is attached. When motion is detected, the GPIO interrupt handler signals user space through the character device `/dev/motion`.

---

## Components

### 1. `/dev` Interface
- **Character Device:**  
  - Device node: `/dev/motion`  
  - Major/minor dynamically allocated  
  - Operations supported:
    - `open()` – acquire the device  
    - `read()` – blocks until motion is detected, then returns event data  
    - `release()` – cleanup on close  
  - Non-blocking and poll/select supported for event-driven user applications.

---

### 2. GPIO Setup
- **Target Hardware:** Raspberry Pi 4B
- **Wiring:** Motion sensor output connected to a chosen GPIO pin (GPIO17 / Pin 11 in this case).  
- **Kernel Side:**
  - `gpio_request()` / `gpio_direction_input()` – configure pin as input  
  - `gpio_to_irq()` – map GPIO pin to interrupt line  
  - `request_irq()` – register interrupt handler  

When the PIR sensor output toggles:
- Rising edge → Motion detected  
- Falling edge → Motion cleared  

---

### 3. Module Flow

#### Initialization (`module_init`)
1. Allocate character device region  
2. Create `/dev/motion` entry  
3. Setup GPIO pin as input  
4. Register interrupt handler on rising edge  

#### Runtime Flow
- PIR sensor triggers GPIO interrupt  
- Interrupt handler records event  
- Wakes up any process blocked on `read()` or `poll()`  

#### User-Space Interaction
- Application does `open("/dev/motion")`  
- `read()` blocks until motion event arrives  
- Data returned: `"MOTION_DETECTED\n"` (for first draft, extensible to structs later)  

#### Cleanup (`module_exit`)
1. Free IRQ  
2. Release GPIO  
3. Destroy `/dev/motion` device  
4. Free character device region  

---

## Diagram

```plaintext
+-------------------------+         +-------------------+
|     Motion Sensor       |  --->   |   GPIO Pin (17)   |
+-------------------------+         +-------------------+
                                            |
                                            v
                                    +-------------------+
                                    | Interrupt Handler |
                                    +-------------------+
                                            |
                                            v
                                    +-------------------+
                                    |  /dev/motion char |
                                    |     device file   |
                                    +-------------------+
                                            |
                                            v
                                    +-------------------+
                                    |   User Programs   |
                                    +-------------------+
```

---

## Technical Specifications

### Hardware Requirements
- Raspberry Pi 4B
- PIR Motion Sensor (HC-SR501 or compatible)
- Jumper wires for GPIO connection

### Software Requirements
- Linux kernel 5.4+ (tested on 6.4+)
- Kernel headers for module compilation
- Cross-compilation toolchain (for development)

### Performance Characteristics
- Interrupt-driven design for minimal CPU overhead
- Sub-millisecond response time to motion events
- Supports multiple concurrent readers
- Memory footprint: <4KB kernel memory