# Milestone 1 — Behavioural Simulation Pipeline

**Hardware Sobel Filter · Behavioural Simulation in Xilinx Vivado**

---

## 📌 Overview

This milestone implements a hardware-level Sobel Edge Detection filter in Verilog and verifies it through a **fully automated, zero-touch simulation pipeline**.

A single batch script orchestrates the entire flow:
1. Pre-processes any JPEG image into a hex data stream
2. Launches Xilinx Vivado **headlessly** (no GUI) to run the hardware simulation
3. Post-processes the hex output back into a viewable image
4. Displays a side-by-side comparison automatically

---

## ✨ Key Features

- **Combinational Sobel Core** — uses bit-shifting (`<< 1`) instead of multipliers for efficient gradient calculation
- **Manhattan Magnitude** — approximates `√(Gx² + Gy²)` as `|Gx| + |Gy|` for hardware-friendly edge strength
- **Dynamic Rescaling** — input image auto-resized to 256×256 (any aspect ratio accepted)
- **Headless Vivado** — simulation runs in `-mode batch` via TCL script, no GUI required
- **Instant Verification** — Matplotlib GUI launches automatically with side-by-side result view

---

## 📁 Structure

```
milestone-1/
├── src/
│   ├── sobel_calc.v      # Sobel combinational logic module
│   └── tb_sobel.v        # Testbench — reads input.hex, writes output.hex
├── scripts/
│   ├── generate_hex.py   # Converts input JPG → grayscale HEX array
│   ├── generate_image.py # Converts output HEX → JPG image
│   └── show_results.py   # Side-by-side Matplotlib viewer
├── simulation/
│   ├── run_sim.tcl       # Vivado batch simulation script
│   └── FULL_AUTO.bat     # Master one-click pipeline launcher
├── test_image.jpg        # Sample input image
└── output_image.jpg      # Sample Sobel output
```

---

## ⚙️ Prerequisites

| Tool | Version |
|------|---------|
| Xilinx Vivado | 2019.2 (or later) |
| Python | 3.x |
| opencv-python | latest |
| numpy | latest |
| matplotlib | latest |

Install Python dependencies:
```bash
pip install opencv-python numpy matplotlib
```

---

## 🔧 Setup — Update Local Paths

Before running, update these three files with your local paths:

| File | What to update |
|------|---------------|
| `src/tb_sobel.v` | `$readmemh` and `$fopen` paths for `input_image.hex` / `output_image.hex` |
| `simulation/run_sim.tcl` | `open_project` path to your local `.xpr` file |
| `simulation/FULL_AUTO.bat` | Vivado installation path (default: `C:\Xilinx\Vivado\2019.2\bin\vivado.bat`) |

> **Tip:** Use forward slashes `/` in Verilog file paths, even on Windows.

---

## 🚀 Running the Pipeline

1. Place any image in the `milestone-1/` folder and rename it `test_image.jpg`
2. Double-click `simulation/FULL_AUTO.bat`

**The pipeline will automatically:**
- Run `generate_hex.py` → resizes + converts image to `input_image.hex`
- Run Vivado headlessly → simulates Verilog, produces `output_image.hex`
- Run `generate_image.py` → converts hex output to `output_image.jpg`
- Run `show_results.py` → launches side-by-side comparison GUI

---

## 🧩 Module: `sobel_calc.v`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `p11`–`p33` | input | 8 | 3×3 pixel neighbourhood |
| `edge_out` | output | 8 | Sobel edge magnitude |

**Gradient equations implemented:**
```
Gx = (p13 - p11) + 2*(p23 - p21) + (p33 - p31)
Gy = (p31 - p11) + 2*(p32 - p12) + (p33 - p13)
G  = |Gx| + |Gy|  (clamped to 255)
```
