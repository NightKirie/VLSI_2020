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
    input [4:0] rr2_addr_in,
    input [31:0] rr2_data_in,
    input [4:0] wr_addr_in,
    output logic rd_src_out,
    output logic wb_sel_out,
    output logic reg_w_out,
    output logic mem_r_out,
    output logic mem_w_out,
    output logic [31:0] pc_out,
    output logic [31:0] alu_out,
    output logic [4:0] rr2_addr_out,
    output logic [31:0] rr2_data_out,
    output logic [4:0] wr_addr_out
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
        rr2_addr_out <= 5'd0;
        rr2_data_out <= 32'd0;
        wr_addr_out <= 5'd0;
    end
    else begin
        rd_src_out <= rd_src_in;
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        mem_r_out <= mem_r_in;
        mem_w_out <= mem_w_in;
        pc_out <= pc_in;
        alu_out <= alu_in;
        rr2_addr_out <= rr2_addr_in;
        rr2_data_out <= rr2_data_in;
        wr_addr_out <= wr_addr_in;
    end
end

endmodule