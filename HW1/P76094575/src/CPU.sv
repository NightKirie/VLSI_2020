`include "Adder.sv"
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
    output dm_write_en,
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
wire [31:0] PC_Mux_rr1_imm,
            PC_Mux_pc_imm;
wire [1:0] branch_ctrl;
Mux_3_1 PC_Mux(
    /* input */
    .in1(IF_PC_Add_4_pc_out),
    .in2(PC_Mux_rr1_imm),
    .in3(PC_Mux_pc_imm),
    .sel(branch_ctrl),
    /* output */
    .out(PC_pc_in)
);

/* Mux after IM */
/* input */
wire IM_flush;
/* output */
wire [31:0] IM_instr;
Mux_2_1 IM_Mux(
    /* input */
    .in1(im_data_out),
    .in2(32'd0),
    .sel(IM_flush),
    /* output */
    .out(IM_instr)
);

/* IF_ID_reg */
/* input */
wire IF_ID_stall;
/* output */
wire [31:0] IF_ID_reg_pc,
            IF_ID_reg_instr;
IF_ID_reg IF_ID_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .IF_ID_stall(IF_ID_stall),
    .pc_in(im_addr),
    .instr_in(IM_instr),
    /* output */
    .pc_out(IF_ID_reg_pc),
    .instr_out(IF_ID_reg_instr)
);

/* Register */
/* input */
wire [4:0] MEM_WB_reg_wr_addr;
wire [31:0] MEM_WB_Mux_wd;
wire MEM_WB_reg_w;
/* output */
wire [31:0] Register_rr1_data,
            Register_rr2_data;
Register Register_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .rr1_addr(IF_ID_reg_instr[19:15]),
    .rr2_addr(IF_ID_reg_instr[24:20]),
    .wr_addr(MEM_WB_reg_wr_addr),
    .wd(MEM_WB_Mux_wd),
    .reg_w(MEM_WB_reg_w),
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
     mem_w;
Control_Unit Control_Unit_1(
    /* input */
    .opcode(IF_ID_reg_instr[6:0]),
    /* output */
    .rd_src(rd_src),
    .alu_in2_sel(alu_in2_sel),
    .pc_src(pc_src),
    .wb_sel(wb_sel),
    .imm_sel(imm_sel),
    .reg_w(reg_w),
    .mem_r(mem_r),
    .mem_w(mem_w)
);


/* Immediate Generator */
/* output */
wire [31:0] Imm_Gen_imm_out;
Imm_Gen Imm_Gen_1(
    /* input */
    .imm_sel(imm_sel),
    .imm_in(IF_ID_reg_instr),
    /* output */
    .imm_out(Imm_Gen_imm_out)
);

/* ALU Control */
/* output */
wire [4:0] alu_ctrl;
ALU_Control ALU_Control_1(
    /* input */
    .funct7(IF_ID_reg_instr[31:25]),
    .funct3(IF_ID_reg_instr[14:12]),
    .opcode(IF_ID_reg_instr[6:0]),
    /* output */
    .alu_ctrl(alu_ctrl)
);

/* Mux after Control Unit */
/* input */
wire Control_Unit_flush;
/* output */
wire rd_src_mux, 
     alu_in2_sel_mux, 
     pc_src_mux,
     wb_sel_mux, 
     reg_w_mux, 
     mem_r_mux,
     mem_w_mux;
Mux_7_7 Control_Unit_Mux(
    /* input */
    .in1(rd_src),
    .in2(alu_in2_sel),
    .in3(pc_src),
    .in4(wb_sel),
    .in5(reg_w),
    .in6(mem_r),
    .in7(mem_w),
    .sel(Control_Unit_flush),
    /* output */
    .out1(rd_src_mux),
    .out2(alu_in2_sel_mux),
    .out3(pc_src_mux),
    .out4(wb_sel_mux),
    .out5(reg_w_mux),
    .out6(mem_r_mux),
    .out7(mem_w_mux)
);

/* ID_EX_reg */
/* output */
wire ID_EX_reg_rd_src, 
     ID_EX_reg_alu_in2_sel, 
     ID_EX_reg_pc_src, 
     ID_EX_reg_wb_sel, 
     ID_EX_reg_reg_w, 
     ID_EX_reg_mem_r,
     ID_EX_reg_mem_w;
wire [31:0] ID_EX_reg_pc,
            ID_EX_reg_rr1_data,
            ID_EX_reg_rr2_data,
            ID_EX_reg_imm;
wire [6:0] ID_EX_reg_opcode;
wire [4:0] ID_EX_reg_rr1_addr,
           ID_EX_reg_rr2_addr,
           ID_EX_reg_wr_addr,
           ID_EX_reg_alu_ctrl;
ID_EX_reg ID_EX_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .rd_src_in(rd_src_mux),
    .alu_in2_sel_in(alu_in2_sel_mux),
    .pc_src_in(pc_src_mux),
    .wb_sel_in(wb_sel_mux),
    .reg_w_in(reg_w_mux),
    .mem_r_in(mem_r_mux),
    .mem_w_in(mem_w_mux),
    .pc_in(IF_ID_reg_pc),
    .rr1_data_in(Register_rr1_data),
    .rr2_data_in(Register_rr2_data),
    .rr1_addr_in(IF_ID_reg_instr[19:15]),
    .rr2_addr_in(IF_ID_reg_instr[24:20]),
    .wr_addr_in(IF_ID_reg_instr[11:7]),
    .alu_ctrl_in(alu_ctrl),
    .imm_in(Imm_Gen_imm_out),
    .opcode_in(IF_ID_reg_instr[6:0]),
    /* output */
    .rd_src_out(ID_EX_reg_rd_src),
    .alu_in2_sel_out(ID_EX_reg_alu_in2_sel),
    .pc_src_out(ID_EX_reg_pc_src),
    .wb_sel_out(ID_EX_reg_wb_sel),
    .reg_w_out(ID_EX_reg_reg_w),
    .mem_r_out(ID_EX_reg_mem_r),
    .mem_w_out(ID_EX_reg_mem_w),
    .pc_out(ID_EX_reg_pc),
    .rr1_data_out(ID_EX_reg_rr1_data),
    .rr2_data_out(ID_EX_reg_rr2_data),
    .rr1_addr_out(ID_EX_reg_rr1_addr),
    .rr2_addr_out(ID_EX_reg_rr2_addr),
    .wr_addr_out(ID_EX_reg_wr_addr),
    .alu_ctrl_out(ID_EX_reg_alu_ctrl),
    .imm_out(ID_EX_reg_imm),
    .opcode_out(ID_EX_reg_opcode)
);

/* rr1_data forwarding mux */
/* input */
wire [31:0] Rd_Src_Mux_data;
wire [1:0] forward_alu_in1;
/* output */
wire [31:0] RR1_Data_Mux_alu_in1;
Mux_3_1 RR1_Data_Mux(
    /* input */
    .in1(ID_EX_reg_rr1_data),
    .in2(MEM_WB_Mux_wd),
    .in3(Rd_Src_Mux_data),
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
    .in3(Rd_Src_Mux_data),
    .sel(forward_alu_in1),
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
    .sel(alu_in2_sel_mux),
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
wire [31:0] EX_PC_Add_Imm_pc_out;
Add_1_1 EX_PC_Add_Imm(
    /* input */
    .in1(ID_EX_reg_pc),
    .in2(ID_EX_reg_imm),
    /* output */
    .out(EX_PC_Add_Imm_pc_out)
);

/* Mux for PC+4 and PC+imm */
/* output */
wire [31:0] Pc_Src_Mux_pc;
Mux_2_1 Pc_Src_Mux(
    /* input */
    .in1(EX_PC_Add_4_pc_out),
    .in2(EX_PC_Add_Imm_pc_out),
    .sel(ID_EX_reg_pc_src),
    /* output */
    .out(Pc_Src_Mux_pc)
);

/* Branch Control */
Branch_Control Branch_Control_1(
    /* input */
    .opcode(ID_EX_reg_opcode),
    .branch_flag(ALU_branch_flag),
    /* output */
    .branch_ctrl(branch_ctrl)
);

/* Hazard Control */
Hazard_Contorl Hazard_Contorl_1(
    /* input */
    .branch_ctrl(branch_ctrl),
    .ID_EX_mem_r(ID_EX_reg_mem_r),
    .IF_ID_rr1_addr(IF_ID_reg_instr[19:15]),
    .IF_ID_rr2_addr(IF_ID_reg_instr[24:20]),
    .ID_EX_rr1_addr(ID_EX_reg_rr1_data),
    /* output */
    .PC_stall(PC_stall),
    .IM_flush(IM_flush),
    .IF_ID_stall(IF_ID_stall),    
    .Control_Unit_flush(Control_Unit_flush)
);

/* EX_MEM_reg */
/* output */
wire EX_MEM_reg_rd_src,
     EX_MEM_reg_wb_sel,
     EX_MEM_reg_reg_w,
     EX_MEM_reg_mem_r,
     EX_MEM_reg_mem_w;
wire [31:0] EX_MEM_reg_pc,
            EX_MEM_reg_lu; 
wire [4:0] EX_MEM_reg_rr2_addr,
           EX_MEM_reg_wr_addr;
EX_MEM_reg EX_MEM_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .rd_src_in(ID_EX_reg_rd_src),
    .wb_sel_in(ID_EX_reg_wb_sel),
    .reg_w_in(ID_EX_reg_reg_w),
    .mem_r_in(ID_EX_reg_mem_r),
    .mem_w_in(ID_EX_reg_mem_w),
    .pc_in(Pc_Src_Mux_pc),
    .alu_in(ALU_alu_out),
    .rr2_addr_in(RR2_Data_Mux_alu_in2),
    .wr_addr_in(ID_EX_reg_wr_addr),
    /* output */
    .rd_src_out(EX_MEM_reg_rd_src),
    .wb_sel_out(EX_MEM_reg_wb_sel),
    .reg_w_out(EX_MEM_reg_reg_w),
    .mem_r_out(EX_MEM_reg_mem_r),
    .mem_w_out(EX_MEM_reg_mem_w),
    .pc_out(EX_MEM_reg_pc),
    .alu_out(dm_addr),
    .rr2_addr_out(EX_MEM_reg_rr2_addr),
    .wr_addr_out(EX_MEM_reg_wr_addr)
);
assign dm_write_en = (EX_MEM_reg_mem_w) ? 0 : 4'b1111;


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
    .in2(Rd_Src_Mux_data),
    .sel(forward_w_data),
    /* output */
    .out(dm_data_in)
);

/* Forward_Control */
wire MEM_WB_reg_reg_w;
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
wire MEM_WB_reg_wb_sel;
wire [31:0] MEM_WB_reg_rd_data,
            MEM_WB_reg_rb_data;
MEM_WB_reg MEM_WB_reg_1(
    /* input */
    .clk(clk),
    .rst(rst),
    .wb_sel_in(EX_MEM_reg_wb_sel),
    .reg_w_in(EX_MEM_reg_reg_w),
    .rd_data_in(Rd_Src_Mux_data),
    .rb_data_in(dm_data_out),
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