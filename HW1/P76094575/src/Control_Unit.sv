module Control_Unit (
    input [6:0] opcode,
    /* 0: pc, 1: alu_out */
    output logic rd_src,  
    /* 0: reg, 1: imm */
    output logic alu_in2_sel,
    /* 0: pc+4, 1: pc+imm */
    output logic pc_src,
    /* 0: rd, 1: DM */
    output logic wb_sel,
    /* 0: no imm, 1: imm */
    output logic imm_sel,
    /* 0: no register write back, 1: register write back */
    output logic reg_w,
    /* 0: no DM read, 1: DM read */
    output logic mem_r,
    /* 0: no DM write, 1: DM write */
    output logic mem_w,
    output logic disable_stall
);

always_comb begin
    case (opcode)
        /* R-type */
        7'b0110011:  begin
            rd_src = 1'b1;         // alu_out     
            alu_in2_sel = 1'b0;    // reg
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b0;        
            reg_w = 1'b1;          
            mem_r = 1'b0;          
            mem_w = 1'b0;
            disable_stall = 1'b0;
        end 
        /* I-type except LW, LB, JALR */
        7'b0010011: begin
            rd_src = 1'b1;         // alu_out
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;
            reg_w = 1'b1;
            mem_r = 1'b0;
            mem_w = 1'b0;
            disable_stall = 1'b0;
        end  
        /* I-type LW, LB */
        7'b0000011: begin
            rd_src = 1'b0;         // don't care
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b1;         // DM
            imm_sel = 1'b1;
            reg_w = 1'b1;
            mem_r = 1'b1;
            mem_w = 1'b0;
            disable_stall = 1'b1;
        end 
        /* I-type JALR */
        7'b1100111: begin
            rd_src = 1'b0;         // pc
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // pc+4
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;        
            reg_w = 1'b1;
            mem_r = 1'b0;
            mem_w = 1'b0;  
            disable_stall = 1'b0;
        end
        /* S-type */
        7'b0100011: begin
            rd_src = 1'b1;         // don't care
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b0;         // don't care
            imm_sel = 1'b1;
            reg_w = 1'b0;
            mem_r = 1'b0;
            mem_w = 1'b1;  
            disable_stall = 1'b0;
        end
        /* B-type */
        7'b1100011: begin
            rd_src = 1'b0;         // pc
            alu_in2_sel = 1'b0;    // reg
            pc_src = 1'b1;         // pc+imm
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;
            reg_w = 1'b0;
            mem_r = 1'b0;
            mem_w = 1'b0;  
            disable_stall = 1'b0;
        end
        /* U-type AUIPC */
        7'b0010111: begin
            rd_src = 1'b0;         // pc
            alu_in2_sel = 1'b0;    // don't care
            pc_src = 1'b1;         // pc+imm
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;
            reg_w = 1'b1;
            mem_r = 1'b0;
            mem_w = 1'b0;
            disable_stall = 1'b0;
        end 
        /* U-type LUI */
        7'b0110111: begin
            rd_src = 1'b1;         // alu_out
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;
            reg_w = 1'b1;
            mem_r = 1'b0;
            mem_w = 1'b0; 
            disable_stall = 1'b0;
        end
        /* J-type */
        7'b1101111: begin
            rd_src = 1'b0;         // alu_out
            alu_in2_sel = 1'b1;    // imm
            pc_src = 1'b0;         // don't care
            wb_sel = 1'b0;         // rd
            imm_sel = 1'b1;
            reg_w = 1'b1;
            mem_r = 1'b0;
            mem_w = 1'b0;    
            disable_stall = 1'b0;
        end 
        default: begin
            rd_src = 1'b0;         
            alu_in2_sel = 1'b0;    
            pc_src = 1'b0;         
            wb_sel = 1'b0;         
            imm_sel = 1'b0;
            reg_w = 1'b0;
            mem_r = 1'b0;
            mem_w = 1'b0;
            disable_stall = 1'b0;
        end 
    endcase
end
endmodule
