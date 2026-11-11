# VGA Setup Test

A minimal, self-contained Verilog module to verify that your **VGA cable, monitor, and FPGA pin assignments** are all working correctly before deploying the main Sobel filter design.

---

## 📌 What It Does

Outputs a simple **red + blue gradient pattern** at **640×480 @ 60 Hz** using only the 100 MHz board clock (divided internally to 25 MHz). No external dependencies — no image ROM, no line buffers, nothing else needed.

If your screen shows a coloured gradient, your VGA hardware setup is confirmed working. ✅

---

## 🧩 Module: `vga_test.v`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk_100MHz` | input | 1 | 100 MHz board clock |
| `vga_red` | output | 4 | Red channel (full brightness in active region) |
| `vga_green` | output | 4 | Green channel (always off) |
| `vga_blue` | output | 4 | Blue channel (horizontal gradient) |
| `h_sync` | output | 1 | Horizontal sync signal |
| `v_sync` | output | 1 | Vertical sync signal |

**Expected display:** Solid red with a blue gradient shifting left-to-right across the screen.

---

## 🚀 How to Use

1. Create a new Vivado project targeting your FPGA board
2. Add `vga_test.v` as the sole design source
3. Assign pins in the XDC constraints file:
   - `clk_100MHz` → your board's 100 MHz clock pin
   - `h_sync`, `v_sync`, `vga_red[3:0]`, `vga_green[3:0]`, `vga_blue[3:0]` → VGA header pins
4. Run Synthesis → Implementation → Generate Bitstream → Program
5. Connect VGA cable and check for the coloured pattern on your monitor

> **If the pattern appears:** Your VGA setup is good — proceed to the main `src/` design.  
> **If the screen is blank:** Check your XDC pin assignments and ensure the monitor supports 640×480.
