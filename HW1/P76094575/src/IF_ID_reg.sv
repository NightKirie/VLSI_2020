module IF_ID_reg (
    input clk,
    input rst,
    input IF_ID_Hazard,
    input [31:0] pc_in,
    input [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out,
);

always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        pc_out <= 32'd0;
        instr_out <= 32'd0;
    end
    else begin
        if(!IF_ID_Hazard) begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
end
    
endmodule