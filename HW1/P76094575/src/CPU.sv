`include "Add.sv"
`include "ALU_Control.sv"
`include "ALU.sv"
`include "Branch_Control.sv"
`include "Control_Unit.sv"
`include "EX_MEM_reg.sv"
`include "Forward_Control.sv"
`include "Hazard_Control.sv"
`include "ID_EX_reg.sv"
`include "IF_ID_reg.sv"
`include "Imm_Gen.sv"
`include "Mux.sv"
`include "PC.sv"
`include "Register.sv"

module CPU (
    input clk,
    input rst,
    output logic [31:0] im_addr,
    output logic [31:0] im_data_out,
    output logic dm_output_en,
    output logic dm_write_en,
    output logic [31:0] dm_addr,
    output logic [31:0] dm_data_in,
    output logic [31:0] dm_data_out
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
                alu_blts = 5'd13
                alu_bltu = 5'd14,
                alu_bges = 5'd15,
                alu_bgeu = 5'd16;

/* ALU_Control */
wire [4:0] alu_ctrl;

ALU_Control ALU_Control1(
    /* input */
    .funct7(),
    .funct3(),
    .opcode(),
    /* output */
    .alu_ctrl(alu_ctrl)
);

endmodule