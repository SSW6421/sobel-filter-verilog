# Milestone 2 — Real-Time VGA Display on FPGA

**Hardware Sobel Filter · Live Split-Screen Output via VGA**

---

## 📌 Overview

This milestone takes the Sobel filter from behavioural simulation to **real hardware**. The design is synthesised and deployed onto an FPGA board, producing a live **640×480 split-screen VGA output**:

- **Left half (320px):** Live original greyscale image streamed from Block RAM
- **Right half (320px):** Real-time Sobel edge-detected version of the same image

Everything runs in real-time at **25 MHz pixel clock**, synchronised to standard **VGA 640×480 @ 60 Hz** timing.

---

## ✨ Key Features

- **Fully Pipelined Sobel Core** — multi-stage pipeline handles one pixel per clock cycle
- **3×3 Sliding Window** — `pixel_window.v` feeds the Sobel core with the correct neighbourhood on every cycle
- **Line Buffers** — two line buffers store the previous rows needed to form the 3×3 window
- **Image ROM** — the input image is pre-loaded into FPGA Block RAM via a hex initialisation file
- **Split-Screen Display** — a single VGA output shows original (left) and edge map (right) simultaneously
- **Row Buffer** — bridges the pipeline delay between the two screen halves using a dedicated output buffer

---

## 📁 Structure

```
milestone-2/
├── src/
│   ├── top_sobel_display.v   # Top-level: integrates all modules + VGA output
│   ├── sobel_calc.v          # Pipelined Sobel gradient calculation
│   ├── vga_controller.v      # VGA 640×480 @ 60Hz sync signal generator
│   ├── pixel_window.v        # 3×3 sliding pixel window extractor
│   ├── line_buffer.v         # Single-row FIFO buffer for window formation
│   ├── output_row_buffer.v   # Row buffer for split-screen pipeline sync
│   └── image_rom.v           # Xilinx Block RAM ROM (image storage)
├── generate_hex.py           # Converts PNG image → HEX for ROM init
└── input_image.png           # Sample image loaded into ROM
```

---

## ⚙️ Prerequisites

| Tool | Details |
|------|---------|
| Xilinx Vivado | 2019.2 or later |
| FPGA Board | Basys 3 / Nexys A7 (or compatible with VGA output) |
| Python 3.x | For hex generation script |
| VGA Monitor | Standard 640×480 capable |

---

## 🔧 Setup

### 1. Generate the Image ROM hex file
```bash
python generate_hex.py
```
This converts `input_image.png` → `image_data.hex` (320×480 greyscale pixels).

### 2. Load into Vivado
- Open or recreate the Vivado project
- Add all `.v` files from `src/` as design sources
- Ensure `image_rom.v` references the generated `image_data.hex`
- Set the target FPGA part (e.g., `xc7a35tcpg236-1` for Basys 3)

### 3. Synthesise & Implement
- Run Synthesis → Implementation → Generate Bitstream in Vivado
- Program the FPGA via the Hardware Manager

### 4. Connect & View
- Connect VGA cable from the FPGA board to your monitor
- Apply a **100 MHz clock** to `clk_100MHz` (divided internally to 25 MHz pixel clock)
- The design will begin outputting the split-screen image immediately

---

## 🧩 Module Hierarchy

```
top_sobel_display
├── vga_controller       # Generates h_sync, v_sync, pixel_x, pixel_y
├── image_rom            # Block RAM: stores 320×480 greyscale image
├── pixel_window         # Builds 3×3 window from streaming pixels
│   └── line_buffer (×2) # Stores previous rows for window formation
├── sobel_calc           # Computes |Gx| + |Gy| edge magnitude
└── output_row_buffer    # Stores processed row for right-half display
```

---

## 📺 VGA Timing

| Parameter | Value |
|-----------|-------|
| Resolution | 640 × 480 |
| Refresh Rate | 60 Hz |
| Pixel Clock | 25 MHz |
| Input Clock | 100 MHz (÷4 internally) |

---

## 🖥️ Display Layout

```
┌─────────────────────────────────────────┐
│                                         │
│   Original Image   │   Sobel Edge Map   │
│    (Left 320px)    │   (Right 320px)    │
│                    │                    │
└─────────────────────────────────────────┘
         640 × 480 @ 60Hz VGA
```
