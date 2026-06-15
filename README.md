# FPGA-Based Morse Code Communication System

## Overview

This project implements a **Morse Code Communication System** on the **Nexys A7 FPGA** using **SystemVerilog**. The system allows users to enter decimal digits (0–9) through onboard switches and transmit their corresponding Morse code representation through an LED output.

The project was developed to demonstrate practical FPGA design concepts including finite state machines (FSMs), edge detection, synchronous memory, timing generation, and hardware-based signal processing.

---

## What is Morse Code?

Morse code is a method of encoding information using sequences of **short pulses (dots)** and **long pulses (dashes)**. Originally developed for telegraph communication, it remains one of the simplest and most reliable methods of transmitting information using binary-like timing patterns.

For example:

| Digit | Morse Code |
| ----- | ---------- |
| 1     | .----      |
| 2     | ..---      |
| 3     | ...--      |
| 4     | ....-      |
| 5     | .....      |
| 6     | -....      |
| 7     | --...      |
| 8     | ---..      |
| 9     | ----.      |
| 0     | -----      |

In this project, dots and dashes are represented by LED pulse durations generated directly in hardware.

---

## Project Features

* Converts decimal inputs (0–9) into Morse code patterns.
* Supports both **single-digit transmission** and **multi-digit message transmission**.
* Stores up to **six digits** in internal FPGA memory before playback.
* Generates Morse timing entirely in hardware using clock counters.
* Uses switch-controlled loading and transmission.
* Implements reliable button handling using edge detection circuitry.
* Designed and validated on the **Nexys A7 FPGA Development Board**.

---

## Design Architecture

The design is divided into three major modules:

### 1. Conversion Module

The conversion module translates the user-entered decimal digit into a 5-bit Morse representation.

* `0` represents a short pulse (dot)
* `1` represents a long pulse (dash)

These encoded values are later used by the controller to determine output pulse durations.

### 2. Edge Detector

Mechanical pushbuttons can remain high for multiple clock cycles. To prevent unintended multiple activations, an edge detector converts button presses into clean single-cycle pulses.

This mechanism is used for:

* Loading digits into memory
* Starting Morse code transmission

### 3. FSM Controller

The core of the design is a Finite State Machine (FSM) responsible for:

* Storing user-entered digits
* Loading encoded data from memory
* Sequencing Morse symbols
* Generating symbol spacing
* Generating digit spacing
* Managing message playback

The FSM transitions through dedicated states for storage, transmission, symbol counting, and timing delays.

---

## Timing Generation

The Nexys A7 provides a **100 MHz system clock**. Multiple hardware counters are used to generate Morse timing intervals:

* Dot duration
* Dash duration
* Inter-symbol gap
* Inter-digit gap

This allows Morse symbols to be displayed with accurate and clearly distinguishable timing using a single LED output.

---

## Hardware Implementation

### Inputs

* FPGA Clock (100 MHz)
* Reset Button
* Start Button
* Load Button
* 4-bit Switch Input (Digit Selection)
* Mode Selection Switch

### Output

* LED-based Morse Code Transmission

---

## Development Tools

* **Language:** SystemVerilog
* **FPGA Board:** Nexys A7
* **Design Suite:** Vivado
* **Target Device:** Xilinx Artix-7 FPGA

---
