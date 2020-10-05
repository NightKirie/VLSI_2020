module EX_MEM_reg (
    input clk,
    input rst,
    input rd_src_in,
    input wb_sel_in,
    input reg_w_in,
    input mem_r_in,
    input mem_w_in,
    input [31:0] pc_in,
    input [31:0] alu_in,
    input [31:0] rr2_forward_in,
    input [4:0] wr_addr_in,
    output reg rd_src_out,
    output reg wb_sel_out,
    output reg reg_w_out,
    output reg mem_r_out,
    output reg mem_w_out,
    output reg [31:0] pc_out,
    output reg [31:0] alu_out,
    output reg [31:0] rr2_forward_out,
    output reg [4:0] wr_addr_out,
);
    
always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        rd_src_out <= 0;
        wb_sel_out <= 0;
        reg_w_out <= 0;
        mem_r_out <= 0;
        mem_w_out <= 0;
        pc_out <= 32'd0;
        alu_out <= 32'd0;
        rr2_forward_out <= 32'd0;
        wr_addr_out <= 5'd0;
    end
    else begin
        rd_src_out <= rd_src_in;
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        mem_r_out <= mem_r_in;
        mem_w_out <= mem_w_in;
        pc_out <= pc_in;
        alu_out <= alu_out;
        rr2_forward_out <= rr2_forward_in;
        wr_addr_out <= we_addr_out;
    end
end

endmodule