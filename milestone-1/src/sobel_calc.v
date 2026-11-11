`timescale 1ns / 1ps

module sobel_calc (
    input clk, 
    input [7:0] p11, p12, p13,
    input [7:0] p21, p22, p23,
    input [7:0] p31, p32, p33,
    output reg [7:0] edge_out
);

    reg signed [10:0] gx, gy;
    reg signed [10:0] abs_gx, abs_gy;
    reg [10:0] g_sum;

   always @(*) begin
        gx = (p13 - p11) + ((p23 - p21) << 1) + (p33 - p31);
        gy = (p31 - p11) + ((p32 - p12) << 1) + (p33 - p13);

        abs_gx = (gx[10] == 1'b1) ? -gx : gx; 
        abs_gy = (gy[10] == 1'b1) ? -gy : gy;

        g_sum = abs_gx + abs_gy;

        if (g_sum > 11'd255)
            edge_out = 8'd255;
        else
            edge_out = g_sum[7:0]; 
    end

endmodule