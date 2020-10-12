module IM_Mux (
    input [31:0] instr_1,
    input [31:0] instr_2,
    input IM_stall,
    input IM_flush,
    output logic [31:0] instr_out
);

always_comb begin
    if(IM_flush) begin
        instr_out <= 32'd0;
    end
    else if(IM_stall) begin
        instr_out <= instr_2;
    end
    else begin
        instr_out <= instr_1;
    end
end

    
endmodule