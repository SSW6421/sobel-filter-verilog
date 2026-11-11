`timescale 1ns / 1ps

module tb_sobel();

    reg clk;
    reg [7:0] p11, p12, p13;
    reg [7:0] p21, p22, p23;
    reg [7:0] p31, p32, p33;
    wire [7:0] edge_out;

    sobel_calc uut (
        .clk(clk),
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .edge_out(edge_out)
    );

    reg [7:0] image_in [0:65535];
    
    integer file_out;
    integer r, c;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        
        $readmemh("C:/Users/Sithum Vitharana/Desktop/Sobel_Filter/input_image.hex", image_in);
        file_out = $fopen("C:/Users/Sithum Vitharana/Desktop/Sobel_Filter/output_image.hex", "w");

        for (r = 0; r < 256; r = r + 1) begin
            for (c = 0; c < 256; c = c + 1) begin
                
                if (r == 0 || r == 255 || c == 0 || c == 255) begin
                    $fwrite(file_out, "00\n");
                end else begin
                    p11 = image_in[(r-1)*256 + (c-1)];
                    p12 = image_in[(r-1)*256 + c];
                    p13 = image_in[(r-1)*256 + (c+1)];
                    
                    p21 = image_in[r*256 + (c-1)];
                    p22 = image_in[r*256 + c];
                    p23 = image_in[r*256 + (c+1)];
                    
                    p31 = image_in[(r+1)*256 + (c-1)];
                    p32 = image_in[(r+1)*256 + c];
                    p33 = image_in[(r+1)*256 + (c+1)];

                    #10; 
                    $fwrite(file_out, "%02x\n", edge_out);
                end
            end
        end

        $fclose(file_out);
        $display("Simulation Complete! output_image.hex has been generated.");
        $finish;
    end

endmodule