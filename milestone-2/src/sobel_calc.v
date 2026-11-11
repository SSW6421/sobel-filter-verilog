`timescale 1ns / 1ps
module sobel_calc (
    input clk,
    input [7:0] p11, p12, p13,
    input [7:0] p21, p22, p23,
    input [7:0] p31, p32, p33,
    output reg [7:0] sobel_out
);
    reg signed [10:0] Gx;
    reg signed [10:0] Gy;
    reg [10:0] abs_Gx;
    reg [10:0] abs_Gy;
    reg [11:0] sum_G;

    always @(posedge clk) begin
        Gx <= ((p13 + (p23 << 1) + p33) - (p11 + (p21 << 1) + p31));
        Gy <= ((p31 + (p32 << 1) + p33) - (p11 + (p12 << 1) + p13));
        abs_Gx <= (Gx[10] == 1'b1) ? -Gx : Gx;
        abs_Gy <= (Gy[10] == 1'b1) ? -Gy : Gy;
        sum_G  <= abs_Gx + abs_Gy;
        if (sum_G > 11'hFF)
            sobel_out <= 8'hFF;
        else
            sobel_out <= sum_G[7:0];
    end
endmodule