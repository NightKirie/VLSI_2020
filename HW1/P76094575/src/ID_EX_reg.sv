module moduleName (
    input clk,
    input rst,
    input rd_src_in,
    input branch_en_in,
    input alu_in2_sel_in,
    input pc_src_in,
    input wb_sel_in,
    input reg_w_in,
    input mem_r_in,
    input mem_w_in,
    input [31:0] pc_in,
    input [31:0] rr1_data_in,
    input [31:0] rr2_data_in,
    input [4:0] rr1_addr_in,
    input [4:0] rr2_addr_in,
    input [4:0] wr_addr_in,
    input [4:0] alu_ctrl_in,
    input [31:0] imm_in,
    input [6:0] opcode_in,
    output logic rd_src_out,
    output logic branch_en_out,
    output logic alu_in2_sel_out,
    output logic pc_src_out,
    output logic wb_sel_out,
    output logic reg_w_out,
    output logic mem_r_out,
    output logic mem_w_out,
    output logic [31:0] pc_out,
    output logic [31:0] rr1_data_out,
    output logic [31:0] rr2_data_out,
    output logic [4:0] rr1_addr_out,
    output logic [4:0] rr2_addr_out,
    output logic [4:0] wr_addr_out,
    output logic [4:0] alu_ctrl_out,
    output logic [31:0] imm_out,
    output logic [6:0] opcode_out
);

always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        rd_src_out <= 0;
        branch_en_out <= 0;
        alu_in2_sel_out <= 0;
        pc_src_out <= 0;
        wb_sel_out <= 0;
        reg_w_out <= 0;
        mem_r_out <= 0;
        mem_w_out <= 0;
        pc_out <= 32'd0;
        rr1_data_out <= 32'd0;
        rr2_data_out <= 32'd0;
        rr1_addr_out <= 5'd0;
        rr2_addr_out <= 5'd0;
        wr_addr_out <= 5'd0;
        alu_ctrl_out <= 5'd0;
        imm_out <= 32'd0;
        opcode_out <= 7'd0;
    end
    else begin
        rd_src_out <= rd_src_in;
        branch_en_out <= branch_en_in;
        alu_in2_sel_out <= alu_in2_sel_in;
        pc_src_out <= pc_src_in;
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        mem_r_out <= mem_r_in;
        mem_w_out <= mem_w_in;
        pc_out <= pc_in;
        rr1_data_out <= rr1_data_in;
        rr2_data_out <= rr2_data_in;
        rr1_addr_out <= rr1_addr_in;
        rr2_addr_out <= rr2_addr_in;
        wr_addr_out <= wr_addr_in;
        alu_ctrl_out <= alu_ctrl_in;
        imm_out <= imm_in;
        opcode_out <= opcode_in;
    end
end
    
endmodule