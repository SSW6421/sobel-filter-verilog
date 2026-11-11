import cv2
import numpy as np
import matplotlib.pyplot as plt
import sys

def view_hardware_results(hex_filename, original_filename, size=256):
    print("Reading hardware output...")
    
    # 1. Read the Verilog Hex Output
    pixels = []
    try:
        with open(hex_filename, 'r') as f:
            for line in f:
                hex_val = line.strip()
                if hex_val: 
                    pixels.append(int(hex_val, 16))
    except FileNotFoundError:
        print(f"ERROR: '{hex_filename}' not found. Run Vivado first!")
        sys.exit()

    # 2. Reshape into the Hardware Image
    pixel_array = np.array(pixels, dtype=np.uint8)
    try:
        hw_image = pixel_array.reshape((size, size))
    except ValueError:
        print(f"ERROR: Found {len(pixels)} pixels. Expected {size*size}. Run Vivado with 'run all'!")
        sys.exit()

    # 3. Load the Original Image
    orig_image = cv2.imread(original_filename, cv2.IMREAD_GRAYSCALE)
    if orig_image is None:
        print(f"ERROR: '{original_filename}' not found.")
        sys.exit()
    orig_image = cv2.resize(orig_image, (size, size))

    # 4. Launch the Clean Side-by-Side GUI
    plt.figure(figsize=(10, 5))
    plt.suptitle("Hardware Edge Detection Results", fontsize=16, fontweight='bold')
    
    # Left Side: Original
    plt.subplot(1, 2, 1)
    plt.title("Original Image")
    plt.imshow(orig_image, cmap='gray')
    plt.axis('off')
    
    # Right Side: Hardware Output
    plt.subplot(1, 2, 2)
    plt.title("Verilog Hardware Output")
    plt.imshow(hw_image, cmap='gray')
    plt.axis('off')
    
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    view_hardware_results("output_image.hex", "test_image.jpg")
