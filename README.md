# SCOMP Servo Control Interface: Dual-Mode Precision

## Project Overview

This project focuses on the design and implementation of a custom peripheral for the SCOMP system to enable precise servo motor control. The peripheral features dual control modes, allowing users to specify servo positioning through either pulse width or angle inputs. Designed with simplicity and versatility in mind, this project delivers an accessible tool for a wide range of applications, from basic servo tasks to advanced robotics.

---

## Features

### Dual Control Modes
1. **Pulse Width Mode** (`9th bit = 0`): Users specify the pulse width in microseconds (50–250 µs) to control the servo's movement.
2. **Angle Mode** (`9th bit = 1`): Users specify the angle (0–180º), and the peripheral generates the appropriate pulse for servo positioning.

### Input Handling
- Input data is 9 bits, where the 9th bit determines the mode, and the remaining 8 bits specify the value.
- Input ranges:
  - Pulse Width: 50–250 µs (clamped to this range).
  - Angle: 0–180º (values exceeding 180º are clamped to the maximum pulse width).

### Timing and Signal Stability
- Pulse outputs update every 20 ms to align with the servo's ability to accept new pulses, ensuring signal stability.
- Designed for hobby servos with a maximum rotation of 180º.

---

## Design Highlights

- **Mode Switching**:
  - Efficient use of the 9th bit for mode selection eliminates the need for additional registers, conserving memory for future peripherals.
  
- **Clock Adjustment**:
  - Upgraded peripheral clock from 10 kHz to 100 kHz to improve accuracy without requiring hardware division.

- **Error Handling**:
  - Clamps inputs outside valid ranges to the closest permissible value (e.g., input of 30 µs results in a 50 µs pulse).

---

## How It Works

1. **Initialization**:
   - Configure the peripheral with the desired mode using the 9th bit.
2. **Input Commands**:
   - Send 8-bit input values representing either pulse width (in µs) or angle (in degrees) based on the selected mode.
3. **Pulse Generation**:
   - The peripheral outputs precise pulses to control the servo's position based on the provided input.

---

## Future Enhancements

- **Expanded Control Options**:
  - Integrate an additional input bit for enhanced functionality, such as time-based angle adjustments for solar tracking.
- **Precision Feedback**:
  - Implement servo feedback mechanisms to increase accuracy in positioning.
- **Extended Testing**:
  - Expand test scenarios to optimize performance under various use cases.

---

## Conclusion

The **SCOMP Servo Control Interface** successfully achieves its objectives by offering a simple, dual-mode control solution for servo motors. Its efficient design sets a foundation for future innovation in SCOMP peripheral development, balancing precision and usability.

