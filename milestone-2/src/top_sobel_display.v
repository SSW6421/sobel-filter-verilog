`timescale 1ns / 1ps
module top_sobel_display (
    input clk_100MHz,
    input reset,
    output h_sync,
    output v_sync,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue
);

    // ---- 100MHz -> 25MHz pixel clock ----
    reg pixel_clk = 0;
    reg [1:0] clk_div = 0;
    always @(posedge clk_100MHz) begin
        clk_div <= clk_div + 1;
        pixel_clk <= clk_div[1];
    end

    // ---- VGA timing ----
    wire video_on;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;

    vga_controller vga_inst (
        .clk_25MHz(pixel_clk),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // ---- Fetch image data only for the valid 320 x 480 region ----
    wire fetch_enable = (pixel_x < 10'd320) && (pixel_y < 10'd480);
    wire [9:0] fetch_row = (pixel_y < 10'd480) ? pixel_y : 10'd479;
    wire [9:0] fetch_col = (pixel_x < 10'd320) ? pixel_x : 10'd319;
    wire [16:0] rom_addr = fetch_row * 320 + fetch_col;

    wire [7:0] raw_pixel;
    image_rom rom_inst (
        .clka(pixel_clk),
        .addra(rom_addr),
        .douta(raw_pixel)
    );

    // ---- 3x3 sliding window ----
    wire [7:0] p11, p12, p13, p21, p22, p23, p31, p32, p33;
    pixel_window window_inst (
        .clk(pixel_clk),
        .enable(fetch_enable),
        .reset(reset),
        .pixel_in(raw_pixel),
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33)
    );

    // ---- Sobel math ----
    wire [7:0] sobel_pixel;
    sobel_calc sobel_inst (
        .clk(pixel_clk),
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .sobel_out(sobel_pixel)
    );

    // ---- Row buffer: write during left half, read during right half ----
    // Pipeline delay = 1 cycle (pixel_window latch) + 4 cycles (sobel_calc) = 5 cycles.
    wire write_en = (pixel_x >= 10'd5) && (pixel_x <= 10'd324) && (pixel_y < 10'd480);
    wire [9:0] write_addr = pixel_x - 10'd5;
    wire [9:0] read_addr  = (pixel_x >= 10'd320 && pixel_x < 10'd640) ? (pixel_x - 10'd320) : 10'd0;
    wire [7:0] edge_pixel;

    output_row_buffer rowbuf_inst (
        .clk(pixel_clk),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(sobel_pixel),
        .read_addr(read_addr),
        .read_data(edge_pixel)
    );

    // ---- Final pixel: left = live original, right = edge map of the row just above ----
    wire [7:0] final_pixel = (pixel_x < 10'd320) ? raw_pixel : edge_pixel;
    wire valid_frame = video_on && (pixel_y < 10'd480);

    assign vga_red   = valid_frame ? final_pixel[7:4] : 4'h0;
    assign vga_green = valid_frame ? final_pixel[7:4] : 4'h0;
    assign vga_blue  = valid_frame ? final_pixel[7:4] : 4'h0;

endmodule