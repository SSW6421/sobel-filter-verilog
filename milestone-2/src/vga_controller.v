`timescale 1ns / 1ps
module vga_controller (
    input clk_25MHz,
    input reset,
    output reg h_sync,
    output reg v_sync,
    output video_on,
    output [9:0] pixel_x,
    output [9:0] pixel_y
);
    parameter HD = 640;
    parameter HF = 16;
    parameter HB = 48;
    parameter HR = 96;
    parameter MAX_H = HD + HF + HB + HR - 1;
    parameter VD = 480;
    parameter VF = 10;
    parameter VB = 33;
    parameter VR = 2;
    parameter MAX_V = VD + VF + VB + VR - 1;

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    always @(posedge clk_25MHz) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == MAX_H) begin
                h_count <= 0;
                if (v_count == MAX_V)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    always @(posedge clk_25MHz) begin
        h_sync <= ~((h_count >= (HD + HF)) && (h_count < (HD + HF + HR)));
        v_sync <= ~((v_count >= (VD + VF)) && (v_count < (VD + VF + VR)));
    end

    assign video_on = (h_count < HD) && (v_count < VD);
    assign pixel_x  = h_count;
    assign pixel_y  = v_count;
endmodule