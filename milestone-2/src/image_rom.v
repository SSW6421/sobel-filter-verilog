`timescale 1ns / 1ps
module image_rom (
    input clka,
    input [16:0] addra,
    output reg [7:0] douta
);
    // 320 x 480 = 153,600 pixels
    (* rom_style = "block" *)
    reg [7:0] rom_memory [0:153599];
    initial begin
        // Use the FULL path to your hex file, not just the filename.
        // Vivado runs synthesis from deep inside a .runs\synth_1 folder,
        // so a plain filename won't be found there.
        $readmemh("C:/Users/Sithum Vitharana/Desktop/Sobel_Filter Milestone_2/Sobel_Filter M2/image_data.hex", rom_memory);
    end
    always @(posedge clka) begin
        douta <= rom_memory[addra];
    end
endmodule