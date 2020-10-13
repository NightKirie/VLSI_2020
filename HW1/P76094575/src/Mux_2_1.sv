module Mux_2_1 (
    input [31:0] in1,
    input [31:0] in2,
    input sel,
    output logic [31:0] out
);

always_comb begin
    case (sel)
        1'b0:
            out = in1;
        1'b1:
            out = in2;
    endcase
end 

endmodule
