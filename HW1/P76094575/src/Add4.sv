module Add4 (
    input [31:0] in,
    output logic [31:0] out
);

always_comb begin
    out = in + 32'd4;
end

endmodule
