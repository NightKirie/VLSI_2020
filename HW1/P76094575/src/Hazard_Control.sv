module Hazard_Contorl (
    input [1:0] branch_ctrl,
    input ID_EX_mem_r,
    input EX_MEM_reg_disable_stall,
    input [4:0] IF_ID_rr1_addr,
    input [4:0] IF_ID_rr2_addr,
    input [4:0] ID_EX_rr2_addr,
    output logic PC_stall,
    output logic IM_stall,
    output logic IF_ID_stall,
    output logic ID_EX_stall,
    output logic EX_MEM_stall,
    output logic MEM_WB_stall,
    output logic IM_flush,
    output logic IF_ID_flush,
    output logic ID_EX_flush,
    output logic EX_MEM_flush
);

always_comb begin
    /* LW */
    if(ID_EX_mem_r) begin// && (IF_ID_rr1_addr == ID_EX_rr2_addr || IF_ID_rr2_addr == ID_EX_rr2_addr)) begin
        PC_stall = EX_MEM_reg_disable_stall;
        IM_stall = 1;
        IF_ID_stall = EX_MEM_reg_disable_stall;
        ID_EX_stall = EX_MEM_reg_disable_stall;
        EX_MEM_stall = EX_MEM_reg_disable_stall;
        MEM_WB_stall = EX_MEM_reg_disable_stall;
        IM_flush = 0;
        IF_ID_flush = 0;
        ID_EX_flush = 0;
        EX_MEM_flush = 0;
    end
    /* Branch or JAL */
    else if(branch_ctrl != 2'b00) begin
        PC_stall = 0;
        IM_stall = 0;
        IF_ID_stall = 0;
        ID_EX_stall = 0;
        EX_MEM_stall = 0;
        MEM_WB_stall = 0;
        IM_flush = 1;
        IF_ID_flush = 1;
        ID_EX_flush = 1;
        EX_MEM_flush = 0;
    end
    else begin
        PC_stall = 0;
        IM_stall = 0;
        IF_ID_stall = 0;
        ID_EX_stall = 0;
        EX_MEM_stall = 0;
        MEM_WB_stall = 0;
        IM_flush = 0;
        IF_ID_flush = 0;
        ID_EX_flush = 0;
        EX_MEM_flush = 0;
    end
end

endmodule