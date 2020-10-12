module IF_ID_reg (
    input clk,
    input rst,
    input IF_ID_stall,
    input IF_ID_flush,
    input [31:0] pc_in,
    input [31:0] instr_in,
    output logic [31:0] pc_out,
    output logic [31:0] instr_out
);

always_ff @(posedge clk, posedge rst) begin
    if(rst || IF_ID_flush) begin
        pc_out <= 32'd0;
        instr_out <= 32'd0;
    end
    else if(!IF_ID_stall) begin
        pc_out <= pc_in; 
        instr_out <= instr_in;  
    end
    else begin
        instr_out <= instr_in;  
    end
end
    
endmodule