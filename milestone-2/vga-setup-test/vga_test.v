`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 11:17:19 AM
// Design Name: 
// Module Name: vga_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_test(
  input clk_100MHz,
  output [3:0] vga_red, vga_green, vga_blue,
  output h_sync, v_sync
);
  reg [1:0] div = 0;
  reg [9:0] h = 0, v = 0;

  always @(posedge clk_100MHz) begin
    div <= div + 1;
    if (div == 3) begin
      if (h == 799) begin
        h <= 0;
        v <= (v == 524) ? 0 : v + 1;
      end else h <= h + 1;
    end
  end

  wire active = (h < 640 && v < 480);
  assign h_sync    = ~(h >= 656 && h < 752);
  assign v_sync    = ~(v >= 490 && v < 492);
  assign vga_red   = active ? 4'hF : 4'h0;
  assign vga_green = 4'h0;
  assign vga_blue  = active ? h[7:4] : 4'h0;
endmodule