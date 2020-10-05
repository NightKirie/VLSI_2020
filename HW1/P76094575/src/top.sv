`include "CPU.sv"
`include "SRAM_wrapper.sv"

module top(
    input clk,
    input rst
);

wire [31:0] im_addr;
wire [31:0] im_data_out;
wire dm_output_en;
wire dm_write_en;
wire [31:0] dm_addr;
wire [31:0] dm_data_in;
wire [31:0] dm_data_out;

CPU CPU1(
    /* input */
    .clk(clk),
    .rst(rst),
    .im_addr(im_addr),
    .dm_output_en(dm_output_en),
    .dm_write_en(dm_write_en),
    .dm_addr(dm_addr),
    .dm_data_in(dm_data_in),
    /* output */
    .im_data_out(im_data_out),
    .dm_data_out(dm_data_out)
);

SRAM_wrapper IM1(
    /* input */
    .CK(clk),
    .CS(1),
    .OE(1),
    .WEB(4'b1111),
    .A(im_addr[15:2]),
    .DI(32'd0),
    /* output */
    .DO(im_data_out)
);

SRAM_wrapper DM1(
    /* input */
    .CK(clk),
    .CS(1),
    .OE(dm_output_en),
    .WEB(dm_write_en),
    .A(dm_addr[15:2]),
    .DI(dm_data_in),
    /* output */
    .DO(dm_data_out)
);

endmodule
