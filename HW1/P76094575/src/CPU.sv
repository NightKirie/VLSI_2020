`include "Adder.sv"
`include "ALU_Control.sv"
`include "ALU.sv"
`include "Branch_Control.sv"
`include "Control_Unit.sv"
`include "DM_Write_Gen.sv"
`include "EX_MEM_reg.sv"
`include "Forward_Control.sv"
`include "Hazard_Control.sv"
`include "ID_EX_reg.sv"
`include "IF_ID_reg.sv"
`include "IM_Mux.sv"
`include "Imm_Gen.sv"
`include "MEM_WB_reg.sv"
`include "Mux.sv"
`include "PC.sv"
`include "Register.sv"

module CPU (
    input clk,
    input rst,
    input [31:0] im_data_out,
    input [31:0] dm_data_out,
    output [31:0] im_addr,
    output [3:0] dm_write_en,
    output [31:0] dm_addr,
    output [31:0] dm_data_in
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

/* Name rule: MainModule_Pin */

/* PC */
/* input */
wire [31:0] PC_pc_in;
wire PC_stall;
wire [31:0] PC_pc_out;
PC PC_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .PC_stall(PC_stall),
    .pc_in(PC_pc_in),
    /* output */
    .pc_out(im_addr)
);


/* PC+4 in IF */
/* output */
wire [31:0] IF_PC_Add_4_pc_out;
Add4 IF_PC_Add_4(
    /* input */
    .in(im_addr),
    /* output */
    .out(IF_PC_Add_4_pc_out)
);

/* Mux before PC */
/* input */
wire [31:0] EX_MEM_reg_pc_add_imm;
wire [1:0] branch_ctrl;
Mux_3_1 PC_Mux(
    /* input */
    .in1(IF_PC_Add_4_pc_out),
    .in2(dm_addr),
    .in3(EX_MEM_reg_pc_add_imm),
    .sel(branch_ctrl),
    /* output */
    .out(PC_pc_in)
);

/* IF_ID_reg */
/* input */
wire IF_ID_stall;
wire IF_ID_flush;
/* output */
wire [31:0] IF_ID_reg_pc;
wire [31:0] IF_ID_reg_instr_out;
IF_ID_reg IF_ID_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .IF_ID_stall(IF_ID_stall),
    .IF_ID_flush(IF_ID_flush),
    .pc_in(im_addr),
    .instr_in(im_data_out),
    /* output */
    .pc_out(IF_ID_reg_pc),
    .instr_out(IF_ID_reg_instr_out)
);

/* Mux after IM */
/* input */
wire IM_flush;
wire IM_stall;
/* output */
wire [31:0] IM_instr;
IM_Mux IM_Mux_1(
    /* input */
    .instr_1(im_data_out),
    .instr_2(IF_ID_reg_instr_out),
    .IM_stall(IM_stall),
    .IM_flush(IM_flush),
    /* output */
    .instr_out(IM_instr)
);

/* Register */
/* input */
wire [4:0] MEM_WB_reg_wr_addr;
wire [31:0] MEM_WB_Mux_wd;
wire MEM_WB_reg_reg_w;
/* output */
wire [31:0] Register_rr1_data,
            Register_rr2_data;
Register Register_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .rr1_addr(IM_instr[19:15]),
    .rr2_addr(IM_instr[24:20]),
    .wr_addr(MEM_WB_reg_wr_addr),
    .wd(MEM_WB_Mux_wd),
    .reg_w(MEM_WB_reg_reg_w),
    /* output */
    .rr1_data(Register_rr1_data),
    .rr2_data(Register_rr2_data)
);

/* Control Unit */
/* output */
wire rd_src, 
     alu_in2_sel, 
     pc_src, 
     wb_sel, 
     imm_sel, 
     reg_w, 
     mem_r,
     mem_w,
     disable_stall;
Control_Unit Control_Unit_1(
    /* input */
    .opcode(IM_instr[6:0]),
    /* output */
    .rd_src(rd_src),
    .alu_in2_sel(alu_in2_sel),
    .pc_src(pc_src),
    .wb_sel(wb_sel),
    .imm_sel(imm_sel),
    .reg_w(reg_w),
    .mem_r(mem_r),
    .mem_w(mem_w),
    .disable_stall(disable_stall)
);


/* Immediate Generator */
/* output */
wire [31:0] Imm_Gen_imm_out;
Imm_Gen Imm_Gen_1(
    /* input */
    .imm_sel(imm_sel),
    .imm_in(IM_instr),
    /* output */
    .imm_out(Imm_Gen_imm_out)
);

/* ALU Control */
/* output */
wire [4:0] alu_ctrl;
ALU_Control ALU_Control_1(
    /* input */
    .funct7(IM_instr[31:25]),
    .funct3(IM_instr[14:12]),
    .opcode(IM_instr[6:0]),
    /* output */
    .alu_ctrl(alu_ctrl)
);

/* ID_EX_reg */
/* input */
wire ID_EX_stall;
wire ID_EX_flush;
/* output */
wire ID_EX_reg_rd_src, 
     ID_EX_reg_alu_in2_sel, 
     ID_EX_reg_pc_src, 
     ID_EX_reg_wb_sel, 
     ID_EX_reg_reg_w, 
     ID_EX_reg_mem_r,
     ID_EX_reg_mem_w,
     ID_EX_reg_disable_stall;
wire [31:0] ID_EX_reg_pc,
            ID_EX_reg_rr1_data,
            ID_EX_reg_rr2_data,
            ID_EX_reg_imm;
wire [6:0] ID_EX_reg_opcode;
wire [2:0] ID_EX_reg_funct3;
wire [4:0] ID_EX_reg_rr1_addr,
           ID_EX_reg_rr2_addr,
           ID_EX_reg_wr_addr,
           ID_EX_reg_alu_ctrl;
ID_EX_reg ID_EX_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .ID_EX_stall(ID_EX_stall),
    .ID_EX_flush(ID_EX_flush),
    .rd_src_in(rd_src),
    .alu_in2_sel_in(alu_in2_sel),
    .pc_src_in(pc_src),
    .wb_sel_in(wb_sel),
    .reg_w_in(reg_w),
    .mem_r_in(mem_r),
    .mem_w_in(mem_w),
    .disable_stall_in(disable_stall),
    .pc_in(IF_ID_reg_pc),
    .rr1_data_in(Register_rr1_data),
    .rr2_data_in(Register_rr2_data),
    .rr1_addr_in(IM_instr[19:15]),
    .rr2_addr_in(IM_instr[24:20]),
    .wr_addr_in(IM_instr[11:7]),
    .alu_ctrl_in(alu_ctrl),
    .imm_in(Imm_Gen_imm_out),
    .opcode_in(IM_instr[6:0]),
    .funct3_in(IM_instr[14:12]),
    /* output */
    .rd_src_out(ID_EX_reg_rd_src),
    .alu_in2_sel_out(ID_EX_reg_alu_in2_sel),
    .pc_src_out(ID_EX_reg_pc_src),
    .wb_sel_out(ID_EX_reg_wb_sel),
    .reg_w_out(ID_EX_reg_reg_w),
    .mem_r_out(ID_EX_reg_mem_r),
    .mem_w_out(ID_EX_reg_mem_w),
    .disable_stall_out(ID_EX_reg_disable_stall),
    .pc_out(ID_EX_reg_pc),
    .rr1_data_out(ID_EX_reg_rr1_data),
    .rr2_data_out(ID_EX_reg_rr2_data),
    .rr1_addr_out(ID_EX_reg_rr1_addr),
    .rr2_addr_out(ID_EX_reg_rr2_addr),
    .wr_addr_out(ID_EX_reg_wr_addr),
    .alu_ctrl_out(ID_EX_reg_alu_ctrl),
    .imm_out(ID_EX_reg_imm),
    .opcode_out(ID_EX_reg_opcode),
    .funct3_out(ID_EX_reg_funct3)
);

/* rr1_data forwarding mux */
/* input */
wire [31:0] rd_rb_dm_forward_data;
wire [31:0] Rd_Src_Mux_data;
wire [1:0] forward_alu_in1;
/* output */
wire [31:0] RR1_Data_Mux_alu_in1;
Mux_3_1 RR1_Data_Mux(
    /* input */
    .in1(ID_EX_reg_rr1_data),
    .in2(MEM_WB_Mux_wd),
    .in3(rd_rb_dm_forward_data),
    .sel(forward_alu_in1),
    /* output */
    .out(RR1_Data_Mux_alu_in1)
);

/* rr2_data forwarding mux */
/* input */
wire [1:0] forward_alu_in2;
/* output */
wire [31:0] RR2_Data_Mux_alu_in2;
Mux_3_1 RR2_Data_Mux(
    /* input */
    .in1(ID_EX_reg_rr2_data),
    .in2(MEM_WB_Mux_wd),
    .in3(rd_rb_dm_forward_data),
    .sel(forward_alu_in2),
    /* output */
    .out(RR2_Data_Mux_alu_in2)
);

/* rr2_data & imm selector */
/* output */
wire [31:0] RR2_Imm_Mux_alu_in2;
Mux_2_1 RR2_Imm_Mux(
    /* input */
    .in1(RR2_Data_Mux_alu_in2),
    .in2(ID_EX_reg_imm),
    .sel(ID_EX_reg_alu_in2_sel),
    /* output */
    .out(RR2_Imm_Mux_alu_in2)
);

/* ALU */
/* output */
wire [31:0] ALU_alu_out;
wire ALU_branch_flag;
ALU ALU_1(
    /* input */
    .alu_ctrl(ID_EX_reg_alu_ctrl),
    .alu_in1(RR1_Data_Mux_alu_in1),
    .alu_in2(RR2_Imm_Mux_alu_in2),
    /* output */
    .alu_out(ALU_alu_out),
    .branch_flag(ALU_branch_flag)
);

/* PC+4 in EX */
/* output */
wire [31:0] EX_PC_Add_4_pc_out;
Add4 EX_PC_Add_4(
    /* input */
    .in(ID_EX_reg_pc),
    /* output */
    .out(EX_PC_Add_4_pc_out)
);

/* PC+imm in EX */
/* output */
wire [31:0] PC_Mux_pc_imm;
Add_1_1 EX_PC_Add_Imm(
    /* input */
    .in1(ID_EX_reg_pc),
    .in2(ID_EX_reg_imm),
    /* output */
    .out(PC_Mux_pc_imm)
);

/* Mux for PC+4 and PC+imm */
/* output */
wire [31:0] Pc_Src_Mux_pc;
Mux_2_1 Pc_Src_Mux(
    /* input */
    .in1(EX_PC_Add_4_pc_out),
    .in2(PC_Mux_pc_imm),
    .sel(ID_EX_reg_pc_src),
    /* output */
    .out(Pc_Src_Mux_pc)
);


/* EX_MEM_reg */
/* output */
wire EX_MEM_stall,
     EX_MEM_flush,
     EX_MEM_reg_rd_src,
     EX_MEM_reg_wb_sel,
     EX_MEM_reg_reg_w,
     EX_MEM_reg_mem_r,
     EX_MEM_reg_mem_w,
     EX_MEM_reg_disable_stall;
wire [2:0] EX_MEM_reg_funct3;
wire [31:0] EX_MEM_reg_pc,
            EX_MEM_reg_rr2_data;
wire [4:0] EX_MEM_reg_wr_addr,
           EX_MEM_reg_rr2_addr;
wire [1:0] EX_MEM_reg_branch_flag;
wire [6:0] EX_MEM_reg_opcode;
EX_MEM_reg EX_MEM_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .EX_MEM_stall(EX_MEM_stall),
    .EX_MEM_flush(EX_MEM_flush),
    .rd_src_in(ID_EX_reg_rd_src),
    .wb_sel_in(ID_EX_reg_wb_sel),
    .reg_w_in(ID_EX_reg_reg_w),
    .mem_r_in(ID_EX_reg_mem_r),
    .mem_w_in(ID_EX_reg_mem_w),
    .disable_stall_in(ID_EX_reg_disable_stall),
    .pc_in(Pc_Src_Mux_pc),
    .alu_in(ALU_alu_out),
    .rr2_addr_in(ID_EX_reg_rr2_addr),
    .rr2_data_in(RR2_Data_Mux_alu_in2),
    .wr_addr_in(ID_EX_reg_wr_addr),
    .opcode_in(ID_EX_reg_opcode),
    .funct3_in(ID_EX_reg_funct3),
    .branch_flag_in(ALU_branch_flag),
    .pc_add_imm_in(PC_Mux_pc_imm),
    /* output */
    .rd_src_out(EX_MEM_reg_rd_src),
    .wb_sel_out(EX_MEM_reg_wb_sel),
    .reg_w_out(EX_MEM_reg_reg_w),
    .mem_r_out(EX_MEM_reg_mem_r),
    .mem_w_out(EX_MEM_reg_mem_w),
    .disable_stall_out(EX_MEM_reg_disable_stall),
    .pc_out(EX_MEM_reg_pc),
    .alu_out(dm_addr),
    .rr2_addr_out(EX_MEM_reg_rr2_addr),
    .rr2_data_out(EX_MEM_reg_rr2_data),
    .wr_addr_out(EX_MEM_reg_wr_addr),
    .opcode_out(EX_MEM_reg_opcode),
    .funct3_out(EX_MEM_reg_funct3),
    .branch_flag_out(EX_MEM_reg_branch_flag),
    .pc_add_imm_out(EX_MEM_reg_pc_add_imm)
);


/* Generate data for DM write in */
/* input */
wire [31:0] w_data_out;
DM_Write_Gen DM_Write_Gen_1(
    /* input */
    .funct3(EX_MEM_reg_funct3),
    .alu(dm_addr),
    .data(w_data_out),
    .mem_w(EX_MEM_reg_mem_w),
    /* output */
    .write_en(dm_write_en),
    .write_data(dm_data_in)
);

/* Branch Control */

Branch_Control Branch_Control_1(
    /* input */
    .opcode(EX_MEM_reg_opcode),
    .branch_flag(EX_MEM_reg_branch_flag),
    /* output */
    .branch_ctrl(branch_ctrl)
);

/* Hazard Control */
/* input */
wire MEM_WB_stall; 
Hazard_Contorl Hazard_Contorl_1(
    /* input */
    .branch_ctrl(branch_ctrl),
    .EX_MEM_mem_r(EX_MEM_reg_mem_r),
    .EX_MEM_reg_disable_stall(EX_MEM_reg_disable_stall),
    /* output */
    .PC_stall(PC_stall),
    .IM_stall(IM_stall),
    .IF_ID_stall(IF_ID_stall),    
    .ID_EX_stall(ID_EX_stall),
    .EX_MEM_stall(EX_MEM_stall),
    .MEM_WB_stall(MEM_WB_stall),
    .IM_flush(IM_flush),
    .IF_ID_flush(IF_ID_flush),
    .ID_EX_flush(ID_EX_flush),
    .EX_MEM_flush(EX_MEM_flush)
);

/* Mux for choose pc or alu for forwarding */
Mux_2_1 Rd_Src_Mux(
    /* input */
    .in1(EX_MEM_reg_pc),
    .in2(dm_addr),
    .sel(EX_MEM_reg_rd_src),
    /* output */
    .out(Rd_Src_Mux_data)
);

/* Mux for w_data forwarding or not */
/* input */
wire forward_w_data;
Mux_2_1 W_Data_Mux(
    /* input */
    .in1(EX_MEM_reg_rr2_data),
    .in2(MEM_WB_Mux_wd),
    .sel(forward_w_data),
    /* output */
    .out(w_data_out)
);

/* For LW & LB */
wire [31:0] LW_LB_dm_data = (EX_MEM_reg_funct3 == 3'b000) ? {{24{dm_data_out[7]}}, dm_data_out[7:0]} : dm_data_out;

/* If DM read, need to forward data */
Mux_2_1 Rd_Rb_DM_Mux(
    /* input */
    .in1(Rd_Src_Mux_data),
    .in2(LW_LB_dm_data),
    .sel(EX_MEM_reg_mem_r),
    /* output */
    .out(rd_rb_dm_forward_data)
);

/* Forward_Control */
Forward_Control Forward_Control_1(
    /* input */
    .EX_MEM_wr_addr(EX_MEM_reg_wr_addr),
    .MEM_WB_wr_addr(MEM_WB_reg_wr_addr),
    .ID_EX_rr1_addr(ID_EX_reg_rr1_addr),
    .ID_EX_rr2_addr(ID_EX_reg_rr2_addr),
    .EX_MEM_rr2_addr(EX_MEM_reg_rr2_addr),
    .EX_MEM_reg_w(EX_MEM_reg_reg_w),
    .MEM_WB_reg_w(MEM_WB_reg_reg_w),
    .EX_MEM_mem_w(EX_MEM_reg_mem_w),
    /* output */
    .forward_alu_in1(forward_alu_in1),
    .forward_alu_in2(forward_alu_in2),
    .forward_data_memory(forward_w_data)
);

/* MEM_WB_reg */
/* input */
wire MEM_WB_reg_wb_sel;
wire [31:0] MEM_WB_reg_rd_data,
            MEM_WB_reg_rb_data;
MEM_WB_reg MEM_WB_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .MEM_WB_stall(MEM_WB_stall),
    .wb_sel_in(EX_MEM_reg_wb_sel),
    .reg_w_in(EX_MEM_reg_reg_w),
    .rd_data_in(Rd_Src_Mux_data),
    .rb_data_in(LW_LB_dm_data),
    .wr_addr_in(EX_MEM_reg_wr_addr),
    /* output */
    .wb_sel_out(MEM_WB_reg_wb_sel),
    .reg_w_out(MEM_WB_reg_reg_w),
    .rd_data_out(MEM_WB_reg_rd_data),
    .rb_data_out(MEM_WB_reg_rb_data),
    .wr_addr_out(MEM_WB_reg_wr_addr)
);

/* rd_data & rb_data mux */
Mux_2_1 Rd_Rb_Mux(
    /* input */
    .in1(MEM_WB_reg_rd_data),
    .in2(MEM_WB_reg_rb_data),
    .sel(MEM_WB_reg_wb_sel),
    /* output */
    .out(MEM_WB_Mux_wd)
);



endmodule