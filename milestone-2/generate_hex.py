import cv2
import numpy as np

def create_center_cropped_hex(image_path, output_hex_path):
    # 1. Load the original image in grayscale (0 flag)
    img = cv2.imread(image_path, 0)
    
    if img is None:
        print(f"Error: Could not open or find the image '{image_path}'")
        return

    orig_h, orig_w = img.shape
    print(f"Original image dimensions: {orig_w}x{orig_h}")

    # 2. Calculate center-crop coordinates for a target 320x480 (3:4 aspect ratio)
    target_aspect = 320.0 / 480.0  # 0.6667
    orig_aspect = float(orig_w) / float(orig_h)

    if orig_aspect > target_aspect:
        # Image is too wide: match height, crop width sides
        new_w = int(orig_h * target_aspect)
        new_h = orig_h
        x_offset = (orig_w - new_w) // 2
        y_offset = 0
    else:
        # Image is too tall: match width, crop top/bottom sides
        new_w = orig_w
        new_h = int(orig_w / target_aspect)
        x_offset = 0
        y_offset = (orig_h - new_h) // 2

    # Crop out the calculated box
    cropped_img = img[y_offset:y_offset+new_h, x_offset:x_offset+new_w]
    
    # 3. Downsample to the exact target hardware boundaries
    final_img = cv2.resize(cropped_img, (320, 480), interpolation=cv2.INTER_AREA)
    
    # Flatten the 2D array into a 1D sequence of bytes
    pixels = final_img.flatten()

    # Hardware resource sanity check verification
    print(f"Cropped region dimensions: {new_w}x{new_h}")
    print(f"Resized image dimensions: {final_img.shape[1]}x{final_img.shape[0]}")
    print(f"Total elements to write: {len(pixels)}")
    
    if len(pixels) != 153600:
        print("CRITICAL ERROR: Pixel count is incorrect. Halting generation.")
        return

    # 4. Generate the plain text hex file ($readmemh format)
    with open(output_hex_path, "w") as f:
        for p in pixels:
            f.write(f"{p:02x}\n")

    print(f"Success! '{output_hex_path}' generated for deployment.")

# Execute script (Make sure 'input_image.png' or your photo file is in the same folder)
create_center_cropped_hex("input_image.png", "image_data.hex")
