module Forward_Control (
    input [4:0] EX_MEM_wr_addr,
    input [4:0] MEM_WB_wr_addr,
    input [4:0] ID_EX_rr1_addr,
    input [4:0] ID_EX_rr2_addr,
    input [4:0] EX_MEM_rr2_addr,
    input EX_MEM_reg_w,
    input MEM_WB_reg_w,
    input EX_MEM_mem_w,
    output logic [1:0] forward_alu_in1,
    output logic [1:0] forward_alu_in2,
    output logic forward_data_memory
);

always_comb begin
    /* alu_in1 */
    if(EX_MEM_reg_w && (EX_MEM_wr_addr != 0) && (EX_MEM_wr_addr == ID_EX_rr1_addr))
       forward_alu_in1 = 2'b10;
    else if(MEM_WB_reg_w && (MEM_WB_wr_addr != 0) && (MEM_WB_wr_addr == ID_EX_rr1_addr))
        forward_alu_in1 = 2'b01;
    else 
        forward_alu_in1 = 2'b00;
    /* alu_in2 */
    if(EX_MEM_reg_w && (EX_MEM_wr_addr != 0) && (EX_MEM_wr_addr == ID_EX_rr2_addr))
       forward_alu_in2 = 2'b10;
    else if(MEM_WB_reg_w && (MEM_WB_wr_addr != 0) && (MEM_WB_wr_addr == ID_EX_rr2_addr))
        forward_alu_in2 = 2'b01;
    else 
       forward_alu_in2 = 2'b00;
    /* data_memory */
    if(MEM_WB_reg_w && EX_MEM_mem_w && (EX_MEM_rr2_addr == MEM_WB_wr_addr))
        forward_data_memory = 1;
    else 
        forward_data_memory = 0;
end

endmodule