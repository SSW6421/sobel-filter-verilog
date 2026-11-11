@echo off
echo =========================================
echo  STARTING FULL HARDWARE PIPELINE
echo =========================================

echo.
echo [1/4] Translating Image to Hex...
python generate_hex.py

echo.
echo [2/4] Running Vivado Hardware Simulation (Background)...
call C:\Xilinx\Vivado\2019.2\bin\vivado.bat -mode batch -source run_sim.tcl -notrace

echo.
echo [3/4] Saving Final Image...
python generate_image.py

echo.
echo [4/4] Launching Visualizer...
python show_results.py

echo.
echo Pipeline Finished!
pause