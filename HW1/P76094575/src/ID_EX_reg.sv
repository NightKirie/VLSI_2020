module ID_EX_reg (
    input clk,
    input rst,
    input ID_EX_stall,
    input ID_EX_flush,
    input rd_src_in,
    input alu_in2_sel_in,
    input pc_src_in,
    input wb_sel_in,
    input reg_w_in,
    input mem_r_in,
    input mem_w_in,
    input disable_stall_in,
    input [31:0] pc_in,
    input [31:0] rr1_data_in,
    input [31:0] rr2_data_in,
    input [4:0] rr1_addr_in,
    input [4:0] rr2_addr_in,
    input [4:0] wr_addr_in,
    input [4:0] alu_ctrl_in,
    input [31:0] imm_in,
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    output logic rd_src_out,
    output logic alu_in2_sel_out,
    output logic pc_src_out,
    output logic wb_sel_out,
    output logic reg_w_out,
    output logic mem_r_out,
    output logic mem_w_out,
    output logic disable_stall_out,
    output logic [31:0] pc_out,
    output logic [31:0] rr1_data_out,
    output logic [31:0] rr2_data_out,
    output logic [4:0] rr1_addr_out,
    output logic [4:0] rr2_addr_out,
    output logic [4:0] wr_addr_out,
    output logic [4:0] alu_ctrl_out,
    output logic [31:0] imm_out,
    output logic [6:0] opcode_out,
    output logic [2:0] funct3_out
);

logic flush_second_time;

always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        rd_src_out <= 1'd0;
        alu_in2_sel_out <= 1'd0;
        pc_src_out <= 1'd0;
        wb_sel_out <= 1'd0;
        reg_w_out <= 1'd0;
        mem_r_out <= 1'd0;
        mem_w_out <= 1'd0;
        disable_stall_out <= 1'd0;
        pc_out <= 32'd0;
        rr1_data_out <= 32'd0;
        rr2_data_out <= 32'd0;
        rr1_addr_out <= 5'd0;
        rr2_addr_out <= 5'd0;
        wr_addr_out <= 5'd0;
        alu_ctrl_out <= 5'd0;
        imm_out <= 32'd0;
        opcode_out <= 7'd0;
        funct3_out <= 3'd0;
        flush_second_time <= 1'b0;
    end
    else if (ID_EX_flush || flush_second_time) begin
        rd_src_out <= 1'd0;
        alu_in2_sel_out <= 1'd0;
        pc_src_out <= 1'd0;
        wb_sel_out <= 1'd0;
        reg_w_out <= 1'd0;
        mem_r_out <= 1'd0;
        mem_w_out <= 1'd0;
        disable_stall_out <= 1'd0;
        pc_out <= 32'd0;
        rr1_data_out <= 32'd0;
        rr2_data_out <= 32'd0;
        rr1_addr_out <= 5'd0;
        rr2_addr_out <= 5'd0;
        wr_addr_out <= 5'd0;
        alu_ctrl_out <= 5'd0;
        imm_out <= 32'd0;
        opcode_out <= 7'd0;
        funct3_out <= 3'd0;
        flush_second_time <= !flush_second_time;
    end
    else if(!ID_EX_stall) begin
        rd_src_out <= rd_src_in;
        alu_in2_sel_out <= alu_in2_sel_in;
        pc_src_out <= pc_src_in;
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        mem_r_out <= mem_r_in;
        mem_w_out <= mem_w_in;
        disable_stall_out <= disable_stall_in;
        pc_out <= pc_in;
        rr1_data_out <= rr1_data_in;
        rr2_data_out <= rr2_data_in;
        rr1_addr_out <= rr1_addr_in;
        rr2_addr_out <= rr2_addr_in;
        wr_addr_out <= wr_addr_in;
        alu_ctrl_out <= alu_ctrl_in;
        imm_out <= imm_in;
        opcode_out <= opcode_in;
        funct3_out <= funct3_in;
    end
end
    
endmodule