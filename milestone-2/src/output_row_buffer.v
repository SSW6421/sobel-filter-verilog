`timescale 1ns / 1ps

module output_row_buffer (
    input clk,
    input write_en,
    input [9:0] write_addr,
    input [7:0] write_data,
    input [9:0] read_addr,
    output [7:0] read_data
);
    (* ram_style = "distributed" *)
    reg [7:0] mem [0:319];
    integer k;
    initial begin
        for (k = 0; k < 320; k = k + 1)
            mem[k] = 8'd0;
    end

    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end

    assign read_data = mem[read_addr];
endmodule