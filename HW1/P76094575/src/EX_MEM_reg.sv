module EX_MEM_reg (
    input clk,
    input rst,
    input EX_MEM_stall,
    input EX_MEM_flush,
    input rd_src_in,
    input wb_sel_in,
    input reg_w_in,
    input mem_r_in,
    input mem_w_in,
    input disable_stall_in,
    input [31:0] pc_in,
    input [31:0] alu_in,
    input [4:0] rr2_addr_in,
    input [31:0] rr2_data_in,
    input [4:0] wr_addr_in,
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    input [1:0] branch_flag_in,
    input [31:0] pc_add_imm_in,
    output logic rd_src_out,
    output logic wb_sel_out,
    output logic reg_w_out,
    output logic mem_r_out,
    output logic mem_w_out,
    output logic disable_stall_out,
    output logic [31:0] pc_out,
    output logic [31:0] alu_out,
    output logic [4:0] rr2_addr_out,
    output logic [31:0] rr2_data_out,
    output logic [4:0] wr_addr_out,
    output logic [6:0] opcode_out,
    output logic [2:0] funct3_out,
    output logic [1:0] branch_flag_out,
    output logic [31:0] pc_add_imm_out
);
    
always_ff @(posedge clk, posedge rst) begin
    if(rst || EX_MEM_flush) begin
        rd_src_out <= 0;
        wb_sel_out <= 0;
        reg_w_out <= 0;
        mem_r_out <= 0;
        mem_w_out <= 0;
        disable_stall_out <= 1'd0;
        pc_out <= 32'd0;
        alu_out <= 32'd0;
        rr2_addr_out <= 5'd0;
        rr2_data_out <= 32'd0;
        wr_addr_out <= 5'd0;
        opcode_out <= 7'd0;
        funct3_out <= 3'd0;
        branch_flag_out <= 2'd0;
        pc_add_imm_out <= 32'd0;
    end
    else if(EX_MEM_stall) begin
        disable_stall_out <= 1'd0;
    end
    else begin
        rd_src_out <= rd_src_in;
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        mem_r_out <= mem_r_in;
        mem_w_out <= mem_w_in;
        disable_stall_out <= disable_stall_in;
        pc_out <= pc_in;
        alu_out <= alu_in;
        rr2_addr_out <= rr2_addr_in;
        rr2_data_out <= rr2_data_in;
        wr_addr_out <= wr_addr_in;
        opcode_out <= opcode_in;
        funct3_out <= funct3_in;
        branch_flag_out <= branch_flag_in;
        pc_add_imm_out <= pc_add_imm_in;
    end
end

endmodule