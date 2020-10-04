module ALU_Control (
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg alu_ctrl
);

parameter [4:0] alu_nop = 5'd0,
                alu_add = 5'd1,
                alu_sub = 5'd2,
                alu_slts = 5'd3,
                alu_sltu = 5'd4,
                alu_slu = 5'd5,
                alu_srs = 5'd6,
                alu_sru = 5'd7,
                alu_beq = 5'd8,
                alu_bne = 5'd9,
                alu_blts = 5'd10
                alu_bltu = 5'd11,
                alu_bges = 5'd12,
                alu_bgeu = 5'd13,
                alu_and = 5'd14,
                alu_or = 5'd15,
                alu_xor = 5'd16;

always_comb begin
    case({funt3, opcode})
        /* ADD, SUB */
        {3'b000, 7'b0110011},
        /* LW */
        {3'b010, 7'b0000011},
        /* ADDI */
        {3'b000, 7'b0010011},
        /* LB */
        {3'b000, 7'b0000011},
        /* JALR */
        {3'b000, 7'b1100111},
        /* SW */
        {3'b010, 7'b0100011},
        /* SB */
        {3'b000, 7'b0100011}: begin
            if(funct7[5] == 0)
                alu_ctrl = alu_add;    
            else 
                alu_ctrl = alu_sub;
        end
        /* SLL */
        {3'b001, 7'b0110011},
        /* SLLI */
        {3'b001, 7'b0010011}: begin
            alu_ctrl = alu_slu;    
        end
        /* SLT */
        {3'b010, 7'b0110011},
        /* SLTI */
        {3'b010, 7'b0010011}: begin
            alu_ctrl = alu_slts;    
        end
        /* SLTU */
        {3'b011, 7'b0110011},
        /* STLIU */
        {3'b011, 7'b0010011}: begin
            alu_ctrl = alu_sltu;    
        end
        /* XOR */
        {3'b100, 7'b0110011},
        /* XORI */
        {3'b100, 7'b0010011}: begin
            alu_ctrl = alu_xor;    
        end
        /* SRL, SRA */
        {3'b101, 7'b0110011},
        /* SRLI, SRAI */
        {3'b101, 7'b0010011}: begin
            if(funct7[5] == 0)
                alu_ctrl = alu_srs;    
            else 
                alu_ctrl = alu_sru;
        end
        /* OR */
        {3'b110, 7'b0110011},
        /* ORI */
        {3'b110, 7'b0010011}: begin
            alu_ctrl = alu_or;    
        end
        /* AND */
        {3'b111, 7'b0110011},
        /* ANDI */
        {3'b111, 7'b0110011}: begin
            alu_ctrl = alu_and;    
        end
        /* BEQ */
        {3'b000, 7'b1100011}: begin
            alu_ctrl = alu_beq;
        end
        /* BNE */
        {3'b001, 7'b1100011}: begin
            alu_ctrl = alu_bne;
        end
        /* BLT */
        {3'b100, 7'b1100011}: begin
            alu_ctrl = alu_blts;
        end
        /* BGE */
        {3'b101, 7'b1100011}: begin
            alu_ctrl = alu_bges;
        end
        /* BLTU */
        {3'b110, 7'b1100011}: begin
            alu_ctrl = alu_bltu;
        end
        /* BGEU */
        {3'b111, 7'b1100011}: begin
            alu_ctrl = alu_bgeu;
        end
        /* AUIPC, LUI, JAL */
        default: 
            alu_ctrl = alu_nop;
    endcase
end
    
endmodule