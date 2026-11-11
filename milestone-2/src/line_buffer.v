`timescale 1ns / 1ps
module line_buffer(
    input clk,
    input reset,
    input [7:0] pixel_in,
    output reg [7:0] p11, p12, p13,
    output reg [7:0] p21, p22, p23,
    output reg [7:0] p31, p32, p33
);
    reg [7:0] row1 [0:799];
    reg [7:0] row2 [0:799];
    integer i;
 
    // IMPORTANT FIX:
    // The shift arrays themselves are NEVER reset anymore.
    // This lets Vivado map them to cheap SRL shift-register hardware
    // instead of 12,800 separate flip-flops with reset muxes.
    // Only the small output registers get reset.
    always @(posedge clk) begin
        row1[0] <= pixel_in;
        row2[0] <= row1[799];
        for (i = 1; i < 800; i = i + 1) begin
            row1[i] <= row1[i-1];
            row2[i] <= row2[i-1];
        end
 
        if (reset) begin
            p11 <= 0; p12 <= 0; p13 <= 0;
            p21 <= 0; p22 <= 0; p23 <= 0;
            p31 <= 0; p32 <= 0; p33 <= 0;
        end else begin
            p11 <= row2[799]; p12 <= row2[798]; p13 <= row2[797];
            p21 <= row1[799]; p22 <= row1[798]; p23 <= row1[797];
            p31 <= pixel_in;  p32 <= row1[0];   p33 <= row1[1];
        end
    end
endmodule
 