module Add4 (
    input [31:0] in,
    output logic [31:0] out
);

always_comb begin
    out = in + 32'd4;
end
    
endmodule

module Add_1_1 (
    input [31:0] in1,
    input [31:0] in2,
    output logic [31:0] out
);

always_comb begin
    out = in1 + in2;
end
    
endmodule