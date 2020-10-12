module ALU (
    input [4:0] alu_ctrl,
    input [31:0] alu_in1,
    input [31:0] alu_in2,
    output logic [31:0] alu_out,
    output logic branch_flag
);

parameter [4:0] alu_nop = 5'd0,
                alu_add = 5'd1,
                alu_sub = 5'd2,
                alu_slts = 5'd3,
                alu_sltu = 5'd4,
                alu_slu = 5'd5,
                alu_srs = 5'd6,
                alu_sru = 5'd7,
                alu_and = 5'd8,
                alu_or = 5'd9,
                alu_xor = 5'd10,
                alu_beq = 5'd11,
                alu_bne = 5'd12,
                alu_blts = 5'd13,
                alu_bltu = 5'd14,
                alu_bges = 5'd15,
                alu_bgeu = 5'd16;
                

always_comb begin
    case(alu_ctrl)
        alu_nop: begin
            alu_out = alu_in2;
            branch_flag = 32'd0;
        end 
        alu_add: begin
            alu_out = alu_in1 + alu_in2;
            branch_flag = 32'd0;
        end
        alu_sub: begin
            alu_out = alu_in1 - alu_in2;
            branch_flag = 32'd0;
        end 
        alu_slts: begin
            alu_out = ($signed(alu_in1) < $signed(alu_in2)) ? 1 : 0;
            branch_flag = 32'd0;
        end
        alu_sltu: begin
            alu_out = (alu_in1 < alu_in2) ? 1 : 0;
            branch_flag = 32'd0;
        end
        alu_slu: begin
            alu_out = alu_in1 << alu_in2[4:0];
            branch_flag = 32'd0;
        end 
        alu_srs: begin
            alu_out = $signed(alu_in1) >>> alu_in2[4:0];
            branch_flag = 32'd0;
        end 
        alu_sru: begin
            alu_out = alu_in1 >> alu_in2[4:0];
            branch_flag = 32'd0;
        end 
        alu_and: begin
            alu_out = alu_in1 & alu_in2;
            branch_flag = 0;
        end 
        alu_or: begin
            alu_out = alu_in1 | alu_in2;
            branch_flag = 0;
        end 
        alu_xor: begin
            alu_out = alu_in1 ^ alu_in2;
            branch_flag = 0;
        end 
        alu_beq: begin
            alu_out = 0;
            branch_flag = (alu_in1 == alu_in2) ? 1 : 0;
        end 
        alu_bne: begin
            alu_out = 0;
            branch_flag = (alu_in1 != alu_in2) ? 1 : 0;
        end 
        alu_blts: begin
            alu_out = 0;
            branch_flag = ($signed(alu_in1) < $signed(alu_in2)) ? 1 : 0;
        end
        alu_bltu: begin
            alu_out = 0;
            branch_flag = (alu_in1 < alu_in2) ? 1 : 0;
        end
        alu_bges: begin
            alu_out = 0;
            branch_flag = ($signed(alu_in1) >= $signed(alu_in2)) ? 1 : 0;
        end
        alu_bgeu: begin
            alu_out = 0;
            branch_flag = (alu_in1 >= alu_in2) ? 1 : 0;
        end
        default: begin
            alu_out = 32'd0;
            branch_flag = 32'd0;
        end
    endcase
end

endmodule