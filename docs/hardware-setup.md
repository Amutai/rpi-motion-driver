# Hardware Setup Guide

## Components Required

### Primary Components
- **Raspberry Pi 4B** - Main development board
- **PIR Motion Sensor** - HC-SR501 or compatible
- **Jumper Wires** - Male-to-female for GPIO connections
- **Breadboard** (optional) - For prototyping

### PIR Sensor Specifications
- **Model:** HC-SR501 (recommended)
- **Operating Voltage:** 3.3V - 5V
- **Detection Range:** 3-7 meters
- **Detection Angle:** 120 degrees
- **Output:** Digital HIGH/LOW

---

## Wiring Diagram

```
PIR Sensor (HC-SR501)          Raspberry Pi 4B
┌─────────────────┐           ┌─────────────────┐
│                 │           │                 │
│  VCC ●──────────┼───────────┼──● Pin 2 (5V)  │
│                 │           │                 │
│  OUT ●──────────┼───────────┼──● Pin 11       │
│                 │           │    (GPIO17)     │
│  GND ●──────────┼───────────┼──● Pin 6 (GND)  │
│                 │           │                 │
└─────────────────┘           └─────────────────┘
```

### Pin Mapping
| PIR Pin | RPi Pin | RPi GPIO | Function |
|---------|---------|----------|----------|
| VCC     | Pin 2   | 5V       | Power    |
| OUT     | Pin 11  | GPIO17   | Signal   |
| GND     | Pin 6   | GND      | Ground   |

---

## Assembly Instructions

### Step 1: Power Down
Ensure Raspberry Pi is powered off and disconnected from power source.

### Step 2: Connect Power
1. Connect PIR VCC to Raspberry Pi Pin 2 (5V)
2. Connect PIR GND to Raspberry Pi Pin 6 (GND)

### Step 3: Connect Signal
1. Connect PIR OUT to Raspberry Pi Pin 11 (GPIO17)
2. Ensure secure connection to avoid false triggers

### Step 4: Verify Connections
Double-check all connections match the wiring diagram before powering on.

---

## PIR Sensor Configuration

### Sensitivity Adjustment
- **Potentiometer 1 (Sx):** Sensitivity range (3-7m)
- **Potentiometer 2 (Tx):** Time delay (0.3s-5min)

### Jumper Settings
- **H:** Repeatable trigger mode (recommended)
- **L:** Single trigger mode

### Recommended Settings
- **Sensitivity:** Mid-range (4-5 meters)
- **Time Delay:** Minimum (0.3 seconds)
- **Trigger Mode:** H (Repeatable)

---

## Testing Hardware Setup

### Basic Connectivity Test
```bash
# Check GPIO pin state
gpio -g mode 17 in
gpio -g read 17

# Should return 0 (no motion) or 1 (motion detected)
```

### Continuous Monitoring
```bash
# Monitor GPIO pin changes
gpio -g mode 17 in
while true; do
    echo "GPIO17: $(gpio -g read 17)"
    sleep 0.5
done
```

---

## Troubleshooting

### Common Issues

#### No Motion Detection
- **Check Power:** Verify 5V and GND connections
- **Check Signal:** Ensure GPIO17 connection is secure
- **PIR Warm-up:** Wait 30-60 seconds after power-on
- **Sensitivity:** Adjust sensitivity potentiometer

#### False Triggers
- **Electrical Noise:** Use shorter wires, avoid interference
- **Vibration:** Ensure stable mounting
- **Temperature:** Avoid direct sunlight or heat sources

#### Inconsistent Readings
- **Loose Connections:** Check all wire connections
- **Power Supply:** Ensure stable 5V supply
- **GPIO Configuration:** Verify pin mode settings

### Diagnostic Commands
```bash
# Check GPIO pin configuration
cat /sys/kernel/debug/gpio

# Monitor kernel messages
dmesg | tail -f

# Check device file creation
ls -la /dev/motion
```

---

## Safety Considerations

### Electrical Safety
- Always power down before making connections
- Verify voltage levels before connecting
- Use proper gauge wires for current requirements

### ESD Protection
- Use anti-static wrist strap when handling components
- Touch grounded surface before handling Pi or sensor

### Environmental
- Keep components dry and dust-free
- Avoid extreme temperatures during operation
- Ensure adequate ventilation for Raspberry Pi

---

## Advanced Configuration

### Alternative GPIO Pins
The driver supports configurable GPIO pins via module parameter:
```bash
# Load driver with custom GPIO pin
sudo insmod motion_driver.ko gpio_pin=18
```

### Multiple Sensors
Future versions will support multiple PIR sensors on different GPIO pins for zone-based detection.

### Device Tree Integration
For production deployments, device tree overlay for hardware description must be considered.