import cv2
import sys

def create_hex_file(image_filename, hex_filename, size=256):
    print(f"Loading {image_filename}...")
    
    # 1. Read the image and force it into Grayscale (black and white)
    img = cv2.imread(image_filename, cv2.IMREAD_GRAYSCALE)
    
    if img is None:
        print(f"ERROR: Could not find '{image_filename}'. Check the spelling!")
        sys.exit()

    # 2. Resize the image to 256x256. 
    img = cv2.resize(img, (size, size))
    
    # 3. Open the new text file to write our hex values
    print(f"Translating to hex and saving to {hex_filename}...")
    with open(hex_filename, 'w') as f:
        
        for row in img:
            for pixel in row:
                hex_str = format(pixel, '02x')
                f.write(hex_str + '\n')

    print(f"Success! Translated {size * size} pixels into {hex_filename}.")

# --- Execution ---
if __name__ == "__main__":
    create_hex_file("test_image.jpg", "input_image.hex")
