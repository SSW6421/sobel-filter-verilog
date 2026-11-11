import cv2
import numpy as np
import sys

def hex_to_image(hex_filename, output_image_filename, size=256):
    print(f"Reading hardware data from {hex_filename}...")
    
    pixels = []
    try:
        # 1. Open the output file your Verilog testbench created
        with open(hex_filename, 'r') as f:
            for line in f:
                hex_val = line.strip()
                if hex_val: # Skip any empty lines
                    # 2. Convert the hex string (e.g., "ff") back to an integer (255)
                    pixels.append(int(hex_val, 16))
    except FileNotFoundError:
        print(f"ERROR: Could not find '{hex_filename}'.")
        sys.exit()

    # 3. Convert the list of numbers into a NumPy array of 8-bit integers
    pixel_array = np.array(pixels, dtype=np.uint8)
    
    # 4. Reshape the long 1D array back into a 256x256 2D image grid
    try:
        image_matrix = pixel_array.reshape((size, size))
    except ValueError:
        print(f"ERROR: Found {len(pixels)} pixels, but expected {size*size}. Did the simulation finish?")
        sys.exit()
    
    # 5. Save the final image
    cv2.imwrite(output_image_filename, image_matrix)
    print(f"Success! Saved edge-detected image to {output_image_filename}")

# --- Execution ---
if __name__ == "__main__":
    # Make sure these filenames match exactly what Vivado outputted!
    hex_to_image("output_image.hex", "output_image.jpg")
