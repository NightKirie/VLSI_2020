module Mux_3_32_to_1_32 (
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [1:0] sel,
    output logic [31:0] out
);

always_comb begin
    case (sel)
        2'b00:
            out = in1;
        2'b01:
            out = in2;
        2'b10:
            out = in3;
        default: 
            out = 32'd0;
    endcase
end

module Mux_2_32_1_32 (
    input [31:0] in1,
    input [31:0] in2,
    input sel,
    output logic [31:0] out
);

always_comb begin
    case (sel)
        0:
            out = in1;
        1:
            out = in2;
    endcase
end 
   
endmodule
    
endmodule