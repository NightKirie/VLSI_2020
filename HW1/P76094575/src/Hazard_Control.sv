module Hazard_Contorl (
    input [1:0] branch_ctrl,
    input ID_EX_mem_r,
    input [4:0] IF_ID_rr1_addr,
    input [4:0] IF_ID_rr2_addr,
    input [4:0] ID_EX_rr1_addr,
    output logic PC_stall,
    output logic IM_flush,
    output logic IF_ID_stall,
    output logic Control_Unit_flush
);

always_comb begin
    // /* LW */
    // if(ID_EX_mem_r && (IF_ID_rr1_addr == ID_EX_rr1_addr || IF_ID_rr2_addr == ID_EX_rr1_addr)) begin
    //     PC_stall = 0;
    //     IM_flush = 1;
    //     IF_ID_stall = 0;
    //     Control_Unit_flush = 1;
    // end
    // /* Branch or JAL */
    // else if(branch_ctrl != 2'b00) begin
    //     PC_stall = 1;
    //     IM_flush = 1;
    //     IF_ID_stall = 1;
    //     Control_Unit_flush = 1;
    // end
    // else begin
        PC_stall = 0;
        IM_flush = 0;
        IF_ID_stall = 0;
        Control_Unit_flush = 0;
    
    //end
end

endmodule