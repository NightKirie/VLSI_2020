module Branch_Control (
    input [6:0] opcode,
    input branch_flag,
    output logic [1:0] branch_ctrl
);

always_comb begin
    /* B-type is 1, JAL, choose PC+imm */
    if(branch_flag == 1'b1 || opcode == 7'b1101111)
        branch_ctrl = 2'b10;
    /* JALR */
    else if(opcode == 7'b1100111) 
        branch_ctrl = 2'b01;
    /* PC+4 */    
    else 
        branch_ctrl = 2'b00;
end

endmodule
