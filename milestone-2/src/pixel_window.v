`timescale 1ns / 1ps

module pixel_window (
    input clk,
    input enable,
    input reset,
    input [7:0] pixel_in,
    output reg [7:0] p11, p12, p13,
    output reg [7:0] p21, p22, p23,
    output reg [7:0] p31, p32, p33
);
    reg [7:0] row1 [0:319];
    reg [7:0] row2 [0:319];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            p11 <= 0; p12 <= 0; p13 <= 0;
            p21 <= 0; p22 <= 0; p23 <= 0;
            p31 <= 0; p32 <= 0; p33 <= 0;
        end else if (enable) begin
            row1[0] <= pixel_in;
            row2[0] <= row1[319];
            for (i = 1; i < 320; i = i + 1) begin
                row1[i] <= row1[i-1];
                row2[i] <= row2[i-1];
            end
            p11 <= row2[319]; p12 <= row2[318]; p13 <= row2[317];
            p21 <= row1[319]; p22 <= row1[318]; p23 <= row1[317];
            p31 <= pixel_in;  p32 <= row1[0];   p33 <= row1[1];
        end
    end
endmodule